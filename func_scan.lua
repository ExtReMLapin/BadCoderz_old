--[[
Disclamer : 

metafunc:src() is not included, this function return (char*) the function's source code  and will decompile it if it's compiled.
It's searching for resource-heavy function in high rate hooks (Looking at you coderhire """""""coders""""""")
If lua decompilation fail but ASM decompile works, it will return " false, asm string func"


What's it's not doing : 

	-Detecting if the bad function is commented
	-Detecting is the you modded the hook rate execution on the function( something like " nextthink = CurTime() + 42")
	-Detecting if you cached heavy function, (But jesus don't fucking overwrite default gmod functions)
	-Decompiling each function ran in your function to check if another heavy function is used IT IS NOT RECURSIVE
	-Profiling each func (see ^^^) to see if it's slow, DBugR is good at this.
	-Fixing your code

What's it's telling you :
	-What code is bad and what is wrong with it (I mean, it's telling you if there is a bad function in it)

--]]







local dangerous_hooks = {"Tick", "Think", "HUD", "Draw", "Calc"} -- Just part name of the hook, found with string.match(Realhook_name,v); v is one of the string here
local heavy_funcs = {"[^%a]Material[^%a]", -- So SetMaterial is not called
					"[^%a]surface.CreateFont[^%a]",
					"[^%a]surface.GetTextureID[^%a]",
					"[^%a]player.GetAll[^%a]",
					"[^%a]ents.GetAll[^%a]",
					"[^%a]Color[^%a]",
					}


local function func_hasbad_func(containerf, tofindf)
	--print(containerf)
	return  string.match(containerf, tofindf) -- improve this
	--[[
		Todo : 	
				-Ignore commented lines
				-Scan for local function ? Not ez to do
				-Scan for alias function, like if he did something like that at the start of the file
										local surface.CreateFont = surface_CreateFont
				


	--]]

end

local yellow = Color(255,136,0) -- it's orange, not yellow, i know
local mg = Color(0,138,159)
local red = Color(255,50,50)
local green = Color(50,250,50)
local blue = Color(150,150,250)
function start_scanning() -- heavy function
	MsgC(mg, "--------Starded Scanning for slow/spooky code--------\n")

	for k, v in pairs(hook.GetTable()) do
		local skip = true
		for k42, v42 in pairs(dangerous_hooks) do
			if string.match(k,v42) then skip = false end
		end
		
		local printedhookname = 0
		for k2, v2 in pairs(v) do
			local funcstr, funcstr2 = v2:src()
			if funcstr then 
				for k3, v3 in pairs(heavy_funcs) do
					local result = func_hasbad_func(funcstr, v3)
					if result then 
						local len = string.len(result) 
						result = string.Right(string.Left(result, len-1),len-2)
						if printedhookname == 0 then 
							printedhookname = 1
							MsgC(red, "▬▬▬▬▬▬Hook ")
							MsgC(blue, k)
							MsgC(red, " has spooky function(s) !\n")
						end
						MsgC(red, "▬▬▬▬▬▬───Hook func ")
						MsgC(blue, k2)

						if skip == true then 
							MsgC(red, " has slow func : ")
							MsgC(blue, result)
							MsgC(green, " but the hook is not Heavy.\n")

						else
							MsgC(red, " has slow func : ")
							MsgC(blue, result .. "\n")
							local path = debug.getinfo(v2)["source"]
							MsgC(blue, "▬▬▬▬▬▬───" .. path .. "\n")
							MsgC(red, "▬▬▬▬▬▬▬▬▬▬▬\n")
							MsgC(yellow, funcstr)
							MsgC(red, "\n\n▬▬▬▬▬▬▬▬▬▬▬\n")
						end
					end
				end
			else
				for k3, v3 in pairs(heavy_funcs) do
					local result = func_hasbad_func(funcstr2, v3)
					if result then 
						local len = string.len(result) 
						result = string.Right(string.Left(result, len-1),len-2)
						if printedhookname == 0 then 
							printedhookname = 1
							MsgC(red, "▬▬▬▬▬▬Hook ")
							MsgC(blue, k)
							MsgC(red, " has spooky decompiled function(s) !\n")
						end
						MsgC(red, "▬▬▬▬▬▬───Hook func ")
						MsgC(blue, k2)

						if skip == true then 
							MsgC(red, " has slow decompiled func : ")
							MsgC(blue, result)
							MsgC(green, " but the hook is not Heavy.\n")

						else
							MsgC(red, " has slow decompiled func : ")
							MsgC(blue, result .. "\n")
							local path = debug.getinfo(v2)["source"]
							MsgC(blue, "▬▬▬▬▬▬───" .. path .. "\n")
							MsgC(red, "▬▬▬▬▬▬▬▬▬▬▬\n")
							MsgC(yellow, funcstr2)
							MsgC(red, "\n\n▬▬▬▬▬▬▬▬▬▬▬\n")
						end
					end
				end
			end
		end
		if printedhookname == 0 then 
			MsgC(green, "▬▬▬▬▬▬Hook ")
			MsgC(blue, k)
			MsgC(green, " is CLEAN !\n")
		end
	end
	MsgC(mg, "--------Finished Scanning for slow/spooky code--------\n")

end
