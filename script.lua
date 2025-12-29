local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/CenteredSnail/KavUI/main/KavUI.lua"))()
local Window = Library.CreateLib("Brainrot Control Panel", "Ocean")
local MainTab = Window.NewTab("Auto-Farm")
local FarmSection = MainTab.NewSection("Main Functions")

FarmSection.NewToggle("Auto-Grab & Teleport", "Automatically grabs brainrots and teleports to base.", function(state)
    getgenv().AutoFarmEnabled = state
    
    if state then
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local basePosition = nil

            local function findMyBase()
                local basesFolder = workspace:FindFirstChild("Bases")
                if basesFolder then
                    for _, base in ipairs(basesFolder:GetChildren()) do
                        if base:FindFirstChild("Owner") and base.Owner.Value == player then
                            basePosition = base.PrimaryPart.Position
                            Library:Notify("Base encontrada.", 3)
                            return true
                        end
                    end
                end
                Library:Notify("No se pudo encontrar tu base.", 3)
                return false
            end

            while getgenv().AutoFarmEnabled do
                if not basePosition then
                    findMyBase()
                    task.wait(2)
                else
                    local brainrot = character:FindFirstChildWhichIsA("Tool")
                    if brainrot then
                        humanoidRootPart.CFrame = CFrame.new(basePosition + Vector3.new(0, 5, 0))
                        task.wait(1.5)
                        
                        local sellEvent = game.ReplicatedStorage:FindFirstChild("SellBrainrot")
                        if sellEvent then
                            sellEvent:FireServer()
                        end
                        task.wait(2)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

local TeleportTab = Window.NewTab("Teleports")
local TPSection = TeleportTab.NewSection("Locations")

TPSection.NewButton("Teleport to My Base", "Instantly teleports you to your base.", function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local basesFolder = workspace:FindFirstChild("Bases")

    if basesFolder then
        for _, base in ipairs(basesFolder:GetChildren()) do
            if base:FindFirstChild("Owner") and base.Owner.Value == player then
                local pos = base.PrimaryPart.Position
                humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
                Library:Notify("Teletransportado a la base.", 3)
                return
            end
        end
    end
    Library:Notify("No se encontró tu base.", 3)
end)

local InfoTab = Window.NewTab("Info")
local CreditsSection = InfoTab.NewSection("Credits")
CreditsSection.NewLabel("Creado para pruebas en Steal a Brainrot.")
CreditsSection.NewLabel("UI: KavUI")
CreditsSection.NewLabel("Executor: Delta")
