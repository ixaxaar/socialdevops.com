{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Routes where

import Servant.API

import Thing
import Version


-- /api/version and /health
type GetVersionAPI = "api" :> "version" :> Get '[JSON] Version

type HealthAPI = "health" :> Get '[JSON] Version

-- CRUD on Thing
type ThingCRUD = "thing" :> Capture "id" Int                 :> Get '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingPostBody    :> Post '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingPatchBody   :> Patch '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingDeleteBody  :> Delete '[JSON] Thing

-- Combine all routes
type API = HealthAPI :<|> GetVersionAPI :<|> ThingCRUD

