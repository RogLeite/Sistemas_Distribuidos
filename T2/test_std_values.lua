local std_values = {
	string = " ",
	char = " ",
	double = 0 
}

for i,n in pairs(std_values) do
	print("type(i) = "..type(i))
	print("std_values["..i.."] = "..n.."end")
end
if 0 then
	print("0 é true")
else
	print("0 é false")
end
