-- ==============================================================================
-- PROJECT ZENITH V85: CORE ENGINE
-- ==============================================================================
if not getgenv().Zenith_Secure_Auth or getgenv().Zenith_Secure_Auth ~= "Z3N1TH_M4ST3R_C0D3_9982" then
    game:GetService("Players").LocalPlayer:Kick("\nProject Zenith\nUnauthorized Access Detected.\nPlease use the official loader in the Discord server.")
    return
end

getgenv().Zenith_Secure_Auth = nil 

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local Workspace = game:GetService('Workspace')

local LocalPlayer = Players.LocalPlayer

-- WARNING: Paste your raw GitHub URL for Skins_Database.lua here!
local skinDbUrl = "https://gist.githubusercontent.com/Clide01/4e7b2abdb007ab6714c5eae2a2c4c63a/raw/d652305078ac3bba0e6f71b7b5ac89bc43253219/Skins_Database.lua"
local SkinDB = loadstring(game:HttpGet(skinDbUrl))()

getgenv().VisualSpooferState = {
    PrimaryBase = "AWP", 
    PrimaryTarget = SkinDB.PrimarySkins[1],
    MeleeBase = "ClassKnife", 
    MeleeTarget = SkinDB.MeleeSkins[1],
    IsHooked = false
}

local Window = Rayfield:CreateWindow({
    Name = "Project Zenith | Visual Engine",
    LoadingTitle = "Initializing Zenith...",
    LoadingSubtitle = "Developed by Clide01",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false 
})

local Tab = Window:CreateTab("Skin Module")

Tab:CreateSection("Primary Configuration")
Tab:CreateDropdown({Name="Source Weapon",Options=SkinDB.PrimaryBases,CurrentOption={getgenv().VisualSpooferState.PrimaryBase},MultipleOptions=false,Callback=function(Options) getgenv().VisualSpooferState.PrimaryBase = Options[1] end})
local PrimaryDropdown 
Tab:CreateInput({Name="Filter Database",PlaceholderText="Search primary index...",Callback=function(Text)
       local filtered = {}
       for _, skin in ipairs(SkinDB.PrimarySkins) do if string.find(string.lower(skin), string.lower(Text)) then table.insert(filtered, skin) end end
       if #filtered == 0 then table.insert(filtered, "No Results") end
       if PrimaryDropdown then PrimaryDropdown:Refresh(filtered, true) end
end})
PrimaryDropdown = Tab:CreateDropdown({Name="Target Override",Options=SkinDB.PrimarySkins,CurrentOption={getgenv().VisualSpooferState.PrimaryTarget},MultipleOptions=false,Callback=function(Options) if Options[1] ~= "No Results" then getgenv().VisualSpooferState.PrimaryTarget = Options[1] end end})

Tab:CreateSection("Melee Configuration")
Tab:CreateDropdown({Name="Source Melee",Options=SkinDB.MeleeBases,CurrentOption={getgenv().VisualSpooferState.MeleeBase},MultipleOptions=false,Callback=function(Options) getgenv().VisualSpooferState.MeleeBase = Options[1] end})
local MeleeDropdown
Tab:CreateInput({Name="Filter Database",PlaceholderText="Search melee index...",Callback=function(Text)
       local filtered = {}
       for _, skin in ipairs(SkinDB.MeleeSkins) do if string.find(string.lower(skin), string.lower(Text)) then table.insert(filtered, skin) end end
       if #filtered == 0 then table.insert(filtered, "No Results") end
       if MeleeDropdown then MeleeDropdown:Refresh(filtered, true) end
end})
MeleeDropdown = Tab:CreateDropdown({Name="Target Override",Options=SkinDB.MeleeSkins,CurrentOption={getgenv().VisualSpooferState.MeleeTarget},MultipleOptions=false,Callback=function(Options) if Options[1] ~= "No Results" then getgenv().VisualSpooferState.MeleeTarget = Options[1] end end})

Tab:CreateSection("System Injection")

Tab:CreateButton({Name="Inject Core Hooks",Callback=function()
    if getgenv().VisualSpooferState.IsHooked then 
        Rayfield:Notify({Title="Zenith Error",Content="Hooks are already active. Reset your character to apply new configs.",Duration=4})
        return 
    end

    local oldNewIndex
    oldNewIndex = hookmetamethod(game, "__newindex", function(t, k, v)
        if not checkcaller() and k == "Image" and typeof(v) == "Instance" then v = "rbxassetid://0" end
        return oldNewIndex(t, k, v)
    end)

    local function DeepMaskTable(tbl, state)
        for k, v in pairs(tbl) do
            if type(v) == "string" then
                if v == state.PrimaryTarget then tbl[k] = state.PrimaryBase
                elseif v == state.MeleeTarget then tbl[k] = state.MeleeBase end
            elseif type(v) == "table" then DeepMaskTable(v, state) end
        end
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        
        if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
            local args = {...}
            local state = getgenv().VisualSpooferState
            if state and state.IsHooked then
                for i, v in ipairs(args) do
                    if type(v) == "string" then
                        if v == state.PrimaryTarget then args[i] = state.PrimaryBase
                        elseif v == state.MeleeTarget then args[i] = state.MeleeBase end
                    elseif type(v) == "table" then 
                        DeepMaskTable(args[i], state) 
                    end
                end
            end
            return oldNamecall(self, unpack(args))
        end
        return oldNamecall(self, ...)
    end)

    local weaponModule = ReplicatedStorage.Client['WeaponController']:WaitForChild('Weapon')
    local targets = {weaponModule, weaponModule:FindFirstChild('Gun'), weaponModule:FindFirstChild('Melee')}
    local hooksApplied = 0
    local targetMethods = {'SetSkin', '_loadModel', '_setupModel', 'LoadSkinedAssets', 'PlaySound', '_playSound'}
    
    for _, moduleInstance in ipairs(targets) do 
        if moduleInstance then 
            local success, ClassTable = pcall(require, moduleInstance)
            if success and type(ClassTable) == "table" then 
                for _, methodName in ipairs(targetMethods) do 
                    if type(ClassTable[methodName]) == "function" and not ClassTable["_H"..methodName] then 
                        ClassTable["_H"..methodName] = true
                        local originalMethod = ClassTable[methodName]
                        
                        ClassTable[methodName] = function(self, arg1, ...) 
                            local isLocalPlayerWeapon = false
                            
                            if self.IsLocal == true or self.isLocal == true or self.IsFirstPerson == true then 
                                isLocalPlayerWeapon = true 
                            end

                            local weaponModel = self.Model or self.model or self.Instance or self.WeaponModel
                            if typeof(weaponModel) == "Instance" then
                                if weaponModel:IsDescendantOf(Workspace.CurrentCamera) then 
                                    isLocalPlayerWeapon = true 
                                end
                                if LocalPlayer.Character and weaponModel:IsDescendantOf(LocalPlayer.Character) then
                                    isLocalPlayerWeapon = true
                                end
                            end

                            for _, arg in pairs({arg1, ...}) do 
                                if type(arg) == "string" then
                                    if string.find(arg, "FirstPerson") then isLocalPlayerWeapon = true end
                                    if string.find(arg, "ThirdPerson") or string.find(arg, "Carry") then isLocalPlayerWeapon = false end
                                end
                            end

                            if not isLocalPlayerWeapon then
                                return originalMethod(self, arg1, ...)
                            end
                            
                            local state = getgenv().VisualSpooferState
                            local spoofedArg = arg1

                            if type(arg1) == "string" then 
                                if string.find(arg1, state.PrimaryBase) then spoofedArg = state.PrimaryTarget 
                                elseif string.find(arg1, state.MeleeBase) then spoofedArg = state.MeleeTarget end 
                            end
                            
                            if self.Name then 
                                if string.find(self.Name, state.PrimaryBase) or self.Name == state.PrimaryTarget then 
                                    self.Skin = state.PrimaryTarget; self.Name = state.PrimaryTarget 
                                    if self.WeaponName then self.WeaponName = state.PrimaryTarget end
                                elseif string.find(self.Name, state.MeleeBase) or self.Name == state.MeleeTarget then 
                                    self.Skin = state.MeleeTarget; self.Name = state.MeleeTarget 
                                    if self.WeaponName then self.WeaponName = state.MeleeTarget end
                                end 
                            end
                            
                            return originalMethod(self, spoofedArg, ...)
                        end
                        hooksApplied = hooksApplied + 1 
                    end 
                end 
            end 
        end 
    end
    
    if hooksApplied > 0 then 
        getgenv().VisualSpooferState.IsHooked = true
        Rayfield:Notify({Title="Zenith Engine Active",Content="VFX, Textures, and Audio modules successfully hooked.",Duration=6}) 
    else 
        Rayfield:Notify({Title="Injection Failed",Content="Could not bypass environment security.",Duration=5}) 
    end 
end})

Rayfield:Init()
