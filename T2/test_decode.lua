
local thesmile = "\\:)\\"
local function decode(tipo,valor)
	print("In decode:\n")
	print("valor = "..(valor or "hey, received nil"))
	if tipo == "char" or tipo == "string" then
		--troca thesmile por \n
		valor = "\""..string.gsub(valor,thesmile,"\n").."\""
		print("\ttipo == char ou string, valor decodificado = "..valor)
	elseif tipo == "double" then
		--converte a string para um número
		valor = tonumber(valor)
		print("\ttipo == double, valor decodificado = "..tostring(valor))
	end
	return valor or "\"nil\""
end
local l_type = "number"
local l_valor = "132057"
print(decode(l_type, l_valor))

