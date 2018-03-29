local qtdMetodos = 0
--quando dofile() executar, essa função será chamada quando encontrar interface {...}, e "{...}" será passada como o parâmetro t
function interface(t)
	--podemos percorrer o parâmetro t, pois é um construtor de tabela
	print("t = "..tostring(t))
	print("t.methods = "..tostring((t.methods)))
	print("#(t.methods) = "..#(t.methods))
	for i,n in pairs(t.methods) do
		qtdMetodos = qtdMetodos + 1
		print(i.." = "..tostring(n))
	end
end
--"executa" o arquivo 
dofile("exinterface")
print("qtdMetodos = ".. qtdMetodos)
