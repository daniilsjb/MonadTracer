module Framebuffer (
    Framebuffer (..)
) where

import Vector3

type Size = (Int, Int)
data Framebuffer = Framebuffer [Color] Size
