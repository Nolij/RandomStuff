-- ZoomUnlock by xdMatthewbx#1337
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

repeat wait() until debug.getupvalues
local Mode = "Invisicam" -- dumb unupdated games
game:GetService("Players").LocalPlayer.CameraMinZoomDistance = 0.5
game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 1000
game:GetService("Players").LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode[Mode]
game:GetService("Players").LocalPlayer.Changed:Connect(function()
	game:GetService("Players").LocalPlayer.CameraMinZoomDistance = 0.5
	game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 1000
	game:GetService("Players").LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode[Mode]
end)

--[[for i,v in next, getgc() do
	if (type(v) == "function" and (debug.getupvalues(v).charMap and debug.getupvalues(v).blacklist)) then
		debug.getupvalues(v).charMap[Instance.new("Player")] = game:GetService("Workspace")
		table.insert(debug.getupvalues(v).blacklist, game:GetService("Workspace"))
		Mode = "Zoom"
		game:GetService("Players").LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode[Mode]
    end
end]] -- one day ill update this fancy thingy so it works with luau, too lazy for now