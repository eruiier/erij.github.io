local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local runtime = workspace:WaitForChild("RuntimeItems")
local camera = workspace.CurrentCamera

local foundBonds = {}
local speed = 8000

task.spawn(function()
    wait(20) -- Wait 20 seconds before starting
    
    while true do
        local args = {
            [1] = false
        }

        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(unpack(args))
        
        wait(3) -- Wait 3 seconds before repeating
    end
end)

-- Bond collection (delayed by 25 seconds)
task.spawn(function()
    task.wait(17) -- Wait 25 seconds before starting bond collection

    while true do
        task.wait(0.3) -- Check every 0.3 seconds

        local items = game.Workspace:WaitForChild("RuntimeItems")

        for _, bond in pairs(items:GetChildren()) do
            if bond:IsA("Model") and bond.Name == "Bond" and bond.PrimaryPart then
                local dist = (bond.PrimaryPart.Position - hrp.Position).Magnitude
                if dist < 100 then
                    local rem = game.ReplicatedStorage.Packages.RemotePromise.Remotes.C_ActivateObject
                    rem:FireServer(bond) -- Activate the object
                    print("Bond collected:", bond.Name)
                end
            else
                warn("PrimaryPart missing or object name mismatch for Bond!")
            end
        end
    end
end)

local moveSpeed = 8 -- Increased speed for faster oscillation
local amplitude = 6 -- Adjust the range of movement
local time = 0 -- Keeps track of time for oscillation

-- Ensure camera stays in first-person mode
camera.CameraType = Enum.CameraType.Custom
player.CameraMode = Enum.CameraMode.LockFirstPerson

-- Oscillate the camera's orientation
game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    time = time + deltaTime
    local xRotation = math.sin(time * moveSpeed) * amplitude
    local yRotation = math.cos(time * moveSpeed) * amplitude
    
    local currentCFrame = camera.CFrame
    camera.CFrame = currentCFrame * CFrame.Angles(math.rad(yRotation), math.rad(xRotation), 0)
end)

local function scanForBonds()
    for _, m in ipairs(runtime:GetChildren()) do
        if m:IsA("Model") and (m.Name == "Bond" or m.Name == "Bonds") and m.PrimaryPart then
            local p = m.PrimaryPart.Position
            local exists = false
            for _, v in ipairs(foundBonds) do
                if (v - p).Magnitude < 1 then
                    exists = true
                    break
                end
            end
            if not exists then
                table.insert(foundBonds, p)
            end
        end
    end
end

spawn(function()
    foundBonds = {}
    local startTime = tick()
    local scanConn = RunService.Heartbeat:Connect(scanForBonds)

    scanConn:Disconnect()

    if tick() - startTime < 17 then
        task.wait(17 - (tick() - startTime))
    end

    pcall(function()
        local loadFunction = loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))()
        if not loadFunction then
            print("Loadstring returned nil")
        else
            loadFunction()
        end
    end)
    task.wait(5)

    local collectStart = tick()
    while tick() - collectStart < 41 do
        for _, pos in ipairs(foundBonds) do
            pcall(function()
                hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
            end)
            task.wait(0.6)
        end
    end

    local function safeReset()
        pcall(function()
            player:RequestStreamAroundAsync(hrp.Position)
            if player.Character then
                player.Character:BreakJoints()
                task.wait(0.2)
                player:LoadCharacter()
            end
        end)
    end

    safeReset()
    task.wait(1)
    safeReset()
end)
