kstring = {}
for i=1,999 do
	kstring[#kstring+1] = tostring(i%10)
end
kstring[#kstring+1] = "\n"
kstring = table.concat(kstring)
--print("sizeof(kstring) = "..#kstring)
--print(kstring)

