-- Script/Liblary By VantaXock on ScriptBlox
local lib = loadstring(game:HttpGet("https://pastefy.app/ioqG9Tsa/raw"))()

local w = lib.new("Aux Hub")

local autoRebirthEnabled = false
local autoRebirthLoop = nil

local function fireRebirthRemotes()
    local events = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
    if events then
        local rebirthevents = {"RebirthSuccess", "RequestRebirth", "LevelUp", "UpgradeSuccess"}
        for _, name in ipairs(rebirthevents) do
            local remote = events:FindFirstChild(name)
            if remote then
                if remote:IsA("RemoteEvent") then
                    remote:FireServer()
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer()
                end
                print("Fired: " .. name)
                task.wait(0.1)
            end
        end
    end
end

local function autoRebirthLoopFunc()
    while autoRebirthEnabled do
        fireRebirthRemotes()
        task.wait(1)
    end
end

local function teleportGiveWinsParts()
    -- use fucking multi name because i forgot what actually name is.
    local folder = nil
    local possibleNames = {"GiveWins", "giveWins", "GIVEWINS", "Givewins", "givewins"}
    
    for _, name in ipairs(possibleNames) do
        folder = game.Workspace:FindFirstChild(name)
        if folder then break end
    end
    
    if not folder then
        warn("GiveWins folder not fucking found.")
        return false
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    
    if not torso then
        warn("fucking torso can't found")
        return false
    end
    
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CFrame = torso.CFrame
                    part.Anchored = false
                    part.CanCollide = true
                    part.Transparency = 1
                    part.Material = Enum.Material.Plastic
                end
            end
        end
    end
    
    print("fuck")
    return true
end

w:Label("Auto Farms")
w:Sep()

local farm = w:Toggle("Auto Step", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AddSpeed"):FireServer()
end, 0.1)

local teleport = w:Toggle("Auto Wins", function()
    teleportGiveWinsParts()
end)

w:Sep()
w:Label("Auto REBIRTH")
w:Sep()

local farm = w:Toggle("auto REBIRTH", function()
    fireRebirthRemotes()
end, 0.1)
