local CATEGORY_NAME = "Chat"

function ulx.content(calling_ply)
    calling_ply:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1439173450")]])
end

local content = ulx.command(CATEGORY_NAME, "ulx content", ulx.content, "!content", true)

content:defaultAccess(ULib.ACCESS_ALL)
content:help("Opens the server workshop content.")
