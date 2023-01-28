_G.lightSpellButtons = {}

_G.lightSpellIDs = {47540, 129250, 585, 204197}

-- Make sure the button bars are in the correct order
local buttonBars = {
    "ActionButton", --1-12
    "UnknownButtonBar", -- 13-24
    "MultiBarRightButton", --25-36
    "MultiBarLeftButton", --37-48
    "MultiBarBottomRightButton", -- 49-60
    "MultiBarBottomLeftButton" --61-72
    
}


function existsInList(valueToInsert, list)
    local exists = false
    
    for _, v in pairs(list) do
        if v == valueToInsert then
            exists = true
            break
        end
    end
    
    if not exists then
        table.insert(list, valueToInsert)
    end
end





function findLightSpells(spellID)
    
    local TOTAL_BUTTONS = 72
    
    for i=1, TOTAL_BUTTONS do
        local barIndex = math.floor((i-1) / 12) + 1
        local buttonIndex = (i-1) % 12 + 1
        local buttonBar = buttonBars[barIndex]
        local buttonName = buttonBar..buttonIndex
        repeat
            local type, id, _, _, _, _, _, _, _, _, _ = GetActionInfo(i)
            if not (type) or not (id) then
                -- skip iteration if GetActionInfo returns nil
                break
            end
            if (type == "spell" and id == spellID) then
                existsInList(buttonName, _G.lightSpellButtons)
            elseif (type == "macro") then
                local macroBody = GetMacroBody(id)
                if (macroBody:find("#showtooltip")) then
                    local spellName = macroBody:match("#showtooltip ([^\n]+)")
                    local spellName, _, _, _, _, _, lookUpSpellID = GetSpellInfo(spellName)
                    if (spellID == lookUpSpellID) then
                        existsInList(buttonName, _G.lightSpellButtons)
                    end
                end
            end
        until true
    end
    return false
end

function glowSpells(list)
    
    for _, buttonName in pairs(list) do
        _G.ability_frame = _G[buttonName]
        ActionButton_ShowOverlayGlow(_G.ability_frame)
    end
end

function stopGlowSpells(list)
    
    for _, buttonName in pairs(list) do
        _G.ability_frame = _G[buttonName]
        ActionButton_HideOverlayGlow(_G.ability_frame)
    end
end

if #_G.lightSpellButtons == 0 then  
    for _, spellID in pairs(_G.lightSpellIDs) do
        findLightSpells(spellID)
    end
end

