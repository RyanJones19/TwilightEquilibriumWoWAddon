stopGlowSpells(_G.darkSpellButtons)

for _, v in pairs(_G.darkReprimandLocations) do
    removeValue(_G.darkSpellButtons, v)
end