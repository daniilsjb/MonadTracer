module Scene (
    Scene (..),
    LightSource (..)
) where

import Object
import Vector3

data Scene = Scene { sceneObjects :: [Object]
                   , sceneLights :: [LightSource]
                   , sceneBackground :: Color
                   , sceneAmbient :: Color
                   } deriving (Show)

data LightSource = LightSource Point Color Float deriving (Show)
