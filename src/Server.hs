{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Server
    ( startApp
    , app
    ) where

import Data.Aeson ( defaultOptions )
import Data.Aeson.TH ( deriveJSON )
import Data.Streaming.Network.Internal ( HostPreference(Host) )
import Data.CaseInsensitive as CI ()

import Network.Wai as WAI ( Application )
import Network.Wai.Handler.Warp
    ( setHost,
      setOnExceptionResponse,
      setPort,
      setTimeout,
      runSettings,
      defaultOnExceptionResponse,
      defaultSettings,
      exceptionResponseForDebug )
import Network.Wai.Middleware.RequestLogger ()

import Servant
    ( Proxy(..), type (:>), Get, JSON, serve, Server )

import Types ( Environment(Development) )
import Config
    ( applicationHost, applicationPort, environment, parseEnv )
import Logging ( makeLog )
import Middleware

import OpenTelemetry.Eventlog ()
import qualified OpenTelemetry.Network.Wai.Middleware as WaiTelemetry
import OpenTelemetry.Propagation ()
import OpenTelemetry.SpanContext ()

data User = User
  { userId        :: Int
  , userFirstName :: String
  , userLastName  :: String
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''User)

type API = "users" :> Get '[JSON] [User]

startApp :: IO ()
startApp = do
  port        <- applicationPort
  host        <- applicationHost
  environment <- environment

  let environ = parseEnv environment
  let portInt = read port :: Int

  putStrLn $ "Starting server on " ++ host ++ ":" ++ (show portInt)

  let settings =
        setPort portInt $
        setHost (Host host) $
        setTimeout 300 $
        setOnExceptionResponse (if environ == Development then exceptionResponseForDebug else defaultOnExceptionResponse)
        defaultSettings
  telemetryMiddleware <- WaiTelemetry.mkMiddleware
  logger <- makeLog environ
  runSettings settings (insertUUIDHeaderRequest . telemetryMiddleware . logger $ app)

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = return users

users :: [User]
users = [ User 1 "Isaac" "Newton"
        , User 2 "Albert" "Einstein"
        ]
