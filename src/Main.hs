import Data.Time

import Vector3
import Object
import Material
import Scene
import Camera
import Tracer
import Renderer

main :: IO ()
main = do
    putStrLn "Preparing the Ray Tracing process..."
    
    let scene = makeScene
        camera = makeCamera
    
    putStrLn "Starting the Ray Tracing! This may take a while."
    t1 <- getCurrentTime
    
    let framebuffer = trace scene camera
    render framebuffer
    
    t2 <- getCurrentTime
    putStrLn $ "Done! Elapsed time: " ++ show (diffUTCTime t2 t1)
    
makeScene :: Scene
makeScene =
    Scene { sceneObjects = [ Sphere (Vector3 10.0 0.0 30.0)       6.0     emerald
                           , Sphere (Vector3 (-12.0) (-2.0) 15.0) 4.0     redRubber
                           , Sphere (Vector3 20.0 20.0 35.0)      10.0    bronze
                           , Sphere (Vector3 (-3.0) 3.0 18.0)     5.0     pearl
                           , Sphere (Vector3 0.0 (-2.0) 20.0)     4.0     mirror
                           , Sphere (Vector3 (-15.0) 8.0 16.0)    2.0     mirror
                           , Sphere (Vector3 5.0 10.0 25.0)       3.0     glass
                           , Sphere (Vector3 (-3.0) 0.0 4.0)      1.0     glass
                           , Plane  (Vector3 0.0 1.0 0.0 )        (-15.0) silver
                           ]
          , sceneLights = [ LightSource (Vector3 15.0 30.0 13.0)   (Vector3 1.0 1.0 1.0) 1.0
                          , LightSource (Vector3 8.0 20.0 (-5.0))  (Vector3 0.8 0.7 0.6) 0.7
                          , LightSource (Vector3 (-14.0) 9.0 12.0) (Vector3 1.0 1.0 1.0) 0.3
                          ]
          , sceneBackground = Vector3 0.2 0.8 0.9
          , sceneAmbient = Vector3 1.0 1.0 1.0
          }
    
makeCamera :: Camera
makeCamera =
    Camera { cameraOrigin = Vector3 0.0 0.0 (-1.0)
           , cameraFoV = pi / 2.0
           , cameraDepth = 1000.0
           , cameraBounce = 4
           , cameraSize = (1200, 800)
           }
