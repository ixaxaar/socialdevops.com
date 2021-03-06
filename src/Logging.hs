module Logging where

import Data.Default

import Network.Wai ( Application, Middleware )
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.RequestLogger.JSON

import Types

makeLog :: Environment -> IO Middleware
makeLog e = do
  let loggerSettings = def {
    outputFormat = if e == Development
        then Detailed True
        else CustomOutputFormatWithDetailsAndHeaders formatAsJSONWithHeaders
    , autoFlush = True
  }
  mkRequestLogger loggerSettings

