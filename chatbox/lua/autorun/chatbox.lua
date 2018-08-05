if not CLIENT then
    AddCSLuaFile()
    return
end

chatbox = {}
ply = LocalPlayer()

surface.CreateFont(
    "ChatFont",
    {
        font = "Trebuchet",
        extended = false,
        size = 20,
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

local SKIN = {}

function SKIN:PaintScrollBarGrip(panel, width, height)
    draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
end

derma.DefineSkin("RichTextScroll", "customscrollbar", SKIN)

function CreateChat()
    chatbox.main = vgui.Create("DFrame")
    chatbox.main.background = chatbox.main:Add("DPanel")
    chatbox.main.text = chatbox.main:Add("RichText")
    chatbox.main.entry = chatbox.main:Add("DTextEntry")
    chatbox.main.typing = false

    chatbox.main:SetPos(25, 400)
    chatbox.main:SetSize(600, 300)
    chatbox.main:SetDraggable(true)
    chatbox.main:ShowCloseButton(false)
    chatbox.main:SetTitle("")
    chatbox.main.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
    end

    chatbox.main.background:SetSize(590, 265)
    chatbox.main.background:SetPos(5, 5)
    chatbox.main.background.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
    end

    chatbox.main.text:SetPos(10, 5)
    chatbox.main.text:SetSize(585, 285)
    chatbox.main.text:GotoTextEnd()
    chatbox.main.text:SetVerticalScrollbarEnabled(true)
    chatbox.main.text:SetSkin("RichTextScroll")

    function chatbox.main.text:PerformLayout()
        self:SetFontInternal("ChatFont")
        self:SetFGColor(Color(255, 255, 255))
    end

    chatbox.main.entry:SetPos(5, 275)
    chatbox.main.entry:SetSize(590, 20)
    chatbox.main.entry.Paint = function(s, width, height)
        draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
        draw.SimpleText(s:GetValue(), "ChatFont", 0, -2, Color(255, 255, 255, 255), 0, 0)
    end

    chatbox.main:Hide()
end

function ChatTimer()
    if chatbox.main.typing == false then
        if timer.Exists("chattime") then
            timer.Remove("chattime")
            timer.Create(
                "chattime",
                5,
                1,
                function()
                    chatbox.main:Hide()
                end
            )
        else
            timer.Create(
                "chattime",
                5,
                1,
                function()
                    chatbox.main:Hide()
                end
            )
        end
    end
end

hook.Remove("Initialize", "makechat")
hook.Add("Initialize", "makechat", CreateChat)

hook.Remove("ChatTextChanged", "chatupdate")
hook.Add(
    "ChatTextChanged",
    "chatupdate",
    function(text)
        if not chatbox.main then
            CreateChat()
        end

        chatbox.main.entry:SetText(text)
    end
)

hook.Remove("StartChat", "chatbox")
hook.Add(
    "StartChat",
    "chatbox",
    function()
        if not chatbox.main then
            CreateChat()
        end

        chatbox.main:Show()

        chatbox.main.Paint = function(s, width, height)
            draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
        end

        chatbox.main.background.Paint = function(s, width, height)
            draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
        end

        chatbox.main.entry.Paint = function(s, width, height)
            draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
            draw.SimpleText(" " .. s:GetValue(), "ChatFont", 0, -2, Color(255, 255, 255, 255), 0, 0)
        end

        chatbox.main.typing = true

        if timer.Exists("chattime") then
            timer.Remove("chattime")
        end

        chatbox.main.text:GotoTextEnd()

        return true
    end
)

hook.Remove("ChatText", "chatnotify")
hook.Add(
    "ChatText",
    "chatnotify",
    function(index, name, text, type)
        if not chatbox.main then
            CreateChat()
        end

        chatbox.main:Show()

        chatbox.main.text:AppendText(text .. "\n")

        if chatbox.main.typing == false then
            chatbox.main.text:GotoTextEnd()
        end

        ChatTimer()

        return true
    end
)

hook.Remove("OnPlayerChat", "playersaid")
hook.Add(
    "OnPlayerChat",
    "playersaid",
    function()
        if not chatbox.main then
            CreateChat()
        end

        chatbox.main:Show()

        if chatbox.main.typing == false then
            chatbox.main.text:GotoTextEnd()
        end

        ChatTimer()
    end
)

local oldAddText = chat.AddText

function chat.AddText(...)
    local args = {...}

    for _, obj in pairs(args) do
        if type(obj) == "table" then
            chatbox.main.text:InsertColorChange(obj.r, obj.g, obj.b, 255)
        elseif type(obj) == "string" then
            chatbox.main.text:AppendText(obj)
        elseif obj:IsPlayer() then
            local col = GAMEMODE:GetTeamColor(obj)

            chatbox.main.text:InsertColorChange(col.r, col.g, col.b, 255)
            chatbox.main.text:AppendText(obj:Nick())
        end
    end

    chatbox.main.text:AppendText("\n")

    chatbox.main:Show()

    ChatTimer()

    oldAddText(...)
end

hook.Remove("FinishChat", "chatboxclose")
hook.Add(
    "FinishChat",
    "chatboxclose",
    function()
        if not chatbox.main then
            CreateChat()
        end

        chatbox.main.typing = false

        chatbox.main.Paint = function(s, width, height)
            draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
        end

        chatbox.main.background.Paint = function(s, width, height)
            draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
        end

        chatbox.main.entry.Paint = function(s, width, height)
            draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 0))
        end

        chatbox.main.text:GotoTextEnd()

        ChatTimer()
    end
)
