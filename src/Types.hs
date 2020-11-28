{-# LANGUAGE DeriveGeneric #-}

module Types where

import Data.Aeson
import GHC.Generics


data Environment = Development | Sandbox | QA | Production deriving (Eq,Ord,Enum,Show)
