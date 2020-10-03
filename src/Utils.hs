module Utils where

import Data.Maybe

getOrElse :: Maybe a -> a -> a
getOrElse (Just v) d = v
getOrElse Nothing d = d

getOrDefaultTo :: IO (Maybe a) -> a -> IO a
getOrDefaultTo ioma def = fmap (\x -> getOrElse x def) ioma

