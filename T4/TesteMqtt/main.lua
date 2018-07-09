
local mqtt = require ("mqtt_library")

function love.load()
  ------------------------------------
  mqtt_client = mqtt.client.create("127.0.0.1", 1883, mqttcb)  
  mqtt_client:connect("jogomvfp")  
  mqtt_client:subscribe({"controle"})  
--------------------------------------
end

function love.update(dt)
  
end

function love.draw()
  end