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
                local bondPosition = bond.PrimaryPart.Position
                local exists = false

                for _, trackedBond in ipairs(foundBonds) do
                    if (trackedBond - bondPosition).Magnitude < 1 then
                        exists = true
                        break
                    end
                end

                if not exists then
                    table.insert(foundBonds, bondPosition)
                    print("New bond found and added: ", bondPosition)
                end
            else
                warn("PrimaryPart missing or object name mismatch for Bond!")
            end
        end
    end
end)

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

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

local pathPoints = {
    Vector3.new(13.66, 120, 29620.67), Vector3.new(-15.98, 120, 28227.97),
    -- Truncated for brevity; include all path points here
    Vector3.new(-415.83, 120, -47429.85), Vector3.new(-452.39, 120, -49407.44)
}

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
                print("New bond detected during runtime: ", p)
            end
        end
    end
end

local function filterPathPoints()
    local filteredPoints = {}

    for _, pt in ipairs(pathPoints) do
        local exactMatch = false

        for _, bondPos in ipairs(foundBonds) do
            if bondPos == pt then -- Ensure exact matches are removed
                exactMatch = true
                break
            end
        end

        if not exactMatch then
            table.insert(filteredPoints, pt)
        end
    end

    return filteredPoints
end

spawn(function()
    foundBonds = {}
    local startTime = tick()
    local scanConn = RunService.Heartbeat:Connect(scanForBonds)

    -- Follow pathway points first
    for _, pt in ipairs(pathPoints) do
        local dist = (hrp.Position - pt).Magnitude
        local tween = TweenService:Create(
            hrp,
            TweenInfo.new(dist / speed, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(pt)}
        )
        tween:Play()
        tween.Completed:Wait()
    end

    scanConn:Disconnect()

    if tick() - startTime < 17 then
        task.wait(17 - (tick() - startTime))
    end

    pcall(function()
        local loadFunction = loadstring(game:HttpGet("https://raw.githubusercontent.com/eruiier/vampire.github.io/refs/heads/main/chair.lua"))()
        local loadFunction2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))()
        if not loadFunction then
            print("Loadstring returned nil")
        else
            loadFunction()
        end
        if loadFunction2 then
            loadFunction2()
        end
    end)
    task.wait(5)

    -- Start moving to bonds in reverse order
    if #foundBonds > 0 then
        print("Starting reverse traversal of bonds...")
        for i = #foundBonds, 1, -1 do -- Traverse foundBonds in reverse
            local bondPos = foundBonds[i]
            local dist = (hrp.Position - bondPos).Magnitude
            local tween = TweenService:Create(
                hrp,
                TweenInfo.new(dist / speed, Enum.EasingStyle.Linear),
                {CFrame = CFrame.new(bondPos)}
            )
            tween:Play()
            tween.Completed:Wait()
            print("Visited bond position:", bondPos)
        end
    else
        print("No bonds found in the list after pathway points!")
    end

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
