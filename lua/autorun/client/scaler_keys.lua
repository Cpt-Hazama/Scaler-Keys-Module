/*
    How to use:

    This tool was developed with MeltyPlayer's Model Extractor tool in mind, though you can manually create the scaler data if you wish or write your own script.
    This guide will assume you are using MeltyPlayer's Model Extractor tool.

    1.) Grab your bone_scale_animations.txt file and rename the extension to .lua, then paste it into your entity's lua folder
    2.) Open the file and change ScalerKeysTable to ENT.ScalerKeysTable
    3.) For optimization sake, replace any Vector(1, 1, 1) with defScale
    4.) Go to your shared.lua of your entity and at the top add:
        include("bone_scale_animations.lua")
    5.) Make sure you have scaler_enabled command set to 1
    6.) Test it out!
    6.b.) You might need to manually change some stuff in the exported data but its not wild!
*/

------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------
------------------==============================================================================================================================------------------

Scaler = Scaler or {}
Scaler.Global = GetConVar("scaler_global"):GetBool() or false

local dev = false

local defScale = Vector(1,1,1)

local string_find = string.find
local table_HasValue = table.HasValue
local table_insert = table.insert
local math_Round = math.Round

Scaler.GetAnimationData = function(ent,seq)
	if type(seq) == "number" then
		seq = ent:GetSequenceName(seq)
	end

	local info = nil
	local done = ent:GetAnimInfo(0).label
	local i = 1

	while i < 1600 do
		info = ent:GetAnimInfo(i)

        if info == nil then
            break
        end

		if string_find(info.label,"@" .. seq) or string_find(info.label,"a_" .. seq) then
			return info
		end

		if info.label == done then
            break
        end

        i = i +1
	end

	return nil
end

Scaler.ApplyScalerKeys = function(ent) -- Place in client-side CustomOnDraw function
    if !IsValid(ent) then
        return
    end
    if ent.ScalerKeysTable == nil then
        return
    end

    local seq = ent:GetSequence()
    local seqName = ent:GetSequenceName(seq)
    local animData = Scaler.GetAnimationData(ent,seqName)
    if animData == nil then
        return
    end
    local frameCount = animData.numframes
    local rate = animData.fps
    local loop = animData.flags == 1
    local curFrame = ent:GetCycle() *frameCount
    
    local frame = math_Round(curFrame)
    local bone = nil
    local scale = nil

    ent.ScalerKeys_LastSequence = seqName
    if loop then
        ent.ScalerKeys_LastLoopSequence = seqName
    end

    -- Create a list to store the bones that are being used in the active sequence
    local activeBones = {}

    for k,v in pairs(ent.ScalerKeysTable) do
        if k == seqName then
            for k2,v2 in pairs(v) do
                bone = ent:LookupBone(k2)
                if bone != nil && ent:GetBoneName(bone) != "__INVALIDBONE__" then
                    scale = v2[frame -1]
                    if scale != nil then
                        if dev then
                            print(ent,bone,"[" .. seqName .. " {Frame - " .. frame .. "/" .. frameCount .. "}] Applying scale to bone " .. ent:GetBoneName(bone) .. " of " .. tostring(scale))
                        end
                        ent:ManipulateBoneScale(bone,scale)
                        -- Add the bone to the list of active bones
                        table_insert(activeBones, bone)
                    end
                end
            end
        else
            if ent.ScalerKeys_LastLoopSequence == seqName /*or ent.ScalerKeys_LastSequence == seqName*/ then
                continue
            end
            for k2,v2 in pairs(v) do
                bone = ent:LookupBone(k2)
                if bone != nil && ent:GetBoneName(bone) != "__INVALIDBONE__" then
                    -- Check if the bone is in the list of active bones before resetting
                    if !table_HasValue(activeBones, bone) then
                        if dev then
                            print("[" .. seqName .. " {Frame - " .. frame .. "/" .. frameCount .. "}] Resetting scale to bone " .. ent:GetBoneName(bone) .. " of " .. tostring(defScale))
                        end
                        ent:ManipulateBoneScale(bone,defScale)
                    end
                end
            end
        end
    end
end

CreateClientConVar("scaler_enabled", "1", true, false)

cvars.AddChangeCallback("scaler_enabled", function(convar_name, value_old, value_new)
    if value_new == "1" then
        Scaler.Global = true
        hook.Add("PostDrawOpaqueRenderables","ScalerKeys_Global",function()
            for _,v in pairs(ents.GetAll()) do
                if v.ScalerKeysTable != nil then
                    Scaler.ApplyScalerKeys(v)
                end
            end
        end)
        print("ScalerKeys: Enabled")
	else
        Scaler.Global = false
		hook.Remove("PostDrawOpaqueRenderables","ScalerKeys_Global")
        for _,ent in pairs(ents.GetAll()) do
            if ent.ScalerKeysTable != nil then
                for k,v in pairs(ent.ScalerKeysTable) do
                    for k2,v2 in pairs(v) do
                        bone = ent:LookupBone(k2)
                        if bone != nil && ent:GetBoneName(bone) != "__INVALIDBONE__" then
                            ent:ManipulateBoneScale(bone,defScale)
                        end
                    end
                end
            end
        end
        print("ScalerKeys: Disabled")
	end
end)