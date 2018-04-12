local thesmile = "\\:)\\"
local function encode(tipo,valor)
	print("In encode:\n")
	print("valor = "..(valor or "hey, received nil"))
	if tipo == "char" or tipo == "string" then
		valor = string.gsub(valor,"\n",thesmile)
		print("\ttipo == char ou string, valor codificado = "..valor)
	elseif tipo == "double" then
		--se resulttype é do tipo number, 
		valor = tostring(valor)
		print("\ttipo == double, valor codificado = "..tostring(valor))
	end
	return (valor or "nil") .."\n"
end


local l_type = "string"
local l_value = "foo\n"
l_value = encode(l_type,l_value)
print("type(l_value) = "..type(l_value))
print("l_value = "..l_value.."só de ref para ver se o \\n entra direitinho ")
