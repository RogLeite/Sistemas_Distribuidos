
local mqtt = require ("mqtt_library")

function mqttcb(topic, message)   
  print("Received: " .. topic .. ": " .. message)
end

function love.load()
  ------------------------------------
  mqtt_client = mqtt.client.create("127.0.0.1", 1883, mqttcb)  
  mqtt_client:connect("jogomvfp")  
  mqtt_client:subscribe({"log"})  
--------------------------------------
end

function love.update(dt)
  
  mqtt_client:handler()
end

function love.draw()
end

function love.keypressed(key)
  if key == 'a' then
    mqtt_client:publish("log", "atirou")
  end
end