local discordWebhook = "webhook_gir_enayi"

function GetPlayerInfo(source)
    local playerPed = GetPlayerPed(source)
    if not DoesEntityExist(playerPed) then
        print("Invalid player entity!")
        return nil
    end

    local function GetIdentifier(idType)
        for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
            if string.find(identifier, idType) then
                return string.sub(identifier, #idType + 1)
            end
        end
        return nil
    end

    local discordId = GetIdentifier("discord:")
    local discordName = discordId and GetPlayerName(source) or nil
    local steamHex = GetIdentifier("steam:")
    local ip = GetPlayerEndpoint(source)
    local health = GetEntityHealth(playerPed)
    local playerCoords = GetEntityCoords(playerPed)

    return {
        discordId = discordId,
        discordName = discordName,
        steamHex = steamHex,
        ip = ip,
        health = health,
        lastLocation = {
            x = playerCoords.x,
            y = playerCoords.y,
            z = playerCoords.z
        }
    }
end

function LogGonder(source, olay)
    local kullaniciBilgileri = GetPlayerInfo(source)
    if not kullaniciBilgileri then
        return
    end

    local tarih = os.date("%Y-%m-%d")
    local saat = os.date("%H:%M:%S")

    local embed = {
        {
            ["color"] = 16711680,
            ["title"] = "Olay Bildirimi",
            ["description"] = olay,
            ["fields"] = {
                {["name"] = "Discord ID", ["value"] = kullaniciBilgileri.discordId, ["inline"] = true},
                {["name"] = "Steam Adı", ["value"] = kullaniciBilgileri.discordName, ["inline"] = true},
                {["name"] = "Steam HEX ID", ["value"] = kullaniciBilgileri.steamHex, ["inline"] = true},
                {["name"] = "Tarih", ["value"] = tarih, ["inline"] = true},
                {["name"] = "Saat", ["value"] = saat, ["inline"] = true},
                {["name"] = "IP Adresi", ["value"] = kullaniciBilgileri.ip, ["inline"] = true},
                {["name"] = "Sağlık", ["value"] = kullaniciBilgileri.health, ["inline"] = true},
                {["name"] = "Son Konum", ["value"] = string.format("X: %s\nY: %s\nZ: %s", kullaniciBilgileri.lastLocation.x, kullaniciBilgileri.lastLocation.y, kullaniciBilgileri.lastLocation.z), ["inline"] = true}
            },
            ["footer"] = {
                ["text"] = "Log Sistemi"
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
        }
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, "POST", json.encode({embeds = embed}), {["Content-Type"] = "application/json"})
end


AddEventHandler("playerDropped", function(reason)
    local source = source
    local playerName = GetPlayerName(source)
    local olay = playerName .. " sunucudan ayrıldı. (" .. reason .. ")"
    LogGonder(source, olay)
end)

AddEventHandler("chatMessage", function(source, name, message)
    local playerName = GetPlayerName(source)
    local olay = playerName .. " mesaj gönderdi: " .. message
    LogGonder(source, olay)
end)

RegisterServerEvent("logGonder:event")
AddEventHandler("logGonder:event", function(olay)
    local source = source
    LogGonder(source, olay)
end)
