--Cliente, Fé no pai que esse programa sai

local socket = require ("socket")
local client = socket.connect('localhost',57920)
for i=1,50000 do
	--if client then
	--	print('Conectado')
	--else
	--	print ('offline')
	--end
	--print("Curr "..i)
	client:send("hello\n")
	local line,status, partial = client:receive()
	--print("Resposta "..(line or partial))
end
