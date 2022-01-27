


extends Plugin #默认继承插件类，请勿随意改动


#可以在此处定义各种插件范围的全局变量/常量/枚举等，例如：
#var data:Dictionary = {}
#var lib:Plugin = null
#var connected:bool = true
var send_qq:int =
var receive_qq:int =
var text="打卡了啦打卡啦"
var host="https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=ak&client_secret=sk"
var token:String
var words





#将在此插件的文件被读取时执行的操作
#必须在此处使用set_plugin_info函数来设置插件信息，插件才能被正常加载
#例如：set_plugin_info("example","示例插件","author","1.0","这是插件的介绍")
#可以在此处初始化和使用一些基本变量，但不建议执行其它代码，可能会导致出现未知问题
func _on_init():
	#set_plugin_info("","","","","")
	set_plugin_info("dakapro","完美校园自动打卡bot","youmingsama","1.0","转发打卡信息")
	

#将在RainyBot与协议后端恢复连接时执行的操作
#可以在此处进行一些与连接状态相关的操作，例如恢复连接后发送通知等
func _on_connect():
	#connected = true
	pass


#将在此插件被完全加载后执行的操作
#可以在此处进行各类事件/关键词/命令的注册，以及配置/数据文件的初始化等
func _on_load():
	#register_event(Event,"")
	#register_keyword("","")
	#register_console_command("","")
	#init_plugin_config({})
	#init_plugin_data()
	register_event(FriendMessageEvent,_receive_group_event)


#将在所有插件被完全加载后执行的操作
#可以在此处进行一些与其他插件交互相关的操作，例如获取某插件的实例等
#注意：如果此插件硬性依赖某插件，推荐在插件信息中注册所依赖的插件，以确保其在此插件之前被正确加载
func _receive_group_event(event:FriendMessageEvent):
	if _check_perm(event):
			var group=Group.init(send_qq)
			var arr=event.get_message_array(ImageMessage)
			var path:String="E:\\RainyBot-Core-v2.0-beta-2-mirai\\data\\"+(arr[0]).get_image_id()+".jpg"
			var Response=await  Utils.send_http_get_request(host)
			var dic=Response.get_as_dic()
			if !dic.is_empty():
				token = dic["access_token"]
			var request_url = "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic"
			var req_url:String = request_url + "?access_token=" + token
			var http_request=await  Utils.send_http_get_request(arr[0].get_image_url())
			var raw_http_request=http_request.get_as_byte()

			var image = Image.new()
			image.load_jpg_from_buffer(raw_http_request)
			var err= image.save_png(path)
			
			var file = File.new()
			err=file.open(path,file.READ)
			if err!=OK:
				Console.print_text("读取失败")
			else:
				Console.print_text("读取成功")
			var leng = file.get_len()
			var str1 = file.get_buffer(20000000)
			
			
			
			var img_base64 = Marshalls.raw_to_base64(str1)
			
			
			var str3:String = "image="+ img_base64.uri_encode()
			
			
			var request =await   Utils.send_http_post_request(req_url,str3,["''content-type': 'application/x-www-form-urlencoded'"])
			var _dic1=request.get_as_dic()
			if !_dic1.is_empty():
				words =_dic1
				Console.print_error(str(words))
				
			
			
			
			
			
			#if arr.size()>0:
	#			group.send_message(AtAllMessage.init())
			#	group.send_message(ImageMessage.init_url(arr[0].get_image_url()))
				#group.send_message(text)
			
				
				
				
func _check_perm(event):
	return event.get_sender_id()==receive_qq

func _on_ready():
	#lib = get_plugin_instance("")
	pass


#将在此插件运行的每一秒执行的操作
#可在此处进行一些计时，或时间判定相关的操作，例如整点报时等
func _on_process():
	#var _runtime = get_plugin_runtime()
	pass


#将在RainyBot与协议后端断开连接时执行的操作
#可以在此处进行一些与连接状态相关的操作，例如断开连接后暂停某些任务的运行等
func _on_disconnect():
	#connected = false
	pass


#将在此插件即将被卸载时执行的操作
#可在此处执行一些自定义保存或清理相关的操作，例如储存自定义的文件或清除缓存等
#无需在此处取消注册事件/关键词/命令，或者对内置的配置/数据功能进行保存，插件卸载时将会自动进行处理
func _on_unload():
	#lib.save_file("")
	pass
