-- ==============================================================================
-- PROJECT ZENITH: FRONTEND UI MODULE
-- ==============================================================================
return function(GatewayCore)
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZenithLauncherGateway"
    ScreenGui.Parent = (CoreGui:FindFirstChild("RobloxGui") and CoreGui) or Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local UI_THEME = {
        Bg = Color3.fromRGB(13, 16, 23),
        Panel = Color3.fromRGB(23, 27, 37),
        Input = Color3.fromRGB(36, 42, 54),
        Border = Color3.fromRGB(48, 56, 74),
        AccentBlue = Color3.fromRGB(74, 140, 255),
        AccentBlueHover = Color3.fromRGB(107, 165, 255),
        Green = Color3.fromRGB(54, 214, 122),
        Red = Color3.fromRGB(255, 93, 93),
        Text = Color3.fromRGB(255, 255, 255),
        TextSec = Color3.fromRGB(140, 145, 160)
    }

    local function CreateCorner(parent, radius)
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(0, radius)
        uic.Parent = parent
        return uic
    end

    local function CreateStroke(parent, color, thickness, trans)
        local uis = Instance.new("UIStroke")
        uis.Color = color
        uis.Thickness = thickness
        uis.Transparency = trans or 0
        uis.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uis.Parent = parent
        return uis
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 430, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -215, 0.5, -125)
    MainFrame.BackgroundColor3 = UI_THEME.Bg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    CreateCorner(MainFrame, 12)
    CreateStroke(MainFrame, UI_THEME.Border, 1.5)

    -- Sleek Premium Border Glow
    local glow = Instance.new("UIStroke")
    glow.Color = UI_THEME.AccentBlue
    glow.Thickness = 1.2
    glow.Transparency = 0.85
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 0, 25)
    TitleLabel.Position = UDim2.new(0, 20, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "PROJECT ZENITH"
    TitleLabel.TextColor3 = UI_THEME.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = TitleBar

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 250, 0, 15)
    SubtitleLabel.Position = UDim2.new(0, 20, 0, 28)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = "Hardware-Locked Security Gateway"
    SubtitleLabel.TextColor3 = UI_THEME.TextSec
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.TextSize = 10
    SubtitleLabel.Font = Enum.Font.GothamMedium
    SubtitleLabel.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -45, 0, 10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = UI_THEME.TextSec
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamMedium
    CloseBtn.Parent = TitleBar

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -40, 0, 42)
    KeyBox.Position = UDim2.new(0, 20, 0, 65)
    KeyBox.BackgroundColor3 = UI_THEME.Input
    KeyBox.TextColor3 = UI_THEME.Text
    KeyBox.PlaceholderText = "Paste your randomized token here..."
    KeyBox.PlaceholderColor3 = UI_THEME.TextSec
    KeyBox.Text = ""
    KeyBox.TextSize = 12
    KeyBox.Font = Enum.Font.GothamMedium
    KeyBox.Parent = MainFrame

    CreateCorner(KeyBox, 8)
    local KeyStroke = CreateStroke(KeyBox, UI_THEME.Border, 1)

    KeyBox.Focused:Connect(function()
        TweenService:Create(KeyStroke, TweenInfo.new(0.2), {Color = UI_THEME.AccentBlue, Thickness = 1.5}):Play()
    end)
    KeyBox.FocusLost:Connect(function()
        TweenService:Create(KeyStroke, TweenInfo.new(0.2), {Color = UI_THEME.Border, Thickness = 1}):Play()
    end)

    local ActionFrame = Instance.new("Frame")
    ActionFrame.Size = UDim2.new(1, -40, 0, 45)
    ActionFrame.Position = UDim2.new(0, 20, 0, 125)
    ActionFrame.BackgroundTransparency = 1
    ActionFrame.Parent = MainFrame

    local GenerateBtn = Instance.new("TextButton")
    GenerateBtn.Size = UDim2.new(0.48, 0, 1, 0)
    GenerateBtn.Position = UDim2.new(0, 0, 0, 0)
    GenerateBtn.BackgroundColor3 = UI_THEME.Panel
    GenerateBtn.Text = "Get Token (Link Copy)"
    GenerateBtn.TextColor3 = UI_THEME.Text
    GenerateBtn.TextSize = 12
    GenerateBtn.Font = Enum.Font.GothamBold
    GenerateBtn.Parent = ActionFrame

    CreateCorner(GenerateBtn, 8)
    CreateStroke(GenerateBtn, UI_THEME.Border, 1)

    GenerateBtn.MouseButton1Click:Connect(function()
        GatewayCore.CopyLink()
    end)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.48, 0, 1, 0)
    VerifyBtn.Position = UDim2.new(0.52, 0, 0, 0)
    VerifyBtn.BackgroundColor3 = UI_THEME.AccentBlue
    VerifyBtn.Text = "Verify Hardware Key"
    VerifyBtn.TextColor3 = UI_THEME.Text
    VerifyBtn.TextSize = 13
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.Parent = ActionFrame

    CreateCorner(VerifyBtn, 8)

    local StatusPanel = Instance.new("Frame")
    StatusPanel.Size = UDim2.new(1, -40, 0, 25)
    StatusPanel.Position = UDim2.new(0, 20, 0, 190)
    StatusPanel.BackgroundColor3 = UI_THEME.Panel
    StatusPanel.Parent = MainFrame

    CreateCorner(StatusPanel, 6)
    CreateStroke(StatusPanel, UI_THEME.Border, 1)

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(0, 12, 0.5, -4)
    StatusDot.BackgroundColor3 = UI_THEME.TextSec
    StatusDot.Parent = StatusPanel

    CreateCorner(StatusDot, 4)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -35, 1, 0)
    StatusLabel.Position = UDim2.new(0, 28, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "System Idle"
    StatusLabel.TextColor3 = UI_THEME.TextSec
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Parent = StatusPanel

    GatewayCore.BindMessageHandler(function(message)
        if not StatusLabel then return end
        StatusLabel.Text = message
        
        local dColor = UI_THEME.TextSec
        local lowerMsg = string.lower(message)
        
        if string.find(lowerMsg, "success") or string.find(lowerMsg, "granted") or string.find(lowerMsg, "copied") then
            dColor = UI_THEME.Green
        elseif string.find(lowerMsg, "failed") or string.find(lowerMsg, "invalid") or string.find(lowerMsg, "error") then
            dColor = UI_THEME.Red
        elseif string.find(lowerMsg, "generating") or string.find(lowerMsg, "authenticating") then
            dColor = UI_THEME.AccentBlue
        end

        TweenService:Create(StatusDot, TweenInfo.new(0.2), {BackgroundColor3 = dColor}):Play()
        TweenService:Create(StatusLabel, TweenInfo.new(0.2), {TextColor3 = dColor}):Play()
    end)

    VerifyBtn.MouseButton1Click:Connect(function()
        local userKey = string.gsub(KeyBox.Text, "^%s*(.-)%s*$", "%1")
        if userKey == "" then
            GatewayCore.PushMessage("Enter your randomized token first!")
            return
        end
        
        local success = GatewayCore.VerifyKey(userKey)

        if success then
            GatewayCore.PushMessage("Access granted. Initializing engine...")
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundColor3 = UI_THEME.Green}):Play()
            task.wait(0.5)
            ScreenGui:Destroy()
            GatewayCore.CompleteAuthentication()
        else
            GatewayCore.PushMessage("Access denied. Token is invalid or for another device.")
        end
    end)
end
