--[[
    Rivals-style client UI starter
    Install as a LocalScript in StarterPlayer > StarterPlayerScripts.
    This is a legitimate Roblox Studio client UI. It does not inject into
    another experience, modify server data, unlock paid items, or automate combat.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("RivalsClientUI")
if oldGui then
    oldGui:Destroy()
end

local COLORS = {
    background = Color3.fromRGB(18, 16, 31),
    panel = Color3.fromRGB(29, 25, 48),
    panel2 = Color3.fromRGB(39, 33, 62),
    accent = Color3.fromRGB(174, 105, 255),
    text = Color3.fromRGB(245, 241, 255),
    muted = Color3.fromRGB(170, 160, 195),
    good = Color3.fromRGB(115, 225, 170),
}

local screen = Instance.new("ScreenGui")
screen.Name = "RivalsClientUI"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = false
screen.Parent = playerGui

local function make(className, props, parent)
    local object = Instance.new(className)
    for key, value in pairs(props) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function corner(parent, radius)
    make("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, parent)
end

local function stroke(parent, color, transparency)
    make("UIStroke", {
        Color = color or COLORS.accent,
        Transparency = transparency or 0.55,
        Thickness = 1,
    }, parent)
end

local main = make("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(560, 370),
    BackgroundColor3 = COLORS.background,
    BorderSizePixel = 0,
}, screen)
corner(main, 14)
stroke(main, COLORS.accent, 0.35)

local top = make("Frame", {
    Name = "Topbar",
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
}, main)
corner(top, 14)

make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(18, 0),
    Size = UDim2.new(1, -130, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "MATCHA  /  RIVALS CLIENT",
    TextColor3 = COLORS.text,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local minimize = make("TextButton", {
    Name = "Minimize",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -14, 0.5, 0),
    Size = UDim2.fromOffset(32, 30),
    BackgroundColor3 = COLORS.panel2,
    Text = "—",
    TextColor3 = COLORS.text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = true,
}, top)
corner(minimize, 8)

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(12, 64),
    Size = UDim2.new(0, 138, 1, -76),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
}, main)
corner(sidebar, 10)

local content = make("Frame", {
    Position = UDim2.fromOffset(162, 64),
    Size = UDim2.new(1, -174, 1, -76),
    BackgroundColor3 = COLORS.panel,
    BorderSizePixel = 0,
}, main)
corner(content, 10)

local pageTitle = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(16, 12),
    Size = UDim2.new(1, -32, 0, 28),
    Font = Enum.Font.GothamBold,
    Text = "Home",
    TextColor3 = COLORS.text,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
}, content)

local pageBody = make("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 50),
    Size = UDim2.new(1, -28, 1, -62),
}, content)

local function clearBody()
    for _, child in ipairs(pageBody:GetChildren()) do
        child:Destroy()
    end
end

local function sectionLabel(text, y)
    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(4, y),
        Size = UDim2.new(1, -8, 0, 24),
        Font = Enum.Font.GothamSemibold,
        Text = text,
        TextColor3 = COLORS.muted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, pageBody)
end

local function makeToggle(label, y, initial, callback)
    local row = make("Frame", {
        Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = COLORS.panel2,
        BorderSizePixel = 0,
    }, pageBody)
    corner(row, 8)

    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -76, 1, 0),
        Font = Enum.Font.Gotham,
        Text = label,
        TextColor3 = COLORS.text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local enabled = initial == true
    local button = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -9, 0.5, 0),
        Size = UDim2.fromOffset(48, 25),
        BackgroundColor3 = enabled and COLORS.accent or COLORS.background,
        Text = enabled and "ON" or "OFF",
        TextColor3 = COLORS.text,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = true,
    }, row)
    corner(button, 7)

    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.Text = enabled and "ON" or "OFF"
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = enabled and COLORS.accent or COLORS.background,
        }):Play()
        if callback then
            callback(enabled)
        end
    end)
end

local showStats = false
local statsLabel = make("TextLabel", {
    Name = "Stats",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -14, 0, 14),
    Size = UDim2.fromOffset(170, 28),
    BackgroundColor3 = COLORS.background,
    BackgroundTransparency = 0.15,
    Font = Enum.Font.GothamSemibold,
    Text = "FPS: --  |  Ping: --",
    TextColor3 = COLORS.good,
    TextSize = 12,
    Visible = false,
}, screen)
corner(statsLabel, 8)

local function showHome()
    pageTitle.Text = "Home"
    clearBody()
    sectionLabel("CLIENT STATUS", 0)
    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(4, 28),
        Size = UDim2.new(1, -8, 0, 48),
        Font = Enum.Font.Gotham,
        Text = "UI loaded successfully. Settings here only affect your own client.",
        TextColor3 = COLORS.text,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, pageBody)
    sectionLabel("QUICK INFO", 92)
    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(4, 118),
        Size = UDim2.new(1, -8, 0, 54),
        Font = Enum.Font.Gotham,
        Text = "RightShift: show / hide menu\nDrag the top bar to move the window.",
        TextColor3 = COLORS.muted,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, pageBody)
end

local function showVisuals()
    pageTitle.Text = "Visuals"
    clearBody()
    sectionLabel("CAMERA", 0)

    local fov = 70
    local function applyFov()
        local camera = workspace.CurrentCamera
        if camera then
            camera.FieldOfView = fov
        end
    end

    local valueLabel = make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(4, 28),
        Size = UDim2.new(1, -8, 0, 24),
        Font = Enum.Font.Gotham,
        Text = "Field of view: 70°",
        TextColor3 = COLORS.text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, pageBody)

    local lower = make("TextButton", {
        Position = UDim2.fromOffset(4, 60),
        Size = UDim2.fromOffset(58, 32),
        BackgroundColor3 = COLORS.panel2,
        Text = "−",
        TextColor3 = COLORS.text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
    }, pageBody)
    corner(lower, 7)

    local higher = make("TextButton", {
        Position = UDim2.fromOffset(72, 60),
        Size = UDim2.fromOffset(58, 32),
        BackgroundColor3 = COLORS.panel2,
        Text = "+",
        TextColor3 = COLORS.text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
    }, pageBody)
    corner(higher, 7)

    local reset = make("TextButton", {
        Position = UDim2.fromOffset(140, 60),
        Size = UDim2.fromOffset(82, 32),
        BackgroundColor3 = COLORS.panel2,
        Text = "Reset",
        TextColor3 = COLORS.text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
    }, pageBody)
    corner(reset, 7)

    local function setFov(nextValue)
        fov = math.clamp(nextValue, 50, 100)
        valueLabel.Text = "Field of view: " .. fov .. "°"
        applyFov()
    end

    lower.MouseButton1Click:Connect(function() setFov(fov - 5) end)
    higher.MouseButton1Click:Connect(function() setFov(fov + 5) end)
    reset.MouseButton1Click:Connect(function() setFov(70) end)

    sectionLabel("DISPLAY", 116)
    makeToggle("Show FPS / ping counter", 144, showStats, function(value)
        showStats = value
        statsLabel.Visible = value
    end)
end

local function showSettings()
    pageTitle.Text = "Settings"
    clearBody()
    sectionLabel("INTERFACE", 0)
    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(4, 28),
        Size = UDim2.new(1, -8, 0, 58),
        Font = Enum.Font.Gotham,
        Text = "Press RightShift to toggle the menu. The window can be dragged by its title bar.",
        TextColor3 = COLORS.text,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, pageBody)
    sectionLabel("ABOUT", 102)
    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(4, 130),
        Size = UDim2.new(1, -8, 0, 64),
        Font = Enum.Font.Gotham,
        Text = "Community UI starter. No executor APIs, game exploits, paid-item bypasses, or server modifications.",
        TextColor3 = COLORS.muted,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, pageBody)
end

local pages = {
    { name = "Home", callback = showHome },
    { name = "Visuals", callback = showVisuals },
    { name = "Settings", callback = showSettings },
}

for index, page in ipairs(pages) do
    local button = make("TextButton", {
        Position = UDim2.fromOffset(8, 10 + (index - 1) * 44),
        Size = UDim2.new(1, -16, 0, 36),
        BackgroundColor3 = index == 1 and COLORS.accent or COLORS.panel2,
        Text = page.name,
        TextColor3 = COLORS.text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        AutoButtonColor = true,
    }, sidebar)
    corner(button, 8)
    button.MouseButton1Click:Connect(function()
        for _, child in ipairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = COLORS.panel2
            end
        end
        button.BackgroundColor3 = COLORS.accent
        page.callback()
    end)
end

showHome()

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    sidebar.Visible = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(560, 52) or UDim2.fromOffset(560, 370)
    minimize.Text = minimized and "+" or "—"
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Dragging the title bar works with mouse and touch.
local dragging = false
local dragStart
local startPosition

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

top.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

local frames = 0
local elapsed = 0
RunService.RenderStepped:Connect(function(dt)
    frames += 1
    elapsed += dt
    if elapsed >= 1 then
        local fps = math.floor(frames / elapsed + 0.5)
        frames = 0
        elapsed = 0

        if showStats then
            local pingText = "--"
            local ok, result = pcall(function()
                return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            end)
            if ok and result then
                pingText = result
            end
            statsLabel.Text = string.format("FPS: %d  |  Ping: %s", fps, pingText)
        end
    end
end)

print("[RivalsClientUI] Loaded. Press RightShift to toggle.")
