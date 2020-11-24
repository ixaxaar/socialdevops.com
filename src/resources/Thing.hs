{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE DeriveGeneric #-}


module Thing where

import Data.Aeson
import GHC.Generics

data TypeOfThing = Stuff | Shit | Crap | NoThing deriving (Eq,Ord,Enum,Show,Generic)

data Thing = Thing {
  id   :: Int,
  name :: String,
  what :: TypeOfThing
} deriving Generic

data ThingPostBody = ThingPostBody {
  name :: String,
  what :: Int
} deriving Generic

data ThingPatchBody = ThingPatchBody {
  name :: String,
  what :: Int
} deriving Generic

data ThingDeleteBody = ThingDeleteBody {
  id   :: Int,
  name :: String
} deriving Generic

-- Instances to convert to/from json
instance FromJSON TypeOfThing
instance ToJSON TypeOfThing

instance FromJSON Thing
instance ToJSON Thing

instance FromJSON ThingPostBody
instance FromJSON ThingPatchBody
instance FromJSON ThingDeleteBody

---------- Handlers

-- GET
getThing :: Int -> Thing
getThing id = Thing id "static" Stuff

-- POST
postThing :: ThingPostBody -> Thing
postThing body = thing
  where
    thingType = toEnum (what (body :: ThingPostBody))
    thing = Thing 1 (name (body :: ThingPostBody)) thingType

-- PATCH
patchThing :: ThingPatchBody -> Thing
patchThing body = thing
  where
    thing = postThing (ThingPostBody (name (body :: ThingPatchBody)) (what (body :: ThingPatchBody)))

-- DELETE
deleteThing :: ThingDeleteBody -> Thing
deleteThing body = thing
  where
    thing = Thing 1 (name (body :: ThingDeleteBody)) NoThing

