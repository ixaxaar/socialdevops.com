{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Routes where

import Servant.API

import Types ( Bearer )
import Thing
    ( ThingDeleteBody, ThingPatchBody, ThingPostBody, Thing )
import Version ( Version )


-- /api/version and /health
type GetVersionAPI = "api" :> "version" :> Get '[JSON] Version
                :<|> "health"           :> Get '[JSON] Version

-- CRUD on Thing
type ThingCRUD = "thing" :> Capture "id" Integer            :> Header "Authentication" Bearer :> Get '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingPostBody   :> Header "Authentication" Bearer :> Post '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingPatchBody  :> Header "Authentication" Bearer :> Patch '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingDeleteBody :> Header "Authentication" Bearer :> Delete '[JSON] Thing

-- Combine all routes
type API = ThingCRUD :<|> GetVersionAPI
