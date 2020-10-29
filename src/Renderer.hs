module Renderer (
    Renderer.render
) where

import Framebuffer
import Vector3

type FileName = String
type Size = (Int, Int)

render :: Framebuffer -> IO ()
render (Framebuffer colors size) = do
    let fileName = "output.ppm"
    writeHeader fileName size
    writeColors fileName colors

writeHeader :: FileName -> Size -> IO ()
writeHeader fileName (width, height) = do
    writeFile fileName "P3\n"
    appendFile fileName $ show width ++ " " ++ show height ++ "\n"
    appendFile fileName "255\n"

writeColors :: FileName -> [Color] -> IO ()
writeColors fileName colors = do
    let scaled = map (* 255.0) colors
        stringified = map (\(Vector3 r g b) -> show r ++ " " ++ show g ++ " " ++ show b ++ "\n") scaled
        picture = concat stringified

    appendFile fileName picture
