-- Roblox Game Decompiler by xdMatthewbx#1337
--	Copyright xdMatthewbx#1337 (Discord ID: 348696829648437249) 2020

--	For those of you who dont know what GPLv3 is:
--	I claim no responsibility for anything you or anyone else does with this script.
--	This script should be considered "use at your own risk".
--	Sharing this script without including the below license, attempting to sell this 
--		script, and/or calling it your own are/is illegal, and is punishable by law.

--	This program is free software: you can redistribute it and/or modify
--	it under the terms of the GNU General Public License as published by
--	the Free Software Foundation, either version 3 of the License, or
--	(at your option) any later version.

--	This program is distributed in the hope that it will be useful,
--	but WITHOUT ANY WARRANTY; without even the implied warranty of
--	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--	GNU General Public License for more details.

--	You should have received a copy of the GNU General Public License
--	along with this program.  If not, see <https://www.gnu.org/licenses/>.


local Settings = {
	Threads	= 10;					-- Multithreaded decompiling (only use if you have a powerful CPU with lots of cores, 3900x maxed out efficiency at ~10 threads) (set to 0 for single-threaded decompiling)
	IgnoreObjects = {				-- The decendants of these objects will not be decompiled. I recommend ignoring these services as they contain mostly unmodified scripts
		Service.CoreGui;
		Service.CorePackages;
		Service.Chat;
	};
	IgnoreOtherPlayers = true;		-- Probably want this on unless you know you want it off
	IgnoreOtherCharacters = true;	-- Same here
}

local Service = setmetatable({}, {
	__index = function(self, Index)
		return game:GetService(Index) or nil
	end;
})

local Sum = function(Items)
	local Result = 0
	for i,v in next, Items do
		Result = Result + v
	end
	return Result
end
local Average = function(Items)
	return Sum(Items) / #Items
end

local ScreenGUI = Instance.new("ScreenGui", Service.CoreGui)
local Frame = Instance.new("Frame", ScreenGUI)
Frame.Transparency = 1
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BackgroundTransparency = 1
local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Transparency = 0.3
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.FontSize = Enum.FontSize.Size42
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.TextStrokeColor3 = Color3.new(255, 0, 0)
TextLabel.TextStrokeTransparency = 0.3
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextYAlignment = Enum.TextYAlignment.Top
TextLabel.Position = UDim2.new(0.2, 0, 0.3, 0)
TextLabel.Size = UDim2.new(0, 0, 0, 0)
TextLabel.Text = "Initializing..."
local Operation = "Initializing"
local Status = "Initializing"
local Current = "nil"
local Message = ""
local UpdateConn = Service.RunService.RenderStepped:Connect(function()
	local Dots = #Operation > 0 and ("."):rep((tick() * 10) % 6 / 2) or ""
	TextLabel.Text = table.concat({ Operation .. Dots; Status; Current; Message; }, "\n")
end)

Operation = "Finding Scripts in game"
local Scripts = {}
for i,v in next, game:GetDescendants() do
	if ((v.ClassName == "LocalScript" or v.ClassName == "ModuleScript") and (not Settings.IgnoreOtherPlayers or not v:IsDescendantOf(Service.Players) or v:IsDescendantOf(Service.Players.LocalPlayer))) then
		local Continue = true
		for _, Object in next, Settings.IgnoreObjects do
			if (v:IsDescendantOf(Object)) then
				Continue = false
				break
			end
		end
		if (Settings.IgnoreOtherCharacters) then
			for _, Player in next, Service.Players:GetPlayers() do
				if (Player ~= Service.Players.LocalPlayer and Player.Character and v:IsDescendantOf(Player.Character)) then
					Continue = false
					break
				end
			end
		end
		if (Continue) then
			Status = ("Scripts: %s"):format(#Scripts)
			Current = v:GetFullName()
			table.insert(Scripts, v)
		end
	end
end
Operation = "Finding Scripts in nil"
for i,v in next, getnilinstances() do
	if (v.ClassName == "LocalScript" or v.ClassName == "ModuleScript") then
		Status = ("Scripts: %s"):format(#Scripts)
		Current = v:GetFullName()
		table.insert(Scripts, v)
	end
end

local x = ""

Operation = "Decompiling"
local Decompiles = {}
if (Settings.Threads == 0) then
	for i,v in next, Scripts do
		if (i % 20 == 0) then
			wait()
		end
		
		local Start = tick()
		local AVG = Average(Decompiles)
		local SPM, ETA = math.floor(60 / AVG), (#Scripts - i) * AVG
		Status = ("%s / %s	 %s"):format(tostring(i - 1), tostring(#Scripts), tostring((i - 1) / #Scripts * 100):sub(1, 6)) .. "%\n" .. ("SPM: %s	 ETA: %sm %ss"):format(SPM, math.floor(ETA / 60), math.floor(ETA % 60))
		Current = v:GetFullName()
		local Result = decompile(v)
		if (Result) then
			x = x .. "-- " .. v:GetFullName() .. "\n\n" .. Result .. "\n\n\n"
		else
			Message = "Decompiling " .. v:GetFullName() .. " failed"
			x = x .. "-- " .. v:GetFullName() .. "\n\n" .. "-- Decompile returned nil; please try again." .. "\n\n\n"
		end
		table.insert(Decompiles, tick() - Start)
	end
elseif (Exploit == "Elysian") then
	Current = ""
	local Decompiling = {}
	
	for i,v in next, Scripts do
		local N = #Decompiles
		repeat
			local AVG = Average(Decompiles) / Settings.Threads
			local SPM, ETA = math.max(0, math.floor(60 / AVG)), math.max(0, (#Scripts - N) * AVG)
			Status = ("%s / %s	 %s"):format(tostring(math.max(0, N - 1)), tostring(#Scripts), tostring(math.max(0, (N - 1) / #Scripts * 100)):sub(1, 6)) .. "%\n" .. ("SPM: %s	 ETA: %sm %ss"):format(SPM, math.floor(ETA / 60), math.floor(ETA % 60))
			Current = ""
			for i,v in next, Decompiling do
				Current = Current .. ("T%.2d: %s\n"):format(i, v:GetFullName())
			end
			wait()
		until (#Decompiling < Settings.Threads)
		
		local Start = tick()
		table.insert(Decompiling, v)
		decompile(v, "unluac", function(Script, Error)
			table.remove(Decompiling, 1)
			table.insert(Decompiles, tick() - Start)
			if (Script) then
				FullName = v:GetFullName()
				x = x .. "-- " .. FullName .. "\n\n" .. Script .. "\n\n\n"
			else
				Message = "Failed to decompile " .. v:GetFullName()
				x = x .. "-- " .. FullName .. "\n\n-- ERROR: \n--[==[\n" .. Error .. "\n]==]\n\n\n"
			end
		end, 15)
	end
elseif (Exploit == "Synapse") then
	Current = ""
	local Decompiling = {}
	
	for i,v in next, Scripts do
		local N = #Decompiles
		repeat
			local AVG = Average(Decompiles) / Settings.Threads
			local SPM, ETA = math.max(0, math.floor(60 / AVG)), math.max(0, (#Scripts - N) * AVG)
			Status = ("%s / %s	 %s"):format(tostring(math.max(0, N - 1)), tostring(#Scripts), tostring(math.max(0, (N - 1) / #Scripts * 100)):sub(1, 6)) .. "%\n" .. ("SPM: %s	 ETA: %sm %ss"):format(SPM, math.floor(ETA / 60), math.floor(ETA % 60))
			Current = ""
			for i,v in next, Decompiling do
				Current = Current .. ("T%.2d: %s\n"):format(i, v:GetFullName())
			end
			wait()
		until (#Decompiling < Settings.Threads)
		
		local Start = tick()
		table.insert(Decompiling, v)
		spawn(function()
			local Result = decompile(v)
			table.remove(Decompiling, 1)
			if (Result) then
				x = x .. "-- " .. v:GetFullName() .. "\n\n" .. Result .. "\n\n\n"
			else
				Message = "Decompiling " .. v:GetFullName() .. " failed"
				x = x .. "-- " .. v:GetFullName() .. "\n\n" .. "-- Decompile returned nil; please try again." .. "\n\n\n"
			end
			table.insert(Decompiles, tick() - Start)
		end)
	end
end

Operation = ""
Status = "Done!"
Current = ""
Message = ""

Clipboard.set(x)
UpdateConn:Disconnect()
wait(5)
ScreenGUI:Destroy()