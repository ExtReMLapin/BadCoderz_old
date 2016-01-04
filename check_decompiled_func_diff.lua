--using glib/lua/decompiler/functionbytecodereader.lua 

--uncompiled
function decompress_File(inputf, outputf)
	local str2 = file.Read(inputf, "BASE_PATH")
	local i = 0;
	while i < 100 do
		str2 = string.Right(str2, string.len(str2)-i)
		str2 = util.Decompress(str2)
		if str2 then print("Offset of junk bytes :" .. i)  print(str2) file.Write(outputf, str2) break end
		
		i = i +1
	end
end

--compiled and then decompiled


-- @decompress_File
function (...)
	local str2 = file.Read (inputf, "BASE_PATH")
	local i = 0
		if i < 100 then
			LOOP ReadOnlyBase 2, 33
			str2 = util.Decompress (string.Right (str2, string.len (str2) - i))
			if str2 then
				print ("Offset of junk bytes :" .. i)
				print (str2)
				file.Write (outputf, str2)
				JMP ReadOnlyBase 2, 2
				
				i = i + 1
				JMP ReadOnlyBase 2, -37
			end
		end
	end
	return
end


