--[[
    YYDS SnitchList.lua
    外部黑名單 + 檢測模組
    主腳本載入後即可使用 getgenv().YYDS_Snitch
]]

local watchIds = {
    "keanrick",
    "Mr_MidKnight12",
    "xXBiennypremeXx",
    "geno2352",
    "Armuless",
    "Dr_who2781",
    "xmrroboto",
    "elreylucho26",
    "alexg4mes12",
    "Alex52883",
    "HECHESON",
    "Suporter_C00lKidd213",
    "ZOPsuh",
    "Joofgiin_official",
    "Leer_82",
    "BoxAr03_07",
    "RulingX2",
    "eivisaltother",
    "Jakesiren2013",
    "GLM1014",
    "WantedHitman_1",
    "leo_go1863",
    "CNight_1Shade",
    "JohnCene2012",
    "BoltsRB",
    "pasta070",
    "prisnor123467",
    "ensjjjjbrother",
    "jorgelsalvaje5",
    "DavidHagibator",
    "BonusGigachad",
    "Eliasss16",
    "soynessitopro",
    "Nazahar2",
    "Aki_Baddie",
    "Sami346m",
    "Michi_2208",
    "Vaeitay",
    "juston700",
    "ovalsergito2",
    "EEEispro1",
    "Chamihunt456",
    "Reset50325554",
    "JCross0611",
    "crisplymans",
    "Cygferro2",
    "yolomangjk",
    "tupapiricooooooa",
    "roblox_user_3845927828",
    "TheRawStrawberry",
    "anqlicvs",
    "SouIeyy",
    "Landoathug34",
    "unknown_beatss",
    "FireMeteorguy",
    "iannflamingofan2",
    "ChickenMcCrunch123",
    "Breeqz",
    "branmol",
    "El_Darx",
    "Ashpegz135",
    "MaaD_x1",
    "maxigodloki",
    "roblox_user_10150856821",
    "frainel2",
    "heyimgael",
    "camote485",
    "efrenhf",
    "Afgxkgaj",
    "reefeyboy139",
    "Faye_9753",
    "Dw200534",
    "lostyzr",
    "MrZNuke",
    "zwmbiec0",
    "latadeservesa122",
    "Cavalao_1111",
    "dj7i8",
    "fixerupe",
    "felixi_gdw",
    "Gianni_Silver",
    "holdstillgihun456",
    "thekiller_069",
    "tigrina122",
    "ANGEL1929ZORO",
    "mrbonineprogamer",
    "BxlletAnt",
}

local adminIds = {
    "Taraaaa_06",
    "MarvellousClint",
    "Alaera",
    "AmTheLastFloppaEver",
}

-- 建立快速查詢表（比較快）
local watchMap = {}
local adminMap = {}

for _, name in ipairs(watchIds) do
    watchMap[string.lower(name)] = true
end
for _, name in ipairs(adminIds) do
    adminMap[string.lower(name)] = true
end

local function checkPlayer(plr)
    if not plr or not plr.Name then
        return nil
    end
    local low = string.lower(plr.Name)
    if adminMap[low] then
        return "admin"
    end
    if watchMap[low] then
        return "watch" -- snitch
    end
    return nil
end

-- 掃描目前在線的所有玩家
local function scanAll()
    local Players = game:GetService("Players")
    local adminHits = {}
    local watchHits = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        local kind = checkPlayer(plr)
        if kind == "admin" then
            table.insert(adminHits, plr.Name)
        elseif kind == "watch" then
            table.insert(watchHits, plr.Name)
        end
    end
    return adminHits, watchHits
end

-- 暴露給主腳本
getgenv().YYDS_Snitch = getgenv().YYDS_Snitch or {}

getgenv().YYDS_Snitch.check = checkPlayer
getgenv().YYDS_Snitch.scanAll = scanAll
getgenv().YYDS_Snitch.getLists = function()
    return watchIds, adminIds
end
getgenv().YYDS_Snitch.onDetect = getgenv().YYDS_Snitch.onDetect -- 保留主腳本可能已經掛上的回調

print("[YYDS] SnitchList loaded | Snitches:", #watchIds, "| Admins:", #adminIds)
