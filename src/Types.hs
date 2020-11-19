module Types where

data Environment = Development | Sandbox | QA | Production deriving (Eq,Ord,Enum,Show)

newtype Bearer = Bearer { token :: String}
