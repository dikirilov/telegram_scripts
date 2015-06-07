  local utf8 = require 'utf8'
  local http = require("socket.http")
  local json = (loadfile "/home/bananapi/tg/scripts/JSON.lua")()
  function on_msg_receive (msg)
      if msg.out then
          return
      end
--      print(utf8.lower(msg.text))
      if (utf8.find(utf8.lower(msg.text),'курс')) then
--	 local data = http.request "http://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.xchange+where+pair+=+%22USDRUB,EURRUB%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
--	 local cur = json:decode(data)
	 local res = ""
	 local wtf = "Курс "
	 local xml_data = xml.loadpath("http://www.cbr.ru/scripts/XML_daily.asp")
	 print(xml_data)
	 if (utf8.find(utf8.lower(msg.text),'евро'))then
	  wtf = wtf .. "евро: "
--	  res = cur.query.results.rate[2]
	 else
	  wtf = wtf .. "доллара: "
--	  res = cur.query.results.rate[1]
	 end
--	 print(res)
--	 for k,v in pairs(res) do print(k,v) end
	 send_msg (msg.from.print_name, wtf .. tostring(res), ok_cb, false)
      end
  end
   
  function on_our_id (id)
  end
   
  function on_secret_chat_created (peer)
--	print("on_secret_chat_created!!")
--	print(peer)
  end
   
  function on_user_update (user)
  end
   
  function on_chat_update (user)
  end
   
  function on_get_difference_end ()
  end
