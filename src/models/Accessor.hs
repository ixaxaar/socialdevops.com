{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE UndecidableInstances #-}

module Accessor where

import GHC.Generics

import Database.Beam
import Database.Beam.Postgres
import Database.Beam.Migrate
import Database.Beam.Postgres.Migrate
import Database.Beam.Backend.SQL

import Data.Text (Text)
import Data.Time
import Data.UUID


data AccessorT f = AccessorT {
  _accessorID :: Columnar f UUID,
  _token      :: Columnar f Text
} deriving Generic

instance Table AccessorT where
  data PrimaryKey AccessorT f = AccessorID (Columnar f UUID) deriving Generic
  primaryKey = AccessorID . _accessorID

type Accessor = AccessorT Identity
deriving instance Show Accessor
deriving instance Eq Accessor

type AccessorID = PrimaryKey AccessorT Identity
deriving instance Show AccessorID
deriving instance Eq AccessorID

instance Beamable (PrimaryKey AccessorT)
instance Beamable AccessorT
