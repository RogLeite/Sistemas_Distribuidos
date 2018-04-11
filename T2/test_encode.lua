local thesmile = "\\smile\\"
local function encode(tipo,valor)
	if tipo == "char" or tipo == "string" then
		valor = string.gsub(valor,"\n",thesmile)
	elseif tipo == "number" then
		--se resulttype é do tipo number, 
		valor = tostring(valor)
	end
	return (valor or "nil") .."\n"
end



local l_type = "string"
local l_value = "foo\n"
l_value = encode(l_type,l_value)
print("type(l_value) = "..type(l_value))
print("l_value = "..l_value.."só de ref para ver se o \\n entra direitinho ")
