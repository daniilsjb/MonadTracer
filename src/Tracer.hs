module Tracer (
    Tracer.trace
) where

import Data.List (minimumBy)
import Data.Maybe (catMaybes)

import Vector3
import Material
import Ray
import Object
import Scene
import Camera
import Framebuffer

trace :: Scene -> Camera -> Framebuffer
trace scene camera@(Camera origin fov depth bounce size@(width, height)) =
    let directions = [ directionThroughPixel camera (x, y) | y <- [0..height-1], x <- [0..width-1] ]
        rays = map (Ray origin) directions
        colors = map (traceRay scene camera) rays
    in Framebuffer colors size

traceRay :: Scene -> Camera -> Ray -> Color
traceRay scene camera@Camera { cameraBounce = bounce } ray = bounceRay scene camera ray bounce

bounceRay :: Scene -> Camera -> Ray -> Int -> Color
bounceRay Scene { sceneBackground = color } _ _ 0 = color
bounceRay scene camera ray bounce =
    case castRay scene camera ray of
        Just hit -> calculateColor scene camera hit bounce
        Nothing -> sceneBackground scene

castRay :: Scene -> Camera -> Ray -> Maybe RayHit
castRay Scene { sceneObjects = objects } Camera { cameraDepth = depth } ray =
    let casts = map (ray `intersects`) objects
        intersections = catMaybes casts
        withinRange = filter (\hit -> hitDistance hit < depth) intersections
    in chooseClosest withinRange
    
chooseClosest :: [RayHit] -> Maybe RayHit
chooseClosest [] = Nothing
chooseClosest intersections = Just $ minimumBy (\h1 h2 -> compare (hitDistance h1) (hitDistance h2)) intersections

calculateColor :: Scene -> Camera -> RayHit -> Int -> Color
calculateColor scene camera hit bounce =
    let illumination = calculateIllumination scene camera hit
        reflection = calculateReflection scene camera hit bounce
        refraction = calculateRefraction scene camera hit bounce
    in clamp 0.0 1.0 $ illumination + reflection + refraction
    
calculateIllumination :: Scene -> Camera -> RayHit -> Color
calculateIllumination scene@Scene { sceneLights = sources } camera hit =
    let ambient = calculateAmbient scene hit
        light = sum $ map (`calculateLight` hit) $ filter (reachedByLight scene camera hit) sources
    in ambient + light

calculateAmbient :: Scene -> RayHit -> Color
calculateAmbient Scene { sceneAmbient = color } RayHit { hitMaterial = Material { matAmbient = factor } } = color * factor

reachedByLight :: Scene -> Camera -> RayHit -> LightSource -> Bool
reachedByLight scene camera RayHit { hitPoint = point } (LightSource origin _ _) =
    let lightDirection = normalize $ origin - point
        lightDistance = magnitude $ origin - point
        obstacleRay = Ray (point + lightDirection * 0.01) lightDirection
    in case castRay scene camera obstacleRay of
        Just hit -> hitDistance hit >= lightDistance
        Nothing -> True

calculateLight :: LightSource -> RayHit -> Color
calculateLight (LightSource origin color intensity) (RayHit point _ v n Material { matDiffuse = kd, matSpecular = ks, matShininess = shininess }) =
    let vL = normalize $ origin - point
        vR = normalize $ reflect vL n
        light = color `scale` intensity
        diffuse = light `scale` max (vL `dot` n) 0.0 * kd
        specular = light `scale` (max (vR `dot` v) 0.0 ** shininess) * ks
    in diffuse + specular

calculateReflection :: Scene -> Camera ->  RayHit -> Int -> Color
calculateReflection scene camera (RayHit point _ direction normal material) bounce =
    let reflectionFactor = matReflection material
        reflectedDirection = normalize $ reflect direction normal
        reflectedRay = Ray (point + reflectedDirection * 0.01) reflectedDirection
    in bounceRay scene camera reflectedRay (bounce - 1) * reflectionFactor
    
calculateRefraction :: Scene -> Camera -> RayHit -> Int -> Color
calculateRefraction scene camera (RayHit point _ direction normal material) bounce =
    let refractionFactor = matRefraction material
        refractiveIndex = matRefractiveIndex material
        refractedDirection = normalize $ refract direction normal refractiveIndex
        refractedRay = Ray (point + refractedDirection * 0.01) refractedDirection
    in bounceRay scene camera refractedRay (bounce - 1) * refractionFactor

refract :: Vector3 -> Vector3 -> Float -> Vector3
refract direction normal index =
    let c = -max (-1.0) (min 1.0 $ direction `dot` normal)
        n1 = 1.0
        n2 = index
    in if c < 0.0
        then findRefraction direction (-c) n2 n1 (-normal)
        else findRefraction direction c n1 n2 normal

findRefraction :: Vector3 -> Float -> Float -> Float -> Vector3 -> Vector3
findRefraction direction c n1 n2 normal =
    let r = n1 / n2
        k = 1.0 - r^2 * (1.0 - c^2)
    in if k < 0.0
        then Vector3 0.0 0.0 0.0
        else direction `scale` r + normal `scale` (r * c - sqrt k)
