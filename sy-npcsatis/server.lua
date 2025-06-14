local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("my-sellscript:server:sellItem", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local itemName = data.item
    local pricePerItem = data.price

    local itemCount = 0
    local playerItem = Player.Functions.GetItemByName(itemName)
    if playerItem then
        itemCount = playerItem.amount
    end

    if itemCount > 0 then
        local totalPrice = pricePerItem * itemCount

        Player.Functions.RemoveItem(itemName, itemCount)
        Player.Functions.AddMoney("cash", totalPrice, "item-sell")

        TriggerClientEvent('QBCore:Notify', src, itemName .. " (x" .. itemCount .. ") başarıyla satıldı! Toplam: $" .. totalPrice, "success")

        -- Webhook gönder
        SendWebhook(data.webhook, "**Satış İşlemi**\nOyuncu: " .. GetPlayerName(src) .. "\nEşya: " .. itemName .. " (x" .. itemCount .. ")\nKazanç: $" .. totalPrice)
    else
        TriggerClientEvent('QBCore:Notify', src, "Bu eşyaya sahip değilsin!", "error")
    end
end)

function SendWebhook(url, message)
    PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({
        username = "Lite Development",
        embeds = {{
            description = message,
            color = 65352
        }}
    }), {
        ['Content-Type'] = 'application/json'
    })
end
