{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Routes where

import Servant.API
import Data.Swagger
import Data.Swagger.Internal.Schema

import Thing
import Version

-------------------------------------------------------------------------------------------
-- Status routes
-------------------------------------------------------------------------------------------

instance ToSchema Version

-- /api/version
type GetVersionAPI = "api" :> "version" :> Get '[JSON] Version

-- /health
type HealthAPI = "health" :> Get '[JSON] Version

-------------------------------------------------------------------------------------------
-- CRUD on Thing
-------------------------------------------------------------------------------------------

instance ToSchema TypeOfThing
instance ToSchema Thing
instance ToSchema ThingPostBody
instance ToSchema ThingPatchBody
instance ToSchema ThingDeleteBody

-- /api/thing
type ThingCRUD = "api" :> "thing" :> Capture "id" Int                 :> Get '[JSON] Thing
            :<|> "api" :> "thing" :> ReqBody '[JSON] ThingPostBody    :> Post '[JSON] Thing
            :<|> "api" :> "thing" :> ReqBody '[JSON] ThingPatchBody   :> Patch '[JSON] Thing
            :<|> "api" :> "thing" :> ReqBody '[JSON] ThingDeleteBody  :> Delete '[JSON] Thing

-------------------------------------------------------------------------------------------
-- Instrumentation routes
-------------------------------------------------------------------------------------------

-- Combine all routes
type API = HealthAPI :<|> GetVersionAPI :<|> ThingCRUD

-- /spec - Serve swagger JSON
type SwaggerAPI = "spec" :> Get '[JSON] Swagger

-- Final set of routes
type AllAPI = SwaggerAPI :<|> API
