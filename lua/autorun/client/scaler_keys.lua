/*
    How to use:

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

local defScale = Vector(1,1,1)

local string_find = string.find
local table_HasValue = table.HasValue
local table_insert = table.insert

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
    local rate = animData.fps
    local loop = animData.flags == 1
    local curFrame = ent:GetCycle() *rate
    
    local frame = math.Round(curFrame)
    local bone = nil
    local scale = nil

    if loop then
        ent.ScalerKeys_LastLoopSequence = seqName
    end

    -- Create a list to store the bones that are being used in the active sequence
    local activeBones = {}

    for k,v in pairs(ent.ScalerKeysTable) do
        if k == seqName then
            for k2,v2 in pairs(v) do
                bone = ent:LookupBone(k2)
                if bone != nil then
                    scale = v2[frame]
                    if scale != nil then
                        -- print(ent,bone,"Applying scale to bone " .. k2 .. " of " .. tostring(scale))
                        ent:ManipulateBoneScale(bone,scale)
                        -- Add the bone to the list of active bones
                        table_insert(activeBones, bone)
                    end
                end
            end
        else
            if ent.ScalerKeys_LastLoopSequence == seqName then
                continue
            end
            for k2,v2 in pairs(v) do
                bone = ent:LookupBone(k2)
                if bone != nil then
                    -- Check if the bone is in the list of active bones before resetting
                    if !table_HasValue(activeBones, bone) then
                        -- print("Resetting scale to bone " .. k2 .. " of " .. tostring(defScale))
                        ent:ManipulateBoneScale(bone,defScale)
                    end
                end
            end
        end
    end
end