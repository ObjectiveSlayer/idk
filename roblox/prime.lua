local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local TOGGLE_KEY = Enum.KeyCode.RightControl
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local originalWalkSpeed = 16
local teamDetectionEnabled = false

local function isTeammate(targetPlayer)
    if teamDetectionEnabled and LocalPlayer.Team and targetPlayer.Team then
        return LocalPlayer.Team == targetPlayer.Team
    end
    return false
end

local function getDistance(pointA, pointB)
    return (pointA - pointB).Magnitude
end

local function getClosestEnemyToCrosshair()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, targetPlayer in ipairs(game.Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") and not isTeammate(targetPlayer) then
            local head = targetPlayer.Character.Head
            local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)

            if onScreen then
                local distance = getDistance(Vector2.new(vector.X, vector.Y), Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2))
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = targetPlayer
                end
            end
        end
    end

    return closestPlayer
end

local function aimAt(targetPlayer)
    if targetPlayer and targetPlayer.Character and not isTeammate(targetPlayer) then
        local head = targetPlayer.Character:FindFirstChild("Head")
        if head then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, head.Position)
        end
    end
end



local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancementGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
local guiVisible = true 


local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(1, -260, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 1
MainFrame.Parent = ScreenGui


local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame


local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar


local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Diddy Central"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = TopBar


local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -40)
ContentFrame.Position = UDim2.new(0, 10, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = MainFrame


local function createSection(name, hasCollapsible)
    local section = Instance.new("Frame")
    section.Name = name .. "Section"
    section.Size = UDim2.new(1, 0, 0, 40)
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    section.BorderSizePixel = 0
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.5, 0, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = section
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 24)
    toggle.Position = UDim2.new(1, -60, 0, 8)
    toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = section
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggle
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(0, 2, 0, 2)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.Parent = toggle
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    if hasCollapsible then
        
        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0, 16, 0, 16)
        arrow.Position = UDim2.new(1, -85, 0, 12)
        arrow.BackgroundTransparency = 1
        arrow.Image = "rbxassetid://6031091004"
        arrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
        arrow.Rotation = 0
        arrow.Parent = section
        
        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Size = UDim2.new(1, -20, 0, 100)
        content.Position = UDim2.new(0, 10, 0, 45)
        content.BackgroundTransparency = 1
        content.ClipsDescendants = true
        content.Visible = false
        content.Parent = section
        
        local clickDetector = Instance.new("TextButton")
        clickDetector.Size = UDim2.new(1, -70, 0, 40)
        clickDetector.Position = UDim2.new(0, 0, 0, 0)
        clickDetector.BackgroundTransparency = 1
        clickDetector.Text = ""
        clickDetector.Parent = section
        
        return section, toggle, indicator, content, clickDetector, arrow
    end
    
    return section, toggle, indicator
end


local yOffset = 0
local spacing = 10





local aimbotSection, aimbotToggle, aimbotIndicator, aimbotContent, aimbotClickDetector, aimbotArrow = createSection("Aimbot", true)
aimbotSection.Position = UDim2.new(0, 0, 0, yOffset)
aimbotSection.Parent = ContentFrame

local keybindButton = Instance.new("TextButton")
keybindButton.Size = UDim2.new(1, 0, 0, 30)
keybindButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
keybindButton.Text = "Aimbot Key: V"
keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindButton.Font = Enum.Font.Gotham
keybindButton.TextSize = 12
keybindButton.Parent = aimbotContent

local keybindCorner = Instance.new("UICorner")
keybindCorner.CornerRadius = UDim.new(0, 6)
keybindCorner.Parent = keybindButton

local waitingForBind = false
local currentAimbotKey = Enum.KeyCode.V 

keybindButton.MouseButton1Click:Connect(function()
    waitingForBind = true
    keybindButton.Text = "Press any key..."
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard or 
           input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.MouseButton2 or 
           input.UserInputType == Enum.UserInputType.MouseButton3 then
            
            currentAimbotKey = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
            local keyName = input.UserInputType.Name:match("MouseButton%d") and input.UserInputType.Name or input.KeyCode.Name
            keybindButton.Text = "Aimbot Key: " .. keyName
            waitingForBind = false
            connection:Disconnect()
        end
    end)
end)

yOffset = yOffset + 40 + spacing






local espSection, espToggle, espIndicator, espContent, espClickDetector, espArrow = createSection("ESP", true)
espSection.Position = UDim2.new(0, 0, 0, yOffset)
espSection.Parent = ContentFrame


local espTypeDropdown = Instance.new("TextButton")
espTypeDropdown.Size = UDim2.new(1, 0, 0, 30)
espTypeDropdown.Position = UDim2.new(0, 0, 0, 0)
espTypeDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
espTypeDropdown.Text = "ESP Type: Boxes"
espTypeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
espTypeDropdown.Font = Enum.Font.Gotham
espTypeDropdown.TextSize = 12
espTypeDropdown.Parent = espContent

local espTypeCorner = Instance.new("UICorner")
espTypeCorner.CornerRadius = UDim.new(0, 6)
espTypeCorner.Parent = espTypeDropdown


local teammateDetectionButton = Instance.new("TextButton")
teammateDetectionButton.Size = UDim2.new(1, 0, 0, 30)
teammateDetectionButton.Position = UDim2.new(0, 0, 0, 35)  
teammateDetectionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
teammateDetectionButton.Text = "Teammate Detection: OFF"
teammateDetectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teammateDetectionButton.Font = Enum.Font.Gotham
teammateDetectionButton.TextSize = 12
teammateDetectionButton.Parent = espContent

local teammateDetectionCorner = Instance.new("UICorner")
teammateDetectionCorner.CornerRadius = UDim.new(0, 6)
teammateDetectionCorner.Parent = teammateDetectionButton


espContent.Size = UDim2.new(1, -20, 0, 65)  

teammateDetectionButton.MouseButton1Click:Connect(function()
    teamDetectionEnabled = not teamDetectionEnabled
    teammateDetectionButton.Text = "Teammate Detection: " .. (teamDetectionEnabled and "ON" or "OFF")
    
    if espEnabled then
        cleanupAllESP()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer then
                if espType == "boxes" then
                    createBoxESP(p)
                else
                    createHighlightESP(p)
                end
            end
        end
    end
end)

yOffset = yOffset + 40 + spacing  



local speedSection, speedToggle, speedIndicator, speedContent, speedClickDetector, speedArrow = createSection("Speed", true)
speedSection.Position = UDim2.new(0, 0, 0, yOffset)
speedSection.Parent = ContentFrame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(1, 0, 0, 30)
speedSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedSlider.Parent = speedContent

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(0, 6)
speedSliderCorner.Parent = speedSlider

local speedSliderBar = Instance.new("Frame")
speedSliderBar.Size = UDim2.new(0.1, 0, 1, 0)
speedSliderBar.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
speedSliderBar.Parent = speedSlider

local speedSliderBarCorner = Instance.new("UICorner")
speedSliderBarCorner.CornerRadius = UDim.new(0, 6)
speedSliderBarCorner.Parent = speedSliderBar

local speedValue = Instance.new("TextLabel")
speedValue.Size = UDim2.new(1, 0, 1, 0)
speedValue.BackgroundTransparency = 1
speedValue.Text = "Speed: 2x"
speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValue.Font = Enum.Font.Gotham
speedValue.TextSize = 12
speedValue.Parent = speedSlider

yOffset = yOffset + 40 + spacing  



local noclipSection, noclipToggle, noclipIndicator = createSection("Noclip", false)
noclipSection.Position = UDim2.new(0, 0, 0, yOffset)
noclipSection.Parent = ContentFrame

yOffset = yOffset + 40 + spacing


local flightSection, flightToggle, flightIndicator, flightContent, flightClickDetector, flightArrow = createSection("Flight", true)
flightSection.Position = UDim2.new(0, 0, 0, yOffset)
flightSection.Parent = ContentFrame

local flightSlider = Instance.new("Frame")
flightSlider.Size = UDim2.new(1, 0, 0, 30)
flightSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
flightSlider.Parent = flightContent

local flightSliderCorner = Instance.new("UICorner")
flightSliderCorner.CornerRadius = UDim.new(0, 6)
flightSliderCorner.Parent = flightSlider

local flightSliderBar = Instance.new("Frame")
flightSliderBar.Size = UDim2.new(0.1, 0, 1, 0)
flightSliderBar.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
flightSliderBar.Parent = flightSlider

local flightSliderBarCorner = Instance.new("UICorner")
flightSliderBarCorner.CornerRadius = UDim.new(0, 6)
flightSliderBarCorner.Parent = flightSliderBar

local flightValue = Instance.new("TextLabel")
flightValue.Size = UDim2.new(1, 0, 1, 0)
flightValue.BackgroundTransparency = 1
flightValue.Text = "Speed: 15"
flightValue.TextColor3 = Color3.fromRGB(255, 255, 255)
flightValue.Font = Enum.Font.Gotham
flightValue.TextSize = 12
flightValue.Parent = flightSlider

yOffset = yOffset + 40 + spacing


local originalMenu = {
    sections = {},
    isInPlayersView = false
}



local playersSection = Instance.new("Frame")
playersSection.Size = UDim2.new(1, 0, 0, 40)  
playersSection.Position = UDim2.new(0, 0, 0, yOffset) 
playersSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playersSection.Parent = ContentFrame

local playersCorner = Instance.new("UICorner")
playersCorner.CornerRadius = UDim.new(0, 6)
playersCorner.Parent = playersSection

local playersButton = Instance.new("TextButton")
playersButton.Size = UDim2.new(1, 0, 1, 0)
playersButton.BackgroundTransparency = 1
playersButton.Text = "Players"
playersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playersButton.TextSize = 12
playersButton.Font = Enum.Font.Gotham
playersButton.TextXAlignment = Enum.TextXAlignment.Left
playersButton.Parent = playersSection

local playersPadding = Instance.new("UIPadding")
playersPadding.PaddingLeft = UDim.new(0, 10)
playersPadding.Parent = playersButton

local playersArrow = Instance.new("ImageLabel")
playersArrow.Size = UDim2.new(0, 20, 0, 20)
playersArrow.Position = UDim2.new(1, -25, 0.5, -10)
playersArrow.BackgroundTransparency = 1
playersArrow.Image = "rbxassetid://6034818372"
playersArrow.Rotation = 270  
playersArrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
playersArrow.Parent = playersSection



local function showPlayersPage()
    if originalMenu.isInPlayersView then return end
    originalMenu.isInPlayersView = true
    
    
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            table.insert(originalMenu.sections, child)
            child.Visible = false
        end
    end
    
    
    local backArrow = Instance.new("ImageButton")
    backArrow.Size = UDim2.new(0, 25, 0, 25)
    backArrow.Position = UDim2.new(-0.03, 0, 0, -3)
    backArrow.BackgroundTransparency = 1
    backArrow.Image = "rbxassetid://6034818372"
    backArrow.Rotation = 90  
    backArrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
    backArrow.Parent = ContentFrame
    
    
    backArrow.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(backArrow, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
    end)
    
    backArrow.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(backArrow, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    
    local buttonOffset = 30  
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            local buttonFrame = Instance.new("Frame")
            buttonFrame.Name = "PlayerButton"
            buttonFrame.Size = UDim2.new(1, -20, 0, 35)
            buttonFrame.Position = UDim2.new(0, 10, 0, buttonOffset)
            buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            buttonFrame.Parent = ContentFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = buttonFrame

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.Position = UDim2.new(0, 0, 0, 0)
            button.BackgroundTransparency = 1
            button.Text = p.Name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.GothamBold
            button.TextXAlignment = Enum.TextXAlignment.Left
            button.Parent = buttonFrame
            
            local buttonPadding = Instance.new("UIPadding")
            buttonPadding.PaddingLeft = UDim.new(0, 10)
            buttonPadding.Parent = button
            
            button.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(buttonFrame, TweenInfo.new(0.5), {
                    BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                }):Play()
            end)
            
            button.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(buttonFrame, TweenInfo.new(0.5), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                }):Play()
            end)

            button.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetCFrame = p.Character.HumanoidRootPart.CFrame
                    local offset = targetCFrame.LookVector * -5
                    local player = game.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if noclipEnabled then
                            noclipEnabled = false
                            toggleButton(noclipToggle, noclipIndicator, false)
                            if noclipConnection then
                                noclipConnection:Disconnect()
                                noclipConnection = nil
                            end
                        end
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetCFrame.Position + offset)
                    end
                end
            end)

            buttonOffset = buttonOffset + 40  
        end
    end
    
    
    backArrow.MouseButton1Click:Connect(function()
        
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if (child:IsA("Frame") and child.Name == "PlayerButton") or child:IsA("ImageButton") then
                child:Destroy()
            end
        end
        
        
        for _, section in ipairs(originalMenu.sections) do
            section.Visible = true
        end
        
        
        table.clear(originalMenu.sections)
        originalMenu.isInPlayersView = false
    end)
end

playersButton.MouseButton1Click:Connect(showPlayersPage)


Players.PlayerAdded:Connect(function()
    if originalMenu.isInPlayersView then
        showPlayersPage()
    end
end)

Players.PlayerRemoving:Connect(function()
    if originalMenu.isInPlayersView then
        showPlayersPage()
    end
end)

yOffset = yOffset + 40 + spacing


local aiming = false
local target = nil
local aimbotEnabled = false
local speedBoosted = false
local flying = false
local espEnabled = false
local espType = "boxes"
local speedMultiplier = 2
local flightSpeed = 15
local noclipEnabled = false
local noclipConnection = nil


local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)


local function toggleButton(button, indicator, enabled)
    local goalPosition = enabled and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
    local goalColor = enabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
    
    local positionTween = TweenService:Create(indicator, 
        TweenInfo.new(0.2, Enum.EasingStyle.Quad), 
        {Position = goalPosition}
    )
    positionTween:Play()
    
    local colorTween = TweenService:Create(indicator,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {BackgroundColor3 = goalColor}
    )
    colorTween:Play()
end


local function toggleSection(section, content, arrow)
    content.Visible = not content.Visible
    
    local goalRotation = content.Visible and 180 or 0
    local arrowTween = TweenService:Create(arrow,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {Rotation = goalRotation}
    )
    arrowTween:Play()
    
    
    local contentHeight = 0
    if content.Visible then
        for _, child in ipairs(content:GetChildren()) do
            contentHeight = contentHeight + child.Size.Y.Offset + 5  
        end
        contentHeight = contentHeight + 10  
    end
    
    local goalSize = content.Visible and UDim2.new(1, 0, 0, 40 + contentHeight) or UDim2.new(1, 0, 0, 40)
    local sizeTween = TweenService:Create(section,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad),
        {Size = goalSize}
    )
    sizeTween:Play()
    
    
    local currentY = section.Position.Y.Offset + (content.Visible and (40 + contentHeight) or 40) + spacing
    local found = false
    
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child == section then
            found = true
        elseif found and child:IsA("Frame") then
            local positionTween = TweenService:Create(child,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad),
                {Position = UDim2.new(0, 0, 0, currentY)}
            )
            positionTween:Play()
            currentY = currentY + child.Size.Y.Offset + spacing
        end
    end
end





local espObjects = {}


local function createBoxESP(targetPlayer)
    if espObjects[targetPlayer] then
        return
    end

    local highlightBox = Drawing.new("Square")
    highlightBox.Visible = false
    highlightBox.Thickness = 2
    highlightBox.Filled = false
    highlightBox.Color = Color3.fromRGB(255, 0, 0)

    local playerName = Drawing.new("Text")
    playerName.Visible = false
    playerName.Size = 16
    playerName.Color = Color3.fromRGB(255, 255, 255)
    playerName.Center = true
    playerName.Outline = true
    playerName.OutlineColor = Color3.fromRGB(0, 0, 0)

    espObjects[targetPlayer] = {
        box = highlightBox,
        name = playerName,
    }

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not targetPlayer or not targetPlayer.Parent then
            highlightBox.Visible = false
            playerName.Visible = false
            espObjects[targetPlayer] = nil
            connection:Disconnect()
            return
        end

        if not isTeammate(targetPlayer) then
            local character = targetPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local head = character and character:FindFirstChild("Head")

            if humanoidRootPart and head then
                local torsoPos = workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)

                if torsoPos.Z > 0 then
                    local boxHeight = math.abs(headPos.Y - torsoPos.Y) * 2.5
                    local boxWidth = boxHeight * 0.7

                    highlightBox.Size = Vector2.new(boxWidth, boxHeight)
                    highlightBox.Position = Vector2.new(torsoPos.X - boxWidth / 2, torsoPos.Y - boxHeight / 2)
                    highlightBox.Visible = true

                    playerName.Position = Vector2.new(torsoPos.X, torsoPos.Y - boxHeight / 2 - 20)
                    playerName.Text = targetPlayer.Name
                    playerName.Visible = true
                else
                    highlightBox.Visible = false
                    playerName.Visible = false
                end
            else
                highlightBox.Visible = false
                playerName.Visible = false
            end
        else
            highlightBox.Visible = false
            playerName.Visible = false
        end
    end)
end


local function createHighlightESP(targetPlayer)
    return
end


local function cleanupESPForPlayer(player)
    if espObjects[player] then
        for _, object in pairs(espObjects[player]) do
            if typeof(object) == "Instance" then
                object:Destroy()
            elseif typeof(object) == "table" and object.Remove then
                object:Remove()
            end
        end
        espObjects[player] = nil
    end
end

local function cleanupESP(character)
    if character then
        
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Highlight") or child.Name == "ESP_Name" then
                child:Destroy()
            end
        end
    end
end

local function cleanupAllESP()
    for player, _ in pairs(espObjects) do
        cleanupESPForPlayer(player)
    end
    espObjects = {}
end



local function updateESPForAllPlayers()
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            
            if targetPlayer.Character then
                cleanupESP(targetPlayer.Character)
            end
            
            if espEnabled then
                createBoxESP(targetPlayer)
                createHighlightESP(targetPlayer)
            end
        end
    end
end


local function onNoclipStep()
    local character = player.Character
    if character and noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end


local function toggleNoclip(enabled)
    noclipEnabled = enabled
    toggleButton(noclipToggle, noclipIndicator, enabled)
    
    if enabled then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(onNoclipStep)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

noclipToggle.MouseButton1Click:Connect(function()
    toggleNoclip(not noclipEnabled)
end)

aimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    toggleButton(aimbotToggle, aimbotIndicator, aimbotEnabled)
end)


espToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    toggleButton(espToggle, espIndicator, espEnabled)
    
    if not espEnabled then
        cleanupAllESP()
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                if espType == "boxes" then
                    createBoxESP(player)
                else
                    createHighlightESP(player)
                end
            end
        end
    end
end)




espTypeDropdown.MouseButton1Click:Connect(function()
    espType = espType == "boxes" and "highlight" or "boxes"
    espTypeDropdown.Text = "ESP Type: " .. (espType:gsub("^%l", string.upper))
    
    cleanupAllESP()
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                if espType == "boxes" then
                    createBoxESP(player)
                else
                    createHighlightESP(player)
                end
            end
        end
    end
end)

aimbotClickDetector.MouseButton1Click:Connect(function()
    toggleSection(aimbotSection, aimbotContent, aimbotArrow)
end)
espClickDetector.MouseButton1Click:Connect(function()
    toggleSection(espSection, espContent, espArrow)
end)

speedClickDetector.MouseButton1Click:Connect(function()
    toggleSection(speedSection, speedContent, speedArrow)
end)

flightClickDetector.MouseButton1Click:Connect(function()
    toggleSection(flightSection, flightContent, flightArrow)
end)

speedToggle.MouseButton1Click:Connect(function()
    speedBoosted = not speedBoosted
    toggleButton(speedToggle, speedIndicator, speedBoosted)
    
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if speedBoosted then
            humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        else
            humanoid.WalkSpeed = originalWalkSpeed
        end
    end
end)


local function updateSpeedMultiplier(percentage)
    speedMultiplier = 1 + (percentage * 49)
    speedValue.Text = string.format("Speed: %.0f", speedMultiplier)
    speedSliderBar.Size = UDim2.new(percentage, 0, 1, 0)
    
    if speedBoosted then
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
        end
    end
end
updateSpeedMultiplier(0.1)


speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                connection:Disconnect()
                return
            end
            
            local percentage = math.clamp((mouse.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
            speedSliderBar.Size = UDim2.new(percentage, 0, 1, 0)
            updateSpeedMultiplier(percentage)
        end)
    end
end)


flightToggle.MouseButton1Click:Connect(function()
    flying = not flying
    toggleButton(flightToggle, flightIndicator, flying)
    
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = flying
        workspace.Gravity = flying and 0 or 196.2
    end
end)


local function updateFlightSpeed(percentage)
    flightSpeed = 1 + (percentage * 299)
    flightValue.Text = string.format("Speed: %.0f", flightSpeed)
    flightSliderBar.Size = UDim2.new(percentage, 0, 1, 0)
end

flightSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                connection:Disconnect()
                return
            end
            
            local percentage = math.clamp((mouse.X - flightSlider.AbsolutePosition.X) / flightSlider.AbsoluteSize.X, 0, 1)
            flightSliderBar.Size = UDim2.new(percentage, 0, 1, 0)
            updateFlightSpeed(percentage)
        end)
    end
end)

updateFlightSpeed(0.1)
Players.PlayerAdded:Connect(function(targetPlayer)
    if targetPlayer ~= player then
        createBoxESP(targetPlayer)
        createHighlightESP(targetPlayer)
    end
end)
Players.PlayerRemoving:Connect(function(player)
    cleanupESPForPlayer(player)
end)




local function cleanupScript()
    if aimbotEnabled then
        aimbotEnabled = false
        toggleButton(aimbotToggle, aimbotIndicator, false)
    end
    
    if espEnabled then
        espEnabled = false
        toggleButton(espToggle, espIndicator, false)
        cleanupAllESP()
    end
    
    if speedBoosted then
        speedBoosted = false
        toggleButton(speedToggle, speedIndicator, false)
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = originalWalkSpeed
        end
    end
    
    if flying then
        flying = false
        toggleButton(flightToggle, flightIndicator, false)
        workspace.Gravity = 196.2
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    if noclipEnabled then
        noclipEnabled = false
        toggleButton(noclipToggle, noclipIndicator, false)
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
    
    
    if originalMenu.isInPlayersView then
        showPlayersPage()
    end
    
    for _, child in ipairs(playerListContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    if ScreenGui then
        ScreenGui:Destroy()
    end
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TOGGLE_KEY then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
    if not gameProcessed and input.KeyCode == Enum.KeyCode.End then
        cleanupScript()
    end
end)

Players.PlayerRemoving:Connect(function(targetPlayer)
    if espEnabled then
        updateESPForAllPlayers()
    end
end)




player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    originalWalkSpeed = humanoid.WalkSpeed
    if espEnabled then
        updateESPForAllPlayers()
    end

    if speedBoosted then
        humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
    end

    if flying then
        workspace.Gravity = 0
        humanoid.PlatformStand = true
    end
    if noclipEnabled then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(onNoclipStep)
    end
end)



RunService.RenderStepped:Connect(function()
    
    local isKeyPressed = typeof(currentAimbotKey) == "EnumItem" and
        (currentAimbotKey.EnumType == Enum.KeyCode and UserInputService:IsKeyDown(currentAimbotKey) or
         currentAimbotKey.EnumType == Enum.UserInputType and UserInputService:IsMouseButtonPressed(currentAimbotKey))
    
    if isKeyPressed and aiming and aimbotEnabled then
        target = getClosestEnemyToCrosshair()
        if target then
            aimAt(target)
        end
    else
        target = nil
    end

    
    if flying then
        local character = player.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        humanoidRootPart.Velocity = moveDirection * flightSpeed * 4  
    end
end)




UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if (typeof(currentAimbotKey) == "EnumItem" and 
        ((currentAimbotKey.EnumType == Enum.KeyCode and input.KeyCode == currentAimbotKey) or
         (currentAimbotKey.EnumType == Enum.UserInputType and input.UserInputType == currentAimbotKey))) then
        aiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if (typeof(currentAimbotKey) == "EnumItem" and 
        ((currentAimbotKey.EnumType == Enum.KeyCode and input.KeyCode == currentAimbotKey) or
         (currentAimbotKey.EnumType == Enum.UserInputType and input.UserInputType == currentAimbotKey))) then
        aiming = false
        target = nil
    end
end)


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == TOGGLE_KEY then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        flying = not flying
        toggleButton(flightToggle, flightIndicator, flying)
        
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = flying
            workspace.Gravity = flying and 0 or 196.2
        end
    end
    
    if input.KeyCode == Enum.KeyCode.F then
        speedBoosted = not speedBoosted
        toggleButton(speedToggle, speedIndicator, speedBoosted)
        
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            if speedBoosted then
                humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
            else
                humanoid.WalkSpeed = originalWalkSpeed
            end
        end
    end

    if input.KeyCode == Enum.KeyCode.N then
        noclipEnabled = not noclipEnabled
        toggleButton(noclipToggle, noclipIndicator, noclipEnabled)
        toggleNoclip(noclipEnabled)
    end
    
    if input.KeyCode == Enum.KeyCode.J then
        espEnabled = not espEnabled
        toggleButton(espToggle, espIndicator, espEnabled)
        
        if not espEnabled then
            cleanupAllESP()
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    if espType == "boxes" then
                        createBoxESP(player)
                    else
                        createHighlightESP(player)
                    end
                end
            end
        end
    end
end)






updateESPForAllPlayers()
