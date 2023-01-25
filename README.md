# GMod Scaler Key Module
This module allows scaler keys to be utilized in Garry's Mod.

# Installation
Place in /GarrysMod/garrysmod/addons/ folder

# How To Use
This tool was developed with MeltyPlayer's Model Extractor tool in mind, though you can manually create the scaler data if you wish or write your own script.
This guide will assume you are using MeltyPlayer's Model Extractor tool. To enable this feature, scaler_enabled must be set to 1 in your console (by default it will be turned on upon first installation).

1.) Grab your bone_scale_animations.txt file and rename the extension to .lua, then paste it into your entity's lua folder

2.) Open the file and change ScalerKeysTable to ENT.ScalerKeysTable

3.) For optimization sake, replace any Vector(1, 1, 1) with defScale

4.) Go to your shared.lua of your entity and at the top add:
    include("bone_scale_animations.lua")
    
5.) Make sure you have scaler_enabled command set to 1
    
6.) Test it out!

6.b.) You might need to manually change some stuff in the exported data but its not wild!

Example shared.lua
```lua
ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= ""
ENT.Author 			= "Cpt. Hazama"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= ""

include("enemy_bone_scale_animations.lua")
```

# Examples
https://user-images.githubusercontent.com/7193583/214477186-365fce89-7ba4-4085-aca6-1003afe35944.mp4
