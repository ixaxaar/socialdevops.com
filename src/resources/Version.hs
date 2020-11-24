{-# LANGUAGE DeriveGeneric         #-}

module Version where

import Data.Aeson
import GHC.Generics

import Config

data Version = Version {
  hash  :: String,
  major :: String,
  minor :: String,
  db    :: Bool
} deriving Generic

instance FromJSON Version
instance ToJSON Version


---------- Handlers

-- GET
getVersion :: IO Version
getVersion = do
  major <- majorVersion
  minor <- minorVersion
  fmap (\x -> Version x major minor True) commitHash
