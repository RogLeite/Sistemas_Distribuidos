--Cliente, Fé no pai que esse programa sai

local socket = require ("socket")
for i=1,10000 do
	local client = socket.connect('localhost',57920)
	--if client then
	--	print('Conectado')
	--else
	--	print ('offline')
	--end
	--print("Curr "..i)
	client:send(i.."\n")
	local line,status, partial = client:receive()
	--print("Resposta "..(line or partial))
end
