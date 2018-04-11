local function decode(tipo,valor)
	if tipo == "char" or tipo == "string" then
		valor = string.gsub(valor,thesmile,"\n")
	elseif tipo == "number" then
		--se resulttype é do tipo number, 
		valor = tonumber(valor)
	end
	return valor
end


