module Object (
    Object (..),
    Object.intersects
) where

import Vector3
import Material
import Ray

data Object = Sphere Vector3 Float Material | Plane Vector3 Float Material deriving (Show)

intersects :: Ray -> Object -> Maybe RayHit
intersects (Ray rayOrigin rayDirection) (Sphere origin radiuss material) = do
    let vL = origin - rayOrigin
        tca = vL `dot` rayDirection
    
    let rSqr = radiuss^2
    dSqr <- let value = (vL `dot` vL) - (tca * tca)
            in if value > rSqr then Nothing else return value
    
    let thc = sqrt $ rSqr - dSqr
        t0 = tca - thc
        t1 = tca + thc
    
    t <- let value = if t0 < 0.0 then t1 else t0
         in if value < 0.0 then Nothing else return value
        
    let point = rayOrigin + (rayDirection `scale` t)
        normal = normalize $ point - origin
        
    return $ RayHit point t rayDirection normal material

intersects (Ray rayOrigin rayDirection) (Plane normal d material) = do
    let epsilon = 0.0001
    
    denom <- let value = rayDirection `dot` normal
             in if abs value <= epsilon then Nothing else return value
    
    t <- let value = (d - rayOrigin `dot` normal) / denom
         in if value <= epsilon then Nothing else return value
    
    let n = if denom > 0.0 then (-normal) else normal
        point = rayOrigin + (rayDirection `scale` t)
    
    return $ RayHit point t rayDirection n material
