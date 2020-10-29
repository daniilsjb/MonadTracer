module Ray (
    Ray (..),
    RayHit (..)
) where

import Vector3
import Material

data Ray = Ray Point Direction deriving (Show)

data RayHit = RayHit { hitPoint :: Point
                     , hitDistance :: Float
                     , hitDirection :: Direction
                     , hitNormal :: Vector3
                     , hitMaterial :: Material
                     } deriving (Show)
