module Material (
    Material (..),
    Material.emerald,
    Material.redRubber,
    Material.bronze,
    Material.pearl,
    Material.silver,
    Material.glass,
    Material.mirror
) where

import Vector3

data Material = Material { matAmbient :: Color
                         , matDiffuse :: Color
                         , matSpecular :: Color
                         , matShininess :: Float
                         , matReflection :: Color
                         , matRefraction :: Color
                         , matRefractiveIndex :: Float
                         } deriving (Show)

emerald :: Material
emerald =
    Material { matAmbient = Vector3 0.0215 0.1745 0.0215
             , matDiffuse = Vector3 0.07568 0.61424 0.07568
             , matSpecular = Vector3 0.633 0.727811 0.633
             , matShininess = 76.8
             , matReflection = Vector3 0.2 0.2 0.2
             , matRefraction = Vector3 0.0 0.0 0.0
             , matRefractiveIndex = 1.0
             }

redRubber :: Material
redRubber =
    Material { matAmbient = Vector3 0.05 0.0 0.0
             , matDiffuse = Vector3 0.5 0.4 0.4
             , matSpecular = Vector3 0.7 0.04 0.04
             , matShininess = 10.0
             , matReflection = Vector3 0.0 0.0 0.0
             , matRefraction = Vector3 0.0 0.0 0.0
             , matRefractiveIndex = 1.0
             }
    
bronze :: Material
bronze =
    Material { matAmbient = Vector3 0.2125 0.1275 0.054
             , matDiffuse = Vector3 0.714 0.4284 0.18144
             , matSpecular = Vector3 0.393548 0.271906 0.166721
             , matShininess = 25.6
             , matReflection = Vector3 0.05 0.05 0.05
             , matRefraction = Vector3 0.0 0.0 0.0
             , matRefractiveIndex = 1.0
             }

pearl :: Material
pearl =
    Material { matAmbient = Vector3 0.25 0.20725 0.20725
             , matDiffuse = Vector3 1.0 0.829 0.829
             , matSpecular = Vector3 0.296648 0.296648 0.296648
             , matShininess = 225.28
             , matReflection = Vector3 0.1 0.1 0.1
             , matRefraction = Vector3 0.0 0.0 0.0
             , matRefractiveIndex = 1.0
             }

silver :: Material
silver =
    Material { matAmbient = Vector3 0.19225 0.19225 0.19225
             , matDiffuse = Vector3 0.50754 0.50754 0.50754
             , matSpecular = Vector3 0.508273 0.508273 0.508273
             , matShininess = 51.2
             , matReflection = Vector3 0.2 0.2 0.2
             , matRefraction = Vector3 0.0 0.0 0.0
             , matRefractiveIndex = 1.0
             }
    
mirror :: Material
mirror =
    Material { matAmbient = Vector3 0.0 0.0 0.0
             , matDiffuse = Vector3 0.0 0.0 0.0
             , matSpecular = Vector3 1.0 1.0 1.0
             , matShininess = 1500.0
             , matReflection = Vector3 0.8 0.8 0.8
             , matRefraction = Vector3 0.0 0.0 0.0
             , matRefractiveIndex = 1.0
             }
    
glass :: Material
glass =
    Material { matAmbient = Vector3 0.0 0.0 0.0
             , matDiffuse = Vector3 0.0 0.0 0.0
             , matSpecular = Vector3 0.3 0.3 0.3
             , matShininess = 75.0
             , matReflection = Vector3 0.1 0.1 0.1
             , matRefraction = Vector3 0.8 0.8 0.8
             , matRefractiveIndex = 1.5
             }
