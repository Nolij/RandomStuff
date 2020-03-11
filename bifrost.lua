-- Bifrost Compatibility Library by xdMatthewbx#1337
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

if (not __BIFROST) then
	getgenv().Exploit = (function()
		return (ELYSIAN_INITIATED and "Elysian") or (syn and "Synapse") or (PROTOSMASHER_LOADED and "ProtoSmasher") or "Unknown"
	end)()

	getgenv().Service = setmetatable({}, {
		__index = function(t, k)
			return game:GetService(k) or nil
		end
	})

	local w = wait
	getgenv().wait = function(x)
		if not x then
			return Service.RunService.RenderStepped:Wait()
		else
			return w(x)
		end
	end

	if (Exploit == "Unknown") then
		error("unsupported exploit")
	elseif (Exploit == "Elysian") then
		--[[local dec = decompile
		getgenv().decompile = function(Script, Mode, ...)
			if (not Mode) then
				if (not dec(Script, "dump")) then
					return
				end
				local x
				local t = tick()
				decompile(Script, "unluac", function(result, err) if not err then x = result else x = "-- " .. err end end)
				repeat wait() until x or t + 15 < tick()
				return x
			else
				return dec(Script, Mode, ...)
			end
		end]]
		getgenv().hookfunc = replaceclosure
		local d = debug
		getgenv().debug = setmetatable({
			getupvalues = function(f)
				return getupvals(f) or {}
			end;
			getupvalue = function(f, upval)
				return debug.getupvalues(f)[upval]
			end;
			setupvalue = setupval;
			getlocals = getlocals;
			getlocal = function(lvl, name)
				return debug.getlocals(f)[name]
			end;
			setlocal = setlocal;
			getconstants = getconsts;
			getconstant = function(f, const)
				return debug.getconstants(f)[const]
			end;
			setconstant = setconst;
		},
		{
			__index = function(t, k)
				return rawget(t, k) or (_debug and _debug[k]) or d[k]
			end;
		})
	elseif (Exploit == "Synapse") then
		local d = debug
		getgenv().debug = setmetatable({
			getupvalues = function(f)
				if (pcall(d.getupvalues, f)) then
					return d.getupvalues(f)
				else
					return {}
				end
			end;
			stack = loadstring("\27\76\117\97\81\0\1\4\4\4\8\0\6\0\0\0\83\116\97\99\107\0\0\0\0\0\0\0\0\0\0\1\10\6\9\0\0\0\100\0\0\0\138\0\0\0\192\0\128\0\0\1\0\0\101\1\0\0\220\0\0\0\162\64\0\0\158\0\0\1\30\0\128\0\0\0\0\0\1\0\0\0\5\0\0\0\87\114\97\112\0\0\0\0\0\0\0\0\0\0\1\10\250\5\0\0\0\64\0\0\0\165\0\0\0\92\64\0\0\158\0\128\124\30\0\128\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", "stack");
		},
		{
			__index = function(t, k)
				return rawget(t, k) or d[k]
			end;
		})
		getgenv().Clipboard = { set = syn.write_clipboard; }
		setreadonly(Clipboard, true)
	elseif (Exploit == "ProtoSmasher") then
		local d = debug
		getgenv().debug = setmetatable({
			getupvalues = function(f)
				if (pcall(d.getupvalues, f)) then
					return d.getupvalues(f)
				else
					return {}
				end
			end;
			stack = loadstring("\27\76\117\97\81\0\1\4\4\4\8\0\6\0\0\0\83\116\97\99\107\0\0\0\0\0\0\0\0\0\0\1\10\6\9\0\0\0\100\0\0\0\138\0\0\0\192\0\128\0\0\1\0\0\101\1\0\0\220\0\0\0\162\64\0\0\158\0\0\1\30\0\128\0\0\0\0\0\1\0\0\0\5\0\0\0\87\114\97\112\0\0\0\0\0\0\0\0\0\0\1\10\250\5\0\0\0\64\0\0\0\165\0\0\0\92\64\0\0\158\0\128\124\30\0\128\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", "stack");
		},
		{
			__index = function(t, k)
				return rawget(t, k) or d[k]
			end;
		})
		getgenv().checkcaller = is_protosmasher_caller
		getgenv().getreg = debug.getregistry
		getgenv().setreadonly = function(t, readonly)
			return readonly and make_readonly(t) or make_writeable(t)
		end
		getgenv().newcclosure = protect_function
		getgenv().Clipboard = { set = setclipboard; }
		setreadonly(Clipboard, true)
	end
	
	getgenv().print_r = function(t, output)
		local ret = ""
		local out = function(...)
			ret = ret .. table.concat({...}, " ") .. "\n"
		end
		local function ts(x)
			return ("(%s) %s"):format(typeof(x) ~= "Instance" and typeof(x) or x.ClassName, (typeof(x) ~= "Instance" and tostring(x) or x:GetFullName()))
		end
		local scanned = {}
		local function f(t, indent)
			if (type(t) ~= "table") then
				out(indent .. ts(t))
			else
				for i,v in next, t do
					if (typeof(v) == "table" and not scanned[v]) then
						scanned[v] = true
						out(indent .. "[" .. ts(i) .. "] => {")
						f(v, indent .. "    ")
						out(indent .. "}")
					else
						out(indent .. "[" .. ts(i) .. "] => " .. ts(v))
					end
				end
			end
		end
		if (typeof(t) == "table") then
			out("{")
		end
		f(t, (typeof(t) ~= "table" and "" or "    "))
		if (typeof(t) == "table") then
			out("}")
		end
		(output or print)(ret)
	end

	getgenv().__BIFROST = true
	getgenv().__MIXCOMPAT = true -- for backwards compatibility
end