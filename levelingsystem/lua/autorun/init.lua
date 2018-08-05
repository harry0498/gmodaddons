AddCSLuaFile("cl_init.lua")

if CLIENT then
    return
end

local maxlevel = 60
local updatexp = false

util.AddNetworkString("updatexp")

sound.Add(
    {
        name = "levelsound1",
        channel = CHAN_AUTO,
        volume = 0.8,
        level = 60,
        pitch = 100,
        sound = "garrysmod/save_load1.wav"
    }
)

sound.Add(
    {
        name = "levelsound2",
        channel = CHAN_AUTO,
        volume = 0.8,
        level = 60,
        pitch = 100,
        sound = "garrysmod/save_load2.wav"
    }
)

sound.Add(
    {
        name = "levelsound3",
        channel = CHAN_AUTO,
        volume = 0.8,
        level = 60,
        pitch = 100,
        sound = "garrysmod/save_load3.wav"
    }
)

sound.Add(
    {
        name = "levelsound4",
        channel = CHAN_AUTO,
        volume = 0.8,
        level = 60,
        pitch = 100,
        sound = "garrysmod/save_load4.wav"
    }
)

function CheckLevel(ply)
    local xp = tonumber(ply:GetNWInt("XP"))
    local level = tonumber(ply:GetNWInt("Level") + 1)

    if xp >= (math.Round((level - 1 + 300 * 2 ^ ((level - 1) / 7)) / 4)) then
        if level <= maxlevel then
            ply:SetNWInt("Level", level)
            ply:SetNWInt("XP", ply:GetNWInt("XP") - (math.Round((level - 1 + 300 * 2 ^ ((level - 1) / 7)) / 4)))

            DarkRP.notify(ply, 0, 3, "You leveled up to 'level " .. ply:GetNWInt("Level") .. "'")

            timer.Simple(
                0,
                function()
                    local sounds = {"levelsound1", "levelsound2", "levelsound3", "levelsound4"}

                    local soundtp = sounds[math.random(#sounds)]

                    ply:StopSound(soundtp)
                    ply:EmitSound(soundtp)

                    local effectdata = EffectData()
                    effectdata:SetOrigin(ply:GetPos())

                    util.Effect("balloon_pop", effectdata)
                end
            )
        end

        if (level - 1) == maxlevel then
            ply:SetNWInt("XP", (math.Round((level - 1 + 300 * 2 ^ ((level - 1) / 7)) / 4)))
        end

        if (level - 1) > maxlevel then
            ply:SetNWInt("Level", maxlevel)
        end
    end
end

function AddXP(ply, amount)
    ply:SetNWInt("XP", ply:GetNWInt("XP") + amount)

    CheckLevel(ply)

    net.Start("updatexp")

    updatexp = true

    net.WriteBool(updatexp)

    net.Send(ply)

    if timer.Exists("updatexp") then
        timer.Destroy("updatexp")
        timer.Create(
            "updatexp",
            10,
            1,
            function()
                updatexp = false

                net.Start("updatexp")

                net.WriteBool(updatexp)

                net.Send(ply)
            end
        )
    else
        timer.Create(
            "updatexp",
            10,
            1,
            function()
                updatexp = false

                net.Start("updatexp")

                net.WriteBool(updatexp)

                net.Send(ply)
            end
        )
    end
end

hook.Remove("PlayerInitialSpawn", "setlevels")
hook.Add(
    "PlayerInitialSpawn",
    "setlevels",
    function(ply)
        if ply:GetPData("Level") then
            ply:SetNWInt("Level", tonumber(ply:GetPData("Level")))
        else
            ply:SetNWInt("Level", 1)
        end

        if ply:GetPData("XP") then
            ply:SetNWInt("XP", tonumber(ply:GetPData("XP")))
        else
            ply:SetNWInt("XP", 0)
        end

        timer.Create(
            "addxp",
            120,
            0,
            function()
                AddXP(ply, 10)
            end
        )

        net.Start("updatexp")

        updatexp = true

        net.WriteBool(updatexp)

        net.Send(ply)

        timer.Simple(
            10,
            function()
                updatexp = false

                net.Start("updatexp")

                net.WriteBool(updatexp)

                net.Send(ply)
            end
        )
    end
)

hook.Remove("ShutDown", "savelevelshutdown")
hook.Add(
    "ShutDown",
    "savelevelshutdown",
    function()
        for k, v in pairs(player.GetAll()) do
            v:SetPData("Level", v:GetNWInt("Level"))
            v:SetPData("XP", v:GetNWInt("XP"))
        end
    end
)

hook.Remove("PlayerDisconnected", "savelevelleave")
hook.Add(
    "PlayerDisconnected",
    "savelevelleave",
    function(ply)
        ply:SetPData("Level", ply:GetNWInt("Level"))
        ply:SetPData("XP", ply:GetNWInt("XP"))
    end
)

hook.Remove("Think", "checklevel")
hook.Add(
    "Think",
    "checklevel",
    function()
        for k, v in pairs(player.GetAll()) do
            if v:IsValid() and v:IsPlayer() then
                CheckLevel(v)
            end
        end
    end
)
