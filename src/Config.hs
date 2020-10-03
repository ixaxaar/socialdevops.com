module Config where

import System.Environment ( lookupEnv )
import System.IO

import Data.Maybe

import Control.Monad.Trans.Maybe

import Utils
import Types

environment :: IO String
environment = getOrDefaultTo (lookupEnv "ENVIRONMENT") "development"

parseEnv :: String -> Environment
parseEnv s = case s of
  x | elem x ["Development", "development", "dev"] -> Development
  x | elem x ["Sandbox", "sandbox"]                -> Sandbox
  x | elem x ["QA", "qa"]                          -> QA
  x | elem x ["Production", "production", "prod"]  -> Production

applicationHost :: IO String
applicationHost = getOrDefaultTo (lookupEnv "APPLICATION_HOST") "localhost"

applicationPort :: IO String
applicationPort = getOrDefaultTo (lookupEnv "APPLICATION_PORT") "3000"

applicationSslPort :: IO String
applicationSslPort = getOrDefaultTo (lookupEnv "APPLICATION_SSL_PORT") "3001"

pgdatabase :: IO String
pgdatabase = getOrDefaultTo (lookupEnv "PGDATABASE") "socialdevops"

applicationPostgresHost :: IO String
applicationPostgresHost = getOrDefaultTo (lookupEnv "APPLICATION_POSTGRES_HOST") "localhost"

applicationPostgresUser :: IO String
applicationPostgresUser = getOrDefaultTo (lookupEnv "APPLICATION_POSTGRES_USER") "socialdevops"

applicationPostgresPort :: IO String
applicationPostgresPort = getOrDefaultTo (lookupEnv "APPLICATION_POSTGRES_PORT") "5432"

applicationPostgresDb :: IO String
applicationPostgresDb = getOrDefaultTo (lookupEnv "APPLICATION_POSTGRES_DB") "socialdevops"

applicationPostgresPw :: IO String
applicationPostgresPw = getOrDefaultTo (lookupEnv "APPLICATION_POSTGRES_PW") "socialdevops"

applicationDbPoolsize :: IO String
applicationDbPoolsize = getOrDefaultTo (lookupEnv "APPLICATION_DB_POOLSIZE") "10"

