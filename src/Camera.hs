module Camera (
    Camera (..),
    Camera.aspectRatio,
    Camera.directionThroughPixel
) where

import Vector3

data Camera = Camera { cameraOrigin :: Point
                     , cameraFoV :: Float
                     , cameraDepth :: Float
                     , cameraBounce :: Int
                     , cameraSize :: (Int, Int)
                     } deriving (Show)

aspectRatio :: Camera -> Float
aspectRatio Camera { cameraSize = (width, height) } = fromIntegral width / fromIntegral height

directionThroughPixel :: Camera -> (Int, Int) -> Direction
directionThroughPixel camera@Camera { cameraFoV = fov, cameraSize = (width, height) } (x, y) =
    let normalizedX = 2.0 * (fromIntegral x + 0.5) / (fromIntegral width  - 1.0) - 1.0
        normalizedY = 2.0 * (fromIntegral y + 0.5) / (fromIntegral height - 1.0) - 1.0
        viewMiddle = tan $ fov * 0.5
        direction = Vector3
                        ( normalizedX * viewMiddle * aspectRatio camera)
                        (-normalizedY * viewMiddle)
                        1.0
    in normalize direction
