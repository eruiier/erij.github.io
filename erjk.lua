

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
 local speed = 6000

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

local bondCount = 0
local bondSet = {}

-- Create GUI for tracking bonds
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local BondLabel = Instance.new("TextLabel")
BondLabel.Parent = ScreenGui
BondLabel.Size = UDim2.new(0, 200, 0, 50)
BondLabel.Position = UDim2.new(0.5, -100, 0.1, 0)
BondLabel.BackgroundTransparency = 0.5
BondLabel.TextScaled = true
BondLabel.TextColor3 = Color3.new(1, 1, 1)
BondLabel.Text = "Bonds Discovered: 0"

-- Function to update bond count dynamically
local function updateBondCount()
    for _, item in pairs(workspace.RuntimeItems:GetChildren()) do
        if item:IsA("Model") and item.Name == "Bond" and not bondSet[item] then
            bondSet[item] = true
            bondCount += 1
            BondLabel.Text = "Bonds Discovered: " .. bondCount
        end
    end
end

-- Continuously scan for bonds and update the GUI
task.spawn(function()
    while true do
        updateBondCount()
        task.wait(0.3) -- Update every 0.5 seconds
    end
end)

-- Final display on completion
task.spawn(function()
    -- Assuming completion happens after bond collection phase ends
    task.wait(27) -- Example: Wait for 35 seconds to simulate "completion"
    BondLabel.Text = "Final Bonds Discovered: " .. bondCount
    BondLabel.BackgroundColor3 = Color3.new(0, 1, 0) -- Green to indicate completion
end)






-- Bond collection (delayed by 25 seconds)
task.spawn(function()
    task.wait(27) -- Wait 25 seconds before starting bond collection

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
 
 
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local verticalSpeed = 20 -- Speed for upward and downward motion
local horizontalSpeed = 50 -- Speed for rightward motion
local verticalAmplitude = 10 -- Range of vertical movement
local horizontalAmplitude = 15 -- Range of horizontal movement
local time = 0 -- Keeps track of time for oscillation

-- Ensure camera stays in first-person mode
camera.CameraType = Enum.CameraType.Custom
player.CameraMode = Enum.CameraMode.LockFirstPerson

-- Oscillate the camera's orientation
game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    time = time + deltaTime * 4 -- Make the motion extremely fast

    -- Fast upward and downward motion
    local xRotation = math.sin(time * verticalSpeed) * verticalAmplitude

    -- Fast rightward motion with slight leftward correction (never fully left)
    local yRotation = math.abs(math.cos(time * horizontalSpeed)) * horizontalAmplitude

    -- Apply the new rotations to the camera
    local currentCFrame = camera.CFrame
    camera.CFrame = currentCFrame * CFrame.Angles(math.rad(xRotation), math.rad(yRotation), 0)
end)
 
 local pathPoints = {
     Vector3.new(13.66, 120, 29620.67), Vector3.new(-15.98, 120, 28227.97),
     Vector3.new(-63.54, 120, 26911.59), Vector3.new(-75.71, 120, 25558.11),
     Vector3.new(-49.51, 120, 24038.67), Vector3.new(-34.48, 120, 22780.89),
     Vector3.new(-63.71, 120, 21477.32), Vector3.new(-84.23, 120, 19970.94),
     Vector3.new(-84.76, 120, 18676.13), Vector3.new(-87.32, 120, 17246.92),
     Vector3.new(-95.48, 120, 15988.29), Vector3.new(-93.76, 120, 14597.43),
     Vector3.new(-86.29, 120, 13223.68), Vector3.new(-97.56, 120, 11824.61),
     Vector3.new(-92.71, 120, 10398.51), Vector3.new(-98.43, 120, 9092.45),
     Vector3.new(-90.89, 120, 7741.15), Vector3.new(-86.46, 120, 6482.59),
     Vector3.new(-77.49, 120, 5081.21), Vector3.new(-73.84, 120, 3660.66),
     Vector3.new(-73.84, 120, 2297.51), Vector3.new(-76.56, 120, 933.68),
     Vector3.new(-81.48, 120, -429.93), Vector3.new(-83.47, 120, -1683.45),
     Vector3.new(-94.18, 120, -3035.25), Vector3.new(-109.96, 120, -4317.15),
     Vector3.new(-119.63, 120, -5667.43), Vector3.new(-118.63, 120, -6942.88),
     Vector3.new(-118.09, 120, -8288.66), Vector3.new(-132.12, 120, -9690.39),
     Vector3.new(-122.83, 120, -11051.38), Vector3.new(-117.53, 120, -12412.74),
     Vector3.new(-119.81, 120, -13762.14),Vector3.new(-126.27, 120, -15106.33),
     Vector3.new(-134.45, 120, -16563.82),Vector3.new(-129.85, 120, -17884.73),
     Vector3.new(-127.23, 120, -19234.89),Vector3.new(-133.49, 120, -20584.07),
     Vector3.new(-137.89, 120, -21933.47),Vector3.new(-139.93, 120, -23272.51),
     Vector3.new(-144.12, 120, -24612.54),Vector3.new(-142.93, 120, -25962.13),
     Vector3.new(-149.21, 120, -27301.58),Vector3.new(-156.19, 120, -28640.93),
     Vector3.new(-164.87, 120, -29990.78),Vector3.new(-177.65, 120, -31340.21),
     Vector3.new(-184.67, 120, -32689.24),Vector3.new(-208.92, 120, -34027.44),
     Vector3.new(-227.96, 120, -35376.88),Vector3.new(-239.45, 120, -36726.59),
     Vector3.new(-250.48, 120, -38075.91),Vector3.new(-260.28, 120, -39425.56),
     Vector3.new(-274.86, 120, -40764.67),Vector3.new(-297.45, 120, -42103.61),
     Vector3.new(-321.64, 120, -43442.59),Vector3.new(-356.78, 120, -44771.52),
     Vector3.new(-387.68, 120, -46100.94),Vector3.new(-415.83, 120, -47429.85),
     Vector3.new(-452.39, 120, -49407.44)
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
             end
         end
     end
 end
 
local function filterPathPoints()
    local filteredPoints = {}

    for _, pt in ipairs(pathPoints) do
        local exactMatch = false

        for _, bondPos in ipairs(foundBonds) do
            if bondPos == pt then  -- Ensure exact matches are removed
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
 
     if tick() - startTime < 27 then
         task.wait(27 - (tick() - startTime))
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

pcall(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/train.github.io/refs/heads/main/train.lua'))()
end)

task.wait(4) -- Ensure a 4-second delay after loading the train script before any other actions.


 
     local collectStart = tick()
     while tick() - collectStart < 35 do
         for _, pos in ipairs(foundBonds) do
             pcall(function()
                 hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
             end)
             task.wait(0.5)
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
