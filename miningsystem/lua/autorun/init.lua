if CLIENT then
    return
end

hook.Add("PlayerInitialSpawn", "setores", function(ply)

    ply:SetNWInt("Ore", 0)

end)