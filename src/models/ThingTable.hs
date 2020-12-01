{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE UndecidableInstances #-}

module ThingTable where

import GHC.Generics

import Database.Beam
import Database.Beam.Postgres
import Database.Beam.Migrate
import Database.Beam.Postgres.Migrate
import Database.Beam.Backend.SQL

import Data.Text (Text)
import Data.Time
import Data.UUID

import Audit


data ThingT f = ThingT {
  _thingID   :: Columnar f UUID,
  _what      :: Columnar f Text,
  _name      :: Columnar f Text,
  _lastAudit :: PrimaryKey AuditT f
} deriving Generic

instance Table ThingT where
  data PrimaryKey ThingT f = ThingID (Columnar f UUID) deriving Generic
  primaryKey = ThingID . _thingID

type ThingTable = ThingT Identity
deriving instance Show ThingTable
deriving instance Eq ThingTable

type ThingID = PrimaryKey ThingT Identity
deriving instance Show ThingID
deriving instance Eq ThingID

instance Beamable (PrimaryKey ThingT)
instance Beamable ThingT
