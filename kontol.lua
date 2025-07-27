-- Farelhub V4 - GUI Base dengan fitur awal: ESP Skeleton, Aimbot, Noclip

-- // LIBRARY UI (Basic GUI Builder) // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MinimizeButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local ToggleESP = Instance.new("TextButton")
local ToggleAimbot = Instance.new("TextButton")
local ToggleNoclip = Instance.new("TextButton")

-- Properti GUI
ScreenGui.Name = "FarelhubGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- Pink
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Text = "-"

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Text = "Farelhub V4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true

ToggleESP.Name = "ToggleESP"
ToggleESP.Parent = MainFrame
ToggleESP.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
ToggleESP.Position = UDim2.new(0, 20, 0, 50)
ToggleESP.Size = UDim2.new(0, 260, 0, 40)
ToggleESP.Text = "ESP Skeleton (ON)"

ToggleAimbot.Name = "ToggleAimbot"
ToggleAimbot.Parent = MainFrame
ToggleAimbot.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
ToggleAimbot.Position = UDim2.new(0, 20, 0, 100)
ToggleAimbot.Size = UDim2.new(0, 260, 0, 40)
ToggleAimbot.Text = "Aimbot (ON)"

ToggleNoclip.Name = "ToggleNoclip"
ToggleNoclip.Parent = MainFrame
ToggleNoclip.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
ToggleNoclip.Position = UDim2.new(0, 20, 0, 150)
ToggleNoclip.Size = UDim2.new(0, 260, 0, 40)
ToggleNoclip.Text = "Noclip (ON)"

-- // MINIMIZE HANDLER // --
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") and child ~= MinimizeButton then
            child.Visible = not minimized
        end
    end
end)

-- // VARIABEL FITUR // --
local espEnabled = true
local aimbotEnabled = true
local noclipEnabled = true
local aiming = false

-- // TOGGLE BUTTON HANDLER // --
ToggleESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ToggleESP.Text = "ESP Skeleton (" .. (espEnabled and "ON" or "OFF") .. ")"
end)

ToggleAimbot.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    ToggleAimbot.Text = "Aimbot (" .. (aimbotEnabled and "ON" or "OFF") .. ")"
end)

ToggleNoclip.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    ToggleNoclip.Text = "Noclip (" .. (noclipEnabled and "ON" or "OFF") .. ")"
end)

-- // ESP SKELETON // --
local function createLine(parent, color)
    local line = Instance.new("Frame")
    line.BackgroundColor3 = color
    line.BorderSizePixel = 0
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Size = UDim2.new(0, 2, 0, 2)
    line.ZIndex = 10
    line.Parent = parent
    return line
end

local skeletons = {}

local function drawSkeleton(player)
    if player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if not skeletons[player] then
        skeletons[player] = {}
        local folder = Instance.new("Folder", ScreenGui)
        folder.Name = player.Name .. "_ESP"
        skeletons[player].folder = folder
        skeletons[player].lines = {}
        for i = 1, 5 do
            local line = createLine(folder, Color3.fromRGB(255, 0, 0))
            table.insert(skeletons[player].lines, line)
        end
    end
end

local function updateSkeletons()
    for _, player in ipairs(Players:GetPlayers()) do
        if espEnabled then
            drawSkeleton(player)
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local pos, onscreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                for _, line in ipairs(skeletons[player].lines) do
                    line.Visible = onscreen
                    line.Position = UDim2.new(0, pos.X, 0, pos.Y)
                end
            end
        else
            if skeletons[player] then
                skeletons[player].folder:Destroy()
                skeletons[player] = nil
            end
        end
    end
end

RunService.RenderStepped:Connect(updateSkeletons)

-- // AIMBOT (klik *tahan* kanan jika toggle aktif) // --
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and aiming then
        local closest = nil
        local shortestDistance = math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closest = player
                    end
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
        end
    end
end)

-- // NOCLIP (toggle aktif) // --
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

print("[Farelhub V4 GUI + ESP + Aimbot + Noclip Loaded]")
