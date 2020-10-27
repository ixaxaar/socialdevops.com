module Utils where

import Data.Char

getOrElse :: Maybe a -> a -> a
getOrElse (Just v) d = v
getOrElse Nothing d = d

getOrDefaultTo :: IO (Maybe a) -> a -> IO a
getOrDefaultTo ioma def = fmap (\x -> getOrElse x def) ioma

toLowerString = \x -> map toLower x

headMaybe :: [a] -> Maybe a
headMaybe []     = Nothing
headMaybe (x:_) = Just x
