local lib = loadstring(game:HttpGet("https://pastefy.app/ioqG9Tsa/raw"))()

local FUCK = lib.new("Aux Hub")

FUCK:Label("> Give Stack And Cash")
FUCK:Sep()

FUCK:Button("REJOIN", function()
    local TeleportService = game:GetService("TeleportService")
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)

FUCK:Toggle("Give Cash And Stack", function()
    for i = 1, 100 do
    pcall(function()
        game:GetService("ReplicatedStorage")
            .Modules
            .EventManagerClient
            .ServerEvent
            :FireServer("ClaimReward")
    end)
end
end, 0.1)
