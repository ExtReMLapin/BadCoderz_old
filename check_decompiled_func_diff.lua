--using glib/lua/decompiler/functionbytecodereader.lua 

--uncompiled
function decompress_File(inputf, outputf)
	local str1 = file.Read(inputf, "BASE_PATH")
	local i = 0;
	local str2;
	while i < 100 do
		str2 = str1
		str2 = string.Right(str2, string.len(str2)-i)
		str2 = util.Decompress(str2)
		if str2 then print("Offset of junk bytes :" .. i)  print(str2) file.Write(outputf, str2) break end
		
		i = i +1
	end
end

--compiled and then decompiled

	-- @decompress_File
function (...)
	local i = 0
	local str2 = nil
		if i < 100 then
			LOOP ReadOnlyBase 3, 34
			str2 = file.Read (inputf, "BASE_PATH")
			str2 = util.Decompress (string.Right (str2, string.len (str2) - i))
			if str2 then
				print ("Offset of junk bytes :" .. i)
				print (str2)
				file.Write (outputf, str2)
				JMP ReadOnlyBase 3, 2
				
				i = i + 1
				JMP ReadOnlyBase 3, -38
			end
		end
	end
	return
end

