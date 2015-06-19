  local utf8 = require 'utf8'
  local http = require("socket.http")
  local ltn12 = require("ltn12")
  local json = (loadfile "/home/bananapi/tg/scripts/JSON.lua")()
  local data = ""
  local body = ""
  local message = ""
  local url_req = "192.168.1.74:8080/rest/items/nobodyHome"
  function on_msg_receive (msg)
      if msg.out then
          return
      end
  if (utf8.find(utf8.lower(msg.text),'статус')) then
      if (utf8.find(utf8.lower(msg.text),'температура') or utf8.find(utf8.lower(msg.text),'температуры')) then
        data = http.request "http://192.168.1.74:8080/rest/items/tempHome/state"
        message = "Температура в доме " .. string.sub(data, 1, 4) .. "°"
      elseif (utf8.find(utf8.lower(msg.text),'влажность') or utf8.find(utf8.lower(msg.text),'влажности')) then
	data = http.request "http://192.168.1.74:8080/rest/items/humiHome/state"
        message = "Влажность в доме составляет " .. data .. "%"
      elseif (utf8.find(utf8.lower(msg.text),'давление') or utf8.find(utf8.lower(msg.text),'давления')) then
        data = http.request "http://192.168.1.74:8080/rest/items/press/state"
        message = "Атмосферное давление " .. data .. " Па"
      elseif (utf8.find(utf8.lower(msg.text),'дым') or utf8.find(utf8.lower(msg.text),'дыма')) then
        data = http.request "http://192.168.1.74:8080/rest/items/smoke/state"
        if (data == "0") then
 	  message = "Дыма нет"
	else
	  message = "В доме дым!"
	end
      else
        message = "Уточните параметры запроса"
      end
    elseif (utf8.find(utf8.lower(msg.text),'режим')) then
      data = http.request "http://192.168.1.74:8080/rest/items/nobodyHome/state"
      if (data == "0" and utf8.find(utf8.lower(msg.text),'включить')) then
	body = "1"
	message = "включен"
      elseif (data == "1" and utf8.find(utf8.lower(msg.text),'включить')) then
	body = ""
	message = "Режим уже включен"
      elseif (data == "0" and utf8.find(utf8.lower(msg.text),'выключить')) then
	body = ""
	message = "Режим уже выключен"
      else
	body = "0"
	message = "выключен"
      end
      if message ~= "" then
        http.request{
  	  url = url_req, 
	  source = ltn12.source.string(body),
	  method="POST",
	  headers={
	    ["content-type"] = "text/plain",
	    ["content-length"] = tostring(#body)
 	  },
        }
        message = "Режим 'никого нет дома' " .. message
      end
    end
    send_msg (msg.from.print_name, message, ok_cb, false)
--      print(utf8.lower(msg.text))]]
      if (utf8.find(utf8.lower(msg.text),'курс')) then
	 local data = http.request "http://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.xchange+where+pair+=+%22USDRUB,EURRUB%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
	 local cur = json:decode(data)
	 local res = ""
	 local wtf = "Курс "
	 if (utf8.find(utf8.lower(msg.text),'евро'))then
	  wtf = wtf .. "евро: "
	  res = cur.query.results.rate[2]
	 else
	  wtf = wtf .. "доллара: "
	  res = cur.query.results.rate[1]
	 end
--	 print(res)
--	 for k,v in pairs(res) do print(k,v) end
	 send_msg (msg.from.print_name, wtf .. tostring(res.Rate), ok_cb, false)
      end
  end
   
  function on_our_id (id)
  end
   
  function on_secret_chat_created (peer)
  end
   
  function on_user_update (user)
  end
   
  function on_chat_update (user)
  end
   
  function on_get_difference_end ()
  end
