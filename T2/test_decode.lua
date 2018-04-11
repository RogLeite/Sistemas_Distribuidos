
local thesmile = "\\smile\\"
local function decode(tipo,valor)
	if tipo == "char" or tipo == "string" then
		--troca thesmile por \n
		valor = string.gsub(valor,thesmile,"\n")
	elseif tipo == "number" then
		--converte a string para um número
		valor = tonumber(valor)
	end
	return valor or "nil"
end
local l_type = "number"
local l_valor = "132057"
print(decode(l_type, l_valor))

