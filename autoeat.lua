--[MUFFINN STORE]--
local registered_ids = {134611, 601763}

peopleHide = 0 -- Hide People
dropHidden = 0 -- Hide Drops
removeAnimation = false -- true or false (Usage; It Removes the Breaking Effect & Animations when Farming)
removeCollected = false -- true or false (Usage; It Removes the Message when Farming)
buyLock = false
consumeArroz = false
consumeClover = false
nowBuy = true
currentGem = GetPlayerInfo().gems
--------------------------------------

local function split(inputstr, sep)
    t = {}
    for str in string.gmatch(inputstr, "([^".. sep .."]+)") do
        table.insert(t, str)
    end
    return t
end

local function removeColorAndSymbols(str)
    cleanedStr = string.gsub(str, "`(%S)", '')
    cleanedStr = string.gsub(cleanedStr, "`{2}|(~{2})", '')
    return cleanedStr
end

local function findItem(id)
    count = 0
    for _, inv in pairs(GetInventory()) do
        if inv.id == id then
            count = count + inv.amount
        end
    end
    return count
end

function convert(id)
    pkt = {}
    pkt.value = id
    pkt.type = 10
    SendPacketRaw(false, pkt)
end

AddHook("onvariant", "mommy", function(var)
    if var[0] == "OnSDBroadcast" then 
        return true
    end
    if var[0] == "OnDialogRequest" and var[1]:find("add_player_info") then
        if var[1]:find("|528|") then
            consumeClover = true
        else
            consumeClover = false
        end

        if var[1]:find("|4604|") then
            consumeArroz = true
        else
            consumeArroz = false
        end

        return true
    end
    if var[0] == "OnConsoleMessage" and var[1]:find("Unknown command.") then
        return true
    end
    if var[0] == "OnTalkBubble" and var[2]:match("Collected") then
        if removeCollected then
            return true
        end
    end
end)

AddHook("onsendpacket", "lovelymoan", function(type, packet)
    args = split(packet:gsub("action|input\n|text|", ""), " ")
    command = string.lower(args[1])
    if command == ("/p") then
       SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|1\ncheck_bfg|1\ncheck_lonely".. peopleHide .."\ncheck_ignoreo|".. dropHidden .."\ncheck_gems|".. takeGems)
    else
        if command == ("/s") then
                  SendPacket(2, "action|dialog_return\ndialog_name|cheats\ncheck_autofarm|0\ncheck_bfg|0\ncheck_lonely|0\ncheck_ignoreo|0\ncheck_gems|".. takeGems)
                  return true
              end
              return false
           end
end)

if not removeAnimation then
    removeAnimation = false
end

AddHook("onprocesstankupdatepacket", "pussy", function(packet)
    if packet.type == 3 or packet.type == 8 or packet.type == 17 then
        if removeAnimation then
            return true
        end
    end
end)

local function place(id, x, y)
    pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 +x)
    pkt.py = math.floor(GetLocal().pos.y / 32 +y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

local function wrenchMe()
    SendPacket(2, "action|wrench\n|netid|".. GetLocal().netid)
    Sleep(100)
end

function crd()
SendPacket(2, "action|input\ntext|`2START SCRIPT!")
Sleep(1000)
SendPacket(2, "action|input\ntext|`9TYPE /p TO START!")
Sleep(1000)
SendPacket(2, "action|input\ntext|`4TYPE /s TO STOP!")
Sleep(1000)
end

-- Fungsi untuk memeriksa apakah ID pengguna terdaftar
local function is_registered_id(id)
    for _, registered_id in ipairs(registered_ids) do
        if id == registered_id then
            return true
        end
    end
    return false
end

-- Mendapatkan ID pengguna lokal
local user_id = GetLocal().userid

if is_registered_id(user_id) then
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0] `^IDENTIFY PLAYER : " .. GetLocal().name)
    Sleep(1000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0] `^CHECKING UID")
    Sleep(3000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0] `^UID TERDAFTAR")
    Sleep(1000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0] `^STARTING AUTO EAT CONSUMBE PREMIUM")
    Sleep(1000)
crd()

while true do
            wrenchMe()
            if not consumeArroz then
                Sleep(100)
                for i = 1, 1 do
                    if autoArroz then
                        place(4604, 0, 0)
                        break
                    end
                end
            end

            wrenchMe()
            if not consumeClover then
                Sleep(100)
                for i = 1, 1 do
                    if autoClover then
                        place(528, 0, 0)
                        break
                    end
                end
            end

            if nowBuy then
                if autoCV then
                    if GetPlayerInfo().gems >= 10000 then
                        buyLock = true
                        if buyLock then
                            SendPacket(2, "action|buy\nitem|buy_worldlockpack")
                            Sleep(100)
                        end
                    end

                    if GetPlayerInfo().gems < 10000 then
                        buyLock = false
                        Sleep(100)
                    end

                    if findItem(242) >= 100 then
                        convert(242)
                    end
                end
            end
end
else
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0] `^IDENTIFY PLAYER : " .. GetLocal().name)
    Sleep(1000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0] `^CHECKING UID")
    Sleep(3000)
    LogToConsole("`0[`^MUFFINN`0-`^STORE`0] `4UID TIDAK TERDAFTAR KONTAK DISCORD MUFFINN_S")
end
