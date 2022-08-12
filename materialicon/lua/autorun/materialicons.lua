if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("icons.lua")
    return
end

include("icons.lua")


surface.CreateFont("MaterialIconsList", {
	font = "Material Icons",
	size = 32,
	weight = 300,
	antialias = true,
	outline = false,
	extended = true,
})

surface.CreateFont("IconMenu24", {
	font = "Coolvetica",
	size = 24,
	weight = 500,
	antialias = true,
})

concommand.Add("list_icons", function()
	local icons = {}
	local ICONLIST = ICONLIST or {}

	ICONLIST.Main = vgui.Create("DFrame")
	ICONLIST.Main:SetSize(ScrW() * .25, ScrH() * .5)
	ICONLIST.Main:Center()
	ICONLIST.Main:SetTitle("")
	ICONLIST.Main:SetDraggable(false)
	ICONLIST.Main:ShowCloseButton(false)
	ICONLIST.Main.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, 180))
		draw.RoundedBox(0, 0, 0, w, h * .05, Color(20, 20, 20, 210))
	end

	ICONLIST.Close = ICONLIST.Main:Add("DButton")
	ICONLIST.Close:SetText("")
	ICONLIST.Close:SetSize(ICONLIST.Main:GetWide() * .1, ICONLIST.Main:GetTall() * .05)
	ICONLIST.Close:SetPos(ICONLIST.Main:GetWide() - ICONLIST.Close:GetWide(), 0)
	ICONLIST.Close.Paint = function(s, w, h)
		if s:IsHovered() then
			draw.RoundedBox(0, 0, 0, w, h, Color(231, 76, 60))
		else
			draw.RoundedBox(0, 0, 0, w, h, Color(192, 57, 43))
		end
		draw.SimpleText("Close", "IconMenu24", w * .5, h * .5, Color(236, 240, 241), 1, 1)
	end
	ICONLIST.Close.DoClick = function(s)
		s:GetParent():Remove()
	end

	ICONLIST.Search = ICONLIST.Main:Add("DTextEntry")
	ICONLIST.Search:Dock(TOP)
	ICONLIST.Search:DockMargin(10, 30, 10, 0)
	ICONLIST.Search:SetTall(60)
	ICONLIST.Search.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 240))
		draw.SimpleText(s:GetValue(), "IconMenu24", 10, h * .5, Color(236, 240, 241), 0, 1)
	end

	ICONLIST.List = ICONLIST.Main:Add("DScrollPanel")
	ICONLIST.List:Dock(FILL)
	ICONLIST.List:DockMargin(10, 10, 10, 10)
	ICONLIST.List:SetSize(ICONLIST.Main:GetWide(), ICONLIST.Main:GetTall())

	ICONLIST.Icons = ICONLIST.List:Add("DIconLayout")
	ICONLIST.Icons:Dock(FILL)
	ICONLIST.Icons:SetSize(ICONLIST.List:GetWide(), ICONLIST.List:GetTall() * 1000)
	ICONLIST.Icons:SetLayoutDir(LEFT)
	ICONLIST.Icons:SetSpaceX(10)
	ICONLIST.Icons:SetSpaceY(10)

	ICONLIST.Search.OnChange = function(s)
		if timer.Exists("UpdateIconList") then
			timer.Adjust("UpdateIconList", 0.5, 1, function()
				UpdateIconList()
			end)
		else
			timer.Create("UpdateIconList", 0.5, 1, function()
				UpdateIconList()
			end)
		end
	end

	for IconName, IconCode in SortedPairs(MI) do
		local icon = ICONLIST.Icons:Add("DButton")
		icon:SetText("")
		icon:SetSize(ICONLIST.Icons:GetWide(), 50)
		icon.Paint = function(s, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20))
			draw.SimpleText(IconCode, "MaterialIconsList", w * .05, h * .5, Color(236, 240, 241), 1, 1)
			draw.SimpleText(IconName, "IconMenu24", w * .5, h * .5, Color(236, 240, 241), 1, 1)
		end
		icon.DoClick = function(s)
			SetClipboardText(IconName)
		end

		table.insert(icons, icon)
	end

	function UpdateIconList()
		ICONLIST.Icons:Remove()
		ICONLIST.Icons = nil

		ICONLIST.Icons = ICONLIST.List:Add("DIconLayout")
		ICONLIST.Icons:Dock(FILL)
		ICONLIST.Icons:SetSize(ICONLIST.List:GetWide(), ICONLIST.List:GetTall() * 1000)
		ICONLIST.Icons:SetLayoutDir(LEFT)
		ICONLIST.Icons:SetSpaceX(10)
		ICONLIST.Icons:SetSpaceY(10)

		local search = ICONLIST.Search:GetValue() or ""

		for IconName, IconCode in SortedPairs(MI) do
			if not not string.match(IconName, search) or search == "" then
				local icon = ICONLIST.Icons:Add("DButton")
				icon:SetText("")
				icon:SetSize(ICONLIST.Icons:GetWide(), 50)
				icon.Value = IconName
				icon.Paint = function(s, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20))
					draw.SimpleText(IconCode, "MaterialIconsList", w * .05, h * .5, Color(236, 240, 241), 1, 1)
					draw.SimpleText(IconName, "IconMenu24", w * .5, h * .5, Color(236, 240, 241), 1, 1)
				end
				icon.DoClick = function(s)
					SetClipboardText(s.Value)
				end
				
				table.insert(icons, icon)
			end
		end
	end

	if ICONLIST.Main then
		ICONLIST.Main:Show()
		ICONLIST.Main:MakePopup()
	end
end)