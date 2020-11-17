{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Routes where

import Servant.API

import Types
import Thing

-- /api/version and /health00
type GetVersionAPI = "api" :> "version" :> Get '[JSON] Version
                :<|> "health"           :> Get '[JSON] Version

-- CRUD on Thing
type ThingCRUD = "thing" :> Capture "id" Integer            :> Get '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingPostBody   :> Post '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingPatchBody  :> Patch '[JSON] Thing
            :<|> "thing" :> ReqBody '[JSON] ThingDeleteBody :> Delete '[JSON] Thing


