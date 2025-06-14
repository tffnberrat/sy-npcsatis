local npcModel = `a_m_m_business_01` -- NPC modeli
local npcCoords = vector4(342.14, -1299.72, 32.51, 174.0) -- NPC konumu
local npcName = "Satıcı Mehmet"

local options = {
    {
        label = "Elma Sat",
        item = "apple",
        price = 10,
        webhook = "WEEBHOOK GİRİNİZ"
    },
    {
        label = "Yumurta Sat",
        item = "egg",
        price = 8,
        webhook = "WEEBHOOK GİRİNİZ"
    }
}

-- NPC Oluşturma
CreateThread(function()
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(0)
    end

    local npc = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z - 1, npcCoords.w, false, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                icon = "fas fa-handshake",
                label = "Satış Yap (" .. npcName .. ")",
                action = function()
                    OpenSellMenu()
                end
            }
        },
        distance = 2.5
    })
end)

-- Blip oluştur
local blip = AddBlipForCoord(npcCoords.x, npcCoords.y, npcCoords.z)
SetBlipSprite(blip, 605) -- İstediğin blip ID'sini seçebilirsin
SetBlipDisplay(blip, 4)
SetBlipScale(blip, 0.8)
SetBlipAsShortRange(blip, true)
SetBlipColour(blip, 2)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString(npcName)
EndTextCommandSetBlipName(blip)

-- Menü açma
function OpenSellMenu()
    local menu = {}
    for _, v in pairs(options) do
        table.insert(menu, {
            header = v.label,
            txt = "Sat ve $" .. v.price .. " kazan",
            params = {
                event = "my-sellscript:sellItem",
                args = v
            }
        })
    end

    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent("my-sellscript:sellItem", function(data)
    -- Emote başlat
    local playerPed = PlayerPedId()
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do
        Wait(10)
    end
    TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, 1000, 49, 0, false, false, false)

    -- Satış isteğini server'a gönder
    TriggerServerEvent("my-sellscript:server:sellItem", data)
end)

