{-# LANGUAGE DuplicateRecordFields #-}

module Thing where

data TypeOfThing = Stuff | Shit | Crap | Nothing

data Thing = Thing {
  id :: String,
  name :: String,
  what :: TypeOfThing
}

data ThingPostBody = ThingPostBody {
  name :: String,
  what :: TypeOfThing
}

data ThingPatchBody = ThingPatchBody {
  name :: String,
  what :: TypeOfThing
}

data ThingDeleteBody = ThingDeleteBody {
  name :: String
}

