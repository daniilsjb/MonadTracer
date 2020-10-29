module Vector3 (
    Vector3 (..),
    Vector3.Color,
    Vector3.Point,
    Vector3.Direction,
    Vector3.magnitude,
    Vector3.normalize,
    Vector3.dot,
    Vector3.scale,
    Vector3.reflect,
    Vector3.clamp
) where

data Vector3 = Vector3 Float Float Float deriving (Show)
type Color = Vector3
type Point = Vector3
type Direction = Vector3

instance Num Vector3 where
    (Vector3 x1 y1 z1) + (Vector3 x2 y2 z2) = Vector3 (x1 + x2) (y1 + y2) (z1 + z2)
    (Vector3 x1 y1 z1) - (Vector3 x2 y2 z2) = Vector3 (x1 - x2) (y1 - y2) (z1 - z2)
    (Vector3 x1 y1 z1) * (Vector3 x2 y2 z2) = Vector3 (x1 * x2) (y1 * y2) (z1 * z2)
    negate (Vector3 x y z) = Vector3 (-x) (-y) (-z)
    abs (Vector3 x y z) = Vector3 (abs x) (abs y) (abs z)
    signum (Vector3 x y z) = Vector3 (signum x) (signum y) (signum z)
    fromInteger i = Vector3 (fromInteger i) (fromInteger i) (fromInteger i)

instance Fractional Vector3 where
    (Vector3 x1 y1 z1) / (Vector3 x2 y2 z2) = Vector3 (x1 / x2) (y1 / y2) (z1 / z2)
    recip (Vector3 x y z) = Vector3 (1.0 / x) (1.0 / y) (1.0 / z)
    fromRational r = Vector3 (fromRational r) (fromRational r) (fromRational r)

magnitude :: Vector3 -> Float
magnitude (Vector3 x y z) = sqrt $ x^2 + y^2 + z^2

normalize :: Vector3 -> Vector3
normalize vec@(Vector3 x y z) =
    let mag = magnitude vec
    in Vector3 (x / mag) (y / mag) (z / mag)

dot :: Vector3 -> Vector3 -> Float
dot (Vector3 x1 y1 z1) (Vector3 x2 y2 z2) = x1*x2 + y1*y2 + z1*z2

scale :: Vector3 -> Float -> Vector3
scale (Vector3 x y z) scalar = Vector3 (x * scalar) (y * scalar) (z * scalar)

reflect :: Vector3 -> Vector3 -> Vector3
reflect direction normal = direction - (normal `scale` 2.0 `scale` (direction `dot` normal))

clamp :: Float -> Float -> Vector3 -> Vector3
clamp lower upper (Vector3 x y z) = Vector3 (clampComponent x) (clampComponent y) (clampComponent z)
    where
        clampComponent c = max lower $ min upper c