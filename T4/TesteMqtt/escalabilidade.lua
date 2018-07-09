local mqtt = require ("mqtt_library")

--function mqttcb(topic, message)   
  --print("Received: " .. topic .. ": " .. message)
---end

mqtt_client = mqtt.client.create("127.0.0.1", 1883, mqttcb)  
mqtt_client:connect("escmiau")  
mqtt_client:subscribe({"log"})  



mqtt_client:publish("log", "ihuuu")

mqtt_client:handler()