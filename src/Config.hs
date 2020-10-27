module Config where

import System.Environment ( lookupEnv )
import System.IO ()

import Data.Maybe ()

import Control.Monad.Trans.Maybe ()

import Utils ( getOrDefaultTo, toLowerString )
import Types ( Environment(..) )

environment :: IO String
environment = getOrDefaultTo (lookupEnv "ENVIRONMENT") "development"

parseEnv :: String -> Environment
parseEnv s = case t of
    x | elem x ["development", "dev"]          -> Development
    x | elem x ["sandbox"]                     -> Sandbox
    x | elem x ["qa"]                          -> QA
    x | elem x ["production", "prod"]          -> Production
  where t = toLowerString s

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

