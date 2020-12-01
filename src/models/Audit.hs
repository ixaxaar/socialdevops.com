{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE UndecidableInstances #-}

module Audit where

import GHC.Generics

import Database.Beam
import Database.Beam.Postgres
import Database.Beam.Migrate
import Database.Beam.Postgres.Migrate
import Database.Beam.Backend.SQL

import Data.Text (Text)
import Data.Time
import Data.UUID

import Accessor


data AuditT f = AuditT {
  _auditID     :: Columnar f UUID,
  _created_at  :: Columnar f LocalTime,
  _modified_at :: Columnar f LocalTime,
  _created_by  :: PrimaryKey AccessorT f,
  _modified_by :: PrimaryKey AccessorT f,
  _table       :: Columnar f Text,
  _tableKey    :: Columnar f Text
} deriving Generic

instance Table AuditT where
  data PrimaryKey AuditT f = AuditID (Columnar f UUID) deriving Generic
  primaryKey = AuditID . _auditID

type Audit = AuditT Identity
deriving instance Show Audit
deriving instance Eq Audit

type AuditID = PrimaryKey AuditT Identity
deriving instance Show AuditID
deriving instance Eq AuditID

instance Beamable (PrimaryKey AuditT)
instance Beamable AuditT
