local CATEGORY_NAME = "Level System"

function ulx.setlevel(calling_ply, target_plys, level)
    for i = 1, #target_plys do
        target_plys[i]:SetNWInt("Level", level)
        AddXP(target_plys[i], 0)
    end
    ulx.fancyLogAdmin(calling_ply, "#A set the level of #T to #i", target_plys, level)
end

local setlevel = ulx.command(CATEGORY_NAME, "ulx setlevel", ulx.setlevel, "!setlevel")

setlevel:addParam {type = ULib.cmds.PlayersArg}
setlevel:addParam {type = ULib.cmds.NumArg, min = 1, max = 60, hint = "level", ULib.cmds.round}
setlevel:defaultAccess(ULib.ACCESS_SUPERADMIN)
setlevel:help("Sets the level of the target(s).")

function ulx.addxp(calling_ply, target_plys, amount)
    for i = 1, #target_plys do
        AddXP(target_plys[i], amount)
    end
    ulx.fancyLogAdmin(calling_ply, "#A added #i XP to #T", amount, target_plys)
end

local addxp = ulx.command(CATEGORY_NAME, "ulx addxp", ulx.addxp, "!addxp")

addxp:addParam {type = ULib.cmds.PlayersArg}
addxp:addParam {type = ULib.cmds.NumArg, min = 1, max = 60000, hint = "XP", ULib.cmds.round}
addxp:defaultAccess(ULib.ACCESS_SUPERADMIN)
addxp:help("Add XP to a the target(s).")

function ulx.resetlevel(calling_ply, target_plys)
    for i = 1, #target_plys do
        target_plys[i]:SetNWInt("Level", 1)
        target_plys[i]:SetNWInt("XP", 0)
        AddXP(target_plys[i], 0)
    end
    ulx.fancyLogAdmin(calling_ply, "#A reset the level of #T", target_plys)
end

local resetlevel = ulx.command(CATEGORY_NAME, "ulx resetlevel", ulx.resetlevel, "!resetlevel")

resetlevel:addParam {type = ULib.cmds.PlayersArg}
resetlevel:defaultAccess(ULib.ACCESS_SUPERADMIN)
resetlevel:help("Reset the level of the target(s).")
