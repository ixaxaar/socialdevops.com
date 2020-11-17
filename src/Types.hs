module Types where

data Environment = Development | Sandbox | QA | Production deriving (Eq,Ord,Enum,Show)

data Version = Version {
  hash  :: String,
  major :: String,
  minor :: String,
  db    :: Bool
}
