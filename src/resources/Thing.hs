{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE DeriveGeneric #-}


module Thing where

import Data.Aeson ( FromJSON )
import GHC.Generics

data TypeOfThing = Stuff | Shit | Crap | NoThing deriving (Eq,Ord,Enum,Show)

data Thing = Thing {
  id   :: Int,
  name :: String,
  what :: TypeOfThing
} deriving Generic

data ThingPostBody = ThingPostBody {
  name :: String,
  what :: Int
} deriving Generic
instance FromJSON ThingPostBody

data ThingPatchBody = ThingPatchBody {
  name :: String,
  what :: Int
} deriving Generic
instance FromJSON ThingPatchBody

data ThingDeleteBody = ThingDeleteBody {
  id   :: Int,
  name :: String
} deriving Generic
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

