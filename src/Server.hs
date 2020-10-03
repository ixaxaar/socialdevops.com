{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
module Server
    ( startApp
    , app
    ) where

import Data.Aeson
import Data.Aeson.TH
import Data.Streaming.Network.Internal
import Data.UUID
import Data.UUID.V4 as UUID
import Data.CaseInsensitive as CI
import Data.ByteString ( ByteString )

import Network.Wai as WAI
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.RequestLogger

import Servant

import Types
import Config
import Logging


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

  let settings = setPort portInt $ setHost (Host host) $ setTimeout 300 $ setOnExceptionResponse (if environ == Development then exceptionResponseForDebug else defaultOnExceptionResponse) defaultSettings
  logger <- makeLog app environ
  runSettings settings (logger app)


-- Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
-- addRequestId :: Middleware
-- addRequestId app req sendRes = do
  -- reqId <- toASCIIBytes <$> UUID.nextRandom
  -- let hs = ("Request-ID", reqId) : WAI.requestHeaders req
  -- app (req { requestHeaders = (fromString "lol", "lel") : WAI.requestHeaders req }) sendRes
  -- req { requestHeaders = ("REMOTE_USER", "lol") }
  -- app (req { WAI.requestHeaders = hs }) sendRes

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
