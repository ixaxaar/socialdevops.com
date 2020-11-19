module Version where

import Config

data Version = Version {
  hash  :: String,
  major :: String,
  minor :: String,
  db    :: Bool
}

---------- Handlers

-- GET
getVersion :: IO Version
getVersion = do
  major <- majorVersion
  minor <- minorVersion
  fmap (\x -> Version x major minor True) commitHash
