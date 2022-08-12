if SERVER then
    hook.Remove("Initialize", "updatedoors")
    hook.Add(
        "Initialize",
        "updatedoors",
        function()
            timer.Create(
                "update",
                0.25,
                0,
                function()
                    for k, v in pairs(ents.GetAll()) do
                        if v:IsValid() and v:isDoor() and (v:GetClass() == "func_door" or v:GetClass() == "prop_door_rotating" or v:GetClass() == "func_door_rotating") then
                            v:SetNWBool("lockstatus", v:GetSaveTable().m_bLocked)
                        end
                    end
                end
            )
        end
    )
elseif CLIENT then
    local locked = {
        "icon16/lock.png",
        "icon16/lock_open.png"
    }

    surface.CreateFont(
        "DoorFont",
        {
            font = "Trebuchet",
            extended = false,
            size = 72,
            weight = 600,
            blursize = 0,
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false,
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = false,
            additive = false,
            outline = false
        }
    )

    surface.CreateFont("MaterialIcons", {
        font = "Material Icons",
        size = 72,
        weight = 300,
        antialias = true,
        outline = false,
        extended = true,
    })

    hook.Remove("PostDrawTranslucentRenderables", "doors")
    hook.Add(
        "PostDrawTranslucentRenderables",
        "doors",
        function()
            local ply = LocalPlayer()

            for _, v in ipairs(ents.GetAll()) do
                if not v:getDoorData() or not v:isDoor() then continue end

                if  ply:GetPos():Distance(v:GetPos()) < 300 then
                    local alpha = math.Clamp(255 - (((ply:GetPos():Distance(v:GetPos()) - 60) / 200) * 255), 0, 255)

                    local pos = v:GetPos()
                    local ang = v:GetAngles()

                    local coowners = {}
                    local allowedcoowners = {}

                    ang:RotateAroundAxis(v:GetRight(), 90)
                    ang:RotateAroundAxis(v:GetForward(), 90)

                    cam.Start3D2D(pos + (v:GetForward() * -1.5) + (v:GetRight() * -(v:OBBMaxs().y / 2)), ang, 0.045)

                    cam.IgnoreZ(false)

                    if v:getDoorOwner() then
                        draw.SimpleText(v:getDoorOwner():Nick(), "DoorFont", 0, 0, Color(255, 255, 255, alpha), 1, 1)

                        if v:getKeysCoOwners() then
                            for _, id in pairs(table.GetKeys(v:getKeysCoOwners())) do
                                if Player(id):IsValid() then
                                    if not table.HasValue(coowners, Player(id):Nick()) then
                                        table.insert(coowners, Player(id):Nick())
                                    end
                                end
                            end

                            draw.SimpleText("Co-Owners:", "DoorFont", 0, 120, Color(255, 255, 255, alpha), 1, 1)

                            for _k, co in pairs(coowners) do
                                draw.SimpleText(co, "DoorFont", 0, 120 * (_k + 1), Color(255, 255, 255, alpha), 1, 1)
                            end
                        end

                        if v:getKeysAllowedToOwn() then
                            for __, _id in pairs(table.GetKeys(v:getKeysAllowedToOwn())) do
                                if Player(_id):IsValid() then
                                    if not table.HasValue(allowedcoowners, Player(_id):Nick()) then
                                        table.insert(allowedcoowners, Player(_id):Nick())
                                    end
                                end
                            end

                            draw.SimpleText("Allowed to Co-Own:", "DoorFont", 0, 120 * (#coowners + 2), Color(255, 255, 255, alpha), 1, 1)

                            for __k, _co in pairs(allowedcoowners) do
                                draw.SimpleText(_co, "DoorFont", 0, 120 * (__k + 2 + #coowners), Color(255, 255, 255, alpha), 1, 1)
                            end
                        end

                        if v:GetNWBool("lockstatus") == true then
                            surface.SetFont("DoorFont")
                            
                            local width, height = surface.GetTextSize(v:getDoorOwner():Nick())
                            
                            draw.SimpleText(utf8.char(0xe897), "MaterialIcons", 0, -80, Color(255, 255, 255), 1, 1)
                        else
                            surface.SetFont("DoorFont")
                            
                            local width, height = surface.GetTextSize(v:getDoorOwner():Nick())
                            
                            draw.SimpleText(utf8.char(0xe898), "MaterialIcons", 0, -80, Color(255, 255, 255), 1, 1)
                        end
                    elseif v:getKeysDoorGroup() then
                        draw.SimpleText(v:getKeysDoorGroup(), "DoorFont", 0, 0, Color(255, 255, 255, alpha), 1, 1)

                        if v:getKeysCoOwners() then
                            for _, id in pairs(table.GetKeys(v:getKeysCoOwners())) do
                                if Player(id):IsValid() then
                                    if not table.HasValue(coowners, Player(id):Nick()) then
                                        table.insert(coowners, Player(id):Nick())
                                    end
                                end
                            end

                            draw.SimpleText("Co-Owners:", "DoorFont", 0, 120, Color(255, 255, 255, alpha), 1, 1)

                            for _k, co in pairs(coowners) do
                                draw.SimpleText(co, "DoorFont", 0, 120 * (_k + 1), Color(255, 255, 255, alpha), 1, 1)
                            end
                        end

                        if v:getKeysAllowedToOwn() then
                            for __, _id in pairs(table.GetKeys(v:getKeysAllowedToOwn())) do
                                if Player(_id):IsValid() then
                                    if not table.HasValue(allowedcoowners, Player(_id):Nick()) then
                                        table.insert(allowedcoowners, Player(_id):Nick())
                                    end
                                end
                            end

                            draw.SimpleText("Allowed to Co-Own:", "DoorFont", 0, 120 * (#coowners + 2), Color(255, 255, 255, alpha), 1, 1)

                            for __k, _co in pairs(allowedcoowners) do
                                draw.SimpleText(_co, "DoorFont", 0, 120 * (__k + 2 + #coowners), Color(255, 255, 255, alpha), 1, 1)
                            end
                        end

                        if v:GetNWBool("lockstatus") == true then
                            surface.SetFont("DoorFont")

                            local width, height = surface.GetTextSize(v:getKeysDoorGroup())

                            draw.SimpleText(utf8.char(0xe897), "MaterialIcons", 0, -80, Color(255, 255, 255), 1, 1)
                        else
                            surface.SetFont("DoorFont")

                            local width, height = surface.GetTextSize(v:getKeysDoorGroup())

                            draw.SimpleText(utf8.char(0xe898), "MaterialIcons", 0, -80, Color(255, 255, 255), 1, 1)
                        end
                    else
                        draw.SimpleText("Press 'F2' to own", "DoorFont", 0, 0, Color(255, 255, 255, alpha), 1, 1)
                    end

                    cam.End3D2D()

                    ang:RotateAroundAxis(v:GetUp(), 180)

                    cam.Start3D2D(pos + (v:GetForward() * 1.5) - (v:GetRight() * (v:OBBMaxs().y / 2)), ang, 0.045)

                    cam.IgnoreZ(false)

                    if v:getDoorOwner() then
                        draw.SimpleText(v:getDoorOwner():Nick(), "DoorFont", 0, 0, Color(255, 255, 255, alpha), 1, 1)

                        if v:getKeysCoOwners() then
                            for _, id in pairs(table.GetKeys(v:getKeysCoOwners())) do
                                if Player(id):IsValid() then
                                    if not table.HasValue(coowners, Player(id):Nick()) then
                                        table.insert(coowners, Player(id):Nick())
                                    end
                                end
                            end

                            draw.SimpleText("Co-Owners:", "DoorFont", 0, 120, Color(255, 255, 255, alpha), 1, 1)

                            for _k, co in pairs(coowners) do
                                draw.SimpleText(co, "DoorFont", 0, 120 * (_k + 1), Color(255, 255, 255, alpha), 1, 1)
                            end
                        end

                        if v:getKeysAllowedToOwn() then
                            for __, _id in pairs(table.GetKeys(v:getKeysAllowedToOwn())) do
                                if Player(_id):IsValid() then
                                    if not table.HasValue(allowedcoowners, Player(_id):Nick()) then
                                        table.insert(allowedcoowners, Player(_id):Nick())
                                    end
                                end
                            end

                            draw.SimpleText("Allowed to Co-Own:", "DoorFont", 0, 120 * (#coowners + 2), Color(255, 255, 255, alpha), 1, 1)

                            for __k, _co in pairs(allowedcoowners) do
                                draw.SimpleText(_co, "DoorFont", 0, 120 * (__k + 2 + #coowners), Color(255, 255, 255, alpha), 1, 1)
                            end
                        end

                        if v:GetNWBool("lockstatus") == true then
                            surface.SetFont("DoorFont")

                            local width, height = surface.GetTextSize(v:getDoorOwner():Nick())

                            draw.SimpleText(utf8.char(0xe897), "MaterialIcons", 0, -80, Color(255, 255, 255), 1, 1)
                        else
                            surface.SetFont("DoorFont")

                            local width, height = surface.GetTextSize(v:getDoorOwner():Nick())

                            draw.SimpleText(utf8.char(0xe898), "MaterialIcons", 0, -80, Color(255, 255, 255), 1, 1)
                        end
                    elseif v:getKeysDoorGroup() then
                        draw.SimpleText(v:getKeysDoorGroup(), "DoorFont", 0, 0, Color(255, 255, 255, alpha), 1, 1)

                        if v:getKeysCoOwners() then
                            for _, id in pairs(table.GetKeys(v:getKeysCoOwners())) do
                                if Player(id):IsValid() then
                                    if not table.HasValue(coowners, Player(id):Nick()) then
                                        table.insert(coowners, Player(id):Nick())
                                    end
                                end
                            end

                            draw.SimpleText("Co-Owners:", "DoorFont", 0, 120, Color(255, 255, 255, alpha), 1, 1)

                            for _k, co in pairs(coowners) do
                                draw.SimpleText(co, "DoorFont", 0, 120 * (_k + 1), Color(255, 255, 255, alpha), 1, 1)
                            end
                        end

                        if v:getKeysAllowedToOwn() then
                            for __, _id in pairs(table.GetKeys(v:getKeysAllowedToOwn())) do
                                if Player(_id):IsValid() then
                                    if not table.HasValue(allowedcoowners, Player(_id):Nick()) then
                                        table.insert(allowedcoowners, Player(_id):Nick())
                                    end
                                end
                            end

                            draw.SimpleText("Allowed to Co-Own:", "DoorFont", 0, 120 * (#coowners + 2), Color(255, 255, 255, alpha), 1, 1)

                            for __k, _co in pairs(allowedcoowners) do
                                draw.SimpleText(_co, "DoorFont", 0, 120 * (__k + 2 + #coowners), Color(255, 255, 255, alpha), 1, 1)
                            end
                        end

                        if v:GetNWBool("lockstatus") == true then
                            surface.SetFont("DoorFont")

                            local width, height = surface.GetTextSize(v:getKeysDoorGroup())

                            draw.SimpleText(utf8.char(0xe897), "MaterialIcons", 0, -80, Color(255, 255, 255), 1, 1)
                        else
                            surface.SetFont("DoorFont")

                            local width, height = surface.GetTextSize(v:getKeysDoorGroup())

                            draw.SimpleText(utf8.char(0xe898), "MaterialIcons", 0, -80, Color(255, 255, 255), 1, 1)
                        end
                    else
                        draw.SimpleText("Press 'F2' to own", "DoorFont", 0, 0, Color(255, 255, 255, alpha), 1, 1)
                    end

                    cam.End3D2D()
                end
            end
        end
    )
end
