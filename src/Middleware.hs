module Middleware where

import qualified Data.ByteString.Char8 as C
import Data.ByteString.Lazy as LB ( toStrict )
import qualified Data.CaseInsensitive as CI

import Network.Wai
import Network.Wai.Internal ()

import Network.HTTP.Types as H ( Header )
import Network.HTTP.Types.Status ()
import Network.HTTP.Types.Header ()

import Data.UUID ( toByteString )
import Data.UUID.V4 as UUID ( nextRandom )
import Data.Binary.Builder as Builder ()


insertUUIDHeaderRequest :: Middleware
insertUUIDHeaderRequest app req sendResponse = do
  let traceHeader = newUUIDHeader
  let reqHeaders = fmap (\x -> requestHeaders req ++ [x]) traceHeader
  rH <- reqHeaders

  app req { requestHeaders = rH } sendResponse

insertUUIDHeaderResponse :: IO Header -> IO Middleware
insertUUIDHeaderResponse = fmap (\x -> modifyResponse $ addHeaders' [x])

addHeaders' :: [Header] -> Response -> Response
addHeaders' h = mapResponseHeaders (h ++)

newUUIDHeader :: IO Header
newUUIDHeader = do
  let ioUUID = UUID.nextRandom
  let uuid = fmap (LB.toStrict . toByteString) ioUUID

  let trace = CI.mk . C.pack $ "X-Trace-ID"
  fmap (\x -> (trace, x)) uuid

