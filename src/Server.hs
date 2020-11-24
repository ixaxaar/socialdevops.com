{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Server
    ( startApp
    , app
    ) where

import Control.Monad.IO.Class

import Data.Aeson ( defaultOptions )
import Data.Aeson.TH ( deriveJSON )
import Data.Streaming.Network.Internal ( HostPreference(Host) )

import Network.Wai as WAI ( Application )
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.RequestLogger ()

import Servant
import qualified OpenTelemetry.Network.Wai.Middleware as WaiTelemetry

import Types
import Config
import Logging ( makeLog )
import Middleware
import Routes
import Thing
import Version



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
server = getVersionHandler
  :<|> getVersionHandler
  :<|> getThingHandler
  :<|> postThingHandler
  :<|> patchThingHandler
  :<|> deleteThingHandler
  where
    getThingHandler :: Int -> Handler Thing
    getThingHandler x = return (getThing x)

    postThingHandler :: ThingPostBody -> Handler Thing
    postThingHandler x = return (postThing x)

    patchThingHandler :: ThingPatchBody -> Handler Thing
    patchThingHandler x = return (patchThing x)

    deleteThingHandler :: ThingDeleteBody -> Handler Thing
    deleteThingHandler x = return (deleteThing x)

    getVersionHandler :: Handler Version
    getVersionHandler = do liftIO getVersion

