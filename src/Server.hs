{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}

module Server
    ( startApp
    , app
    ) where

import Control.Monad.IO.Class
import Control.Lens

import Data.Aeson ( defaultOptions )
import Data.Aeson.TH ( deriveJSON )
import Data.Streaming.Network.Internal ( HostPreference(Host) )
import Data.Swagger hiding (Host)
import Data.Swagger.Internal.Schema
import Data.Function
import Data.Text (Text)

import Network.Wai as WAI ( Application )
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.RequestLogger ()

import Servant
import qualified OpenTelemetry.Network.Wai.Middleware as WaiTelemetry
import Servant.Swagger

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

  putStrLn $ "Starting server on " ++ host ++ ":" ++ show portInt

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
app = serve allAPI server

api :: Proxy API
api = Proxy

allAPI :: Proxy AllAPI
allAPI = Proxy

swaggerDocs :: Handler Swagger
swaggerDocs = return $ toSwagger api
  & info.title   .~ "arda-haskell"
  & info.version .~ "1.0"
  & info.description ?~ "Template APIs"
  & info.license ?~ ("MIT" & url ?~ URL "http://mit.com")

server :: Server AllAPI
server = swaggerDocs
  :<|> getVersionHandler
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
