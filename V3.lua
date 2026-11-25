
--[[
    PRINCE MACRO BLUE V3
    Delta Android / Mobileador
    GUI Controller
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local parent = (gethui and gethui()) or game:GetService("CoreGui")

-- Bersihkan GUI lama
local old = parent:FindFirstChild("PRINCE_MACRO_BLUE_V3")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "PRINCE_MACRO_BLUE_V3"
gui.ResetOnSpawn = false
gui.Parent = parent

local blue = Color3.fromRGB(20,130,255)
local dark = Color3.fromRGB(8,20,42)

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(290,350)
main.Position = UDim2.new(.5,-145,.5,-175)
main.BackgroundColor3 = dark
main.Parent = gui

Instance.new("UICorner",main).CornerRadius = UDim.new(0,14)

local stroke = Instance.new("UIStroke")
stroke.Color = blue
stroke.Thickness = 2
stroke.Parent = main

local function button(name,txt,y,color)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1,-24,0,40)
    b.Position = UDim2.fromOffset(12,y)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 15
    b.Font = Enum.Font.GothamBold
    b.Parent = main
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
    return b
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,0,40)
title.Position = UDim2.fromOffset(12,5)
title.BackgroundTransparency = 1
title.Text = "PRINCE MACRO BLUE V3"
title.TextColor3 = Color3.fromRGB(90,180,255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = main

local minimize = button("Minimize","-",8,blue)
minimize.Size = UDim2.fromOffset(35,30)
minimize.Position = UDim2.new(1,-45,0,8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,30)
status.Position = UDim2.fromOffset(10,48)
status.BackgroundTransparency = 1
status.Text = "STATUS: OFF"
status.TextColor3 = Color3.fromRGB(255,100,100)
status.TextSize = 17
status.Font = Enum.Font.GothamBold
status.Parent = main

local start = button("Start","START MACRO",88,Color3.fromRGB(0,160,100))
local stop = button("Stop","STOP MACRO",135,Color3.fromRGB(190,55,65))

local function makeInput(labelText,default,y)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-24,0,25)
    label.Position = UDim2.fromOffset(12,y)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = main

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1,-24,0,30)
    input.Position = UDim2.fromOffset(12,y+25)
    input.BackgroundColor3 = Color3.fromRGB(20,45,75)
    input.Text = default
    input.TextColor3 = Color3.new(1,1,1)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.ClearTextOnFocus = false
    input.Parent = main
    Instance.new("UICorner",input).CornerRadius = UDim.new(0,6)

    return input
end

local speed = makeInput("SPEED (seconds)","0.5",183)
local delay = makeInput("DELAY (seconds)","0.2",253)

local active = false
local speedValue = 0.5
local delayValue = 0.2

local function updateStatus()
    if active then
        status.Text = "STATUS: ON"
        status.TextColor3 = Color3.fromRGB(80,255,130)
    else
        status.Text = "STATUS: OFF"
        status.TextColor3 = Color3.fromRGB(255,100,100)
    end
end

start.MouseButton1Click:Connect(function()
    active = true
    updateStatus()
end)

stop.MouseButton1Click:Connect(function()
    active = false
    updateStatus()
end)

local function readNumber(box,default)
    local n = tonumber(box.Text)
    if not n or n <= 0 then
        box.Text = tostring(default)
        return default
    end
    return math.clamp(n,0.05,10)
end

speed.FocusLost:Connect(function()
    speedValue = readNumber(speed,0.5)
end)

delay.FocusLost:Connect(function()
    delayValue = readNumber(delay,0.2)
end)

local restore
minimize.MouseButton1Click:Connect(function()
    main.Visible = false

    if restore then restore:Destroy() end

    restore = Instance.new("TextButton")
    restore.Size = UDim2.fromOffset(145,40)
    restore.Position = UDim2.new(0,20,.5,0)
    restore.Text = "PRINCE MACRO"
    restore.BackgroundColor3 = blue
    restore.TextColor3 = Color3.new(1,1,1)
    restore.Font = Enum.Font.GothamBold
    restore.Parent = gui

    restore.MouseButton1Click:Connect(function()
        main.Visible = true
        restore:Destroy()
        restore = nil
    end)
end)

-- Drag support
local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("PRINCE MACRO BLUE V3 loaded")
