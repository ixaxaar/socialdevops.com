module Logging where

import Data.Default

import Network.Wai
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.RequestLogger.JSON

import Types
import Config

makeLog :: Application -> Environment -> IO Middleware
makeLog app e = do
  let loggerSettings = def {
    outputFormat = if e == Development
        then Detailed True
        else CustomOutputFormatWithDetailsAndHeaders formatAsJSONWithHeaders
    , autoFlush = True
  }
  mkRequestLogger loggerSettings

