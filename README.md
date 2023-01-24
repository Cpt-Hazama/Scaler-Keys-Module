# GMod Scaler Key Module
This module allows scaler keys to be utilized in Garry's Mod.

# Installation
Place in /GarrysMod/garrysmod/addons/ folder

# How To Use
This tool was developed with MeltyPlayer's Model Extractor tool in mind, though you can manually create the scaler data if you wish or write your own script.
This guide will assume you are using MeltyPlayer's Model Extractor tool.

1.) Grab your bone_scale_animations.txt file and rename the extension to .lua, then paste it into your entity's lua folder

2.) Open the file and change ScalerKeysTable to ENT.ScalerKeysTable

3.) For optimization sake, replace any Vector(1, 1, 1) with defScale

4.) Go to your shared.lua of your entity and at the top add:
    include("bone_scale_animations.lua")
    
5.) Go to your client-side Draw (or CustomOnDraw) function and add:
    Scaler.ApplyScalerKeys(self)
    
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

if CLIENT then
    function ENT:CustomOnDraw()
        if Scaler then
            Scaler.ApplyScalerKeys(self)
        end
    end
end
```

Example scale data file:
https://cdn.discordapp.com/attachments/418480949542780938/1067365053021556767/enemy_bone_scale_animations.lua

# Examples
https://user-images.githubusercontent.com/7193583/214250584-d0598c7d-a9af-4f9c-8795-be14f178cd23.mp4
