extends Resource

class_name SimpleHTTP

#This dictionary is usable to access the Switch CDN (secret feature :P)
const cdns:Dictionary = {
	"wiiu": "wiiu.cdn.fortheusers.org",
	"switch": "switch.cdn.fortheusers.org"
}

##The thread that works on downloading things.
var download_thread:Thread = Thread.new()
##The HTTPClient for downloading assets from the HBAS.
var client:HTTPClient = HTTPClient.new()
##The [SimpleDownloadInfo] for this [SimpleHTTP]
var request_resources:SimpleDownloadInfo
##The response data from the server
var buffer:PackedByteArray
##A signal that is emitted when the client has connected.
signal download_done

func finish_thread() -> void:
	print("Thread finished")
	download_thread.wait_to_finish()

func connection_check() -> void:
	connect("connect_init_done", finish_thread)
	download_thread.start(initalConnection)

func initalConnection() -> void:
	client.connect_to_host(cdns.get("wiiu"))
	client.poll()
	while client.get_status() != HTTPClient.STATUS_CONNECTED:
		client.poll()
		if client.get_status() == HTTPClient.STATUS_DISCONNECTED:
			OS.alert("Disconnected from the server. No new images or homebrew will be loaded.", "No Network Connection")
		elif client.get_status() == HTTPClient.STATUS_CANT_RESOLVE:
			OS.alert("DNS for the appstore could not be resolved. No new images or homebrew will be loaded.", "DNS resolution error")
		elif client.get_status() == HTTPClient.STATUS_CANT_CONNECT:
			OS.alert("Could not connect to the appstore server. No new images or homebrew will be loaded.", "Could not connect")
	if client.get_status() == HTTPClient.STATUS_CONNECTED:
		emit_signal.call_deferred("connect_init_done")
	else:
		print("Thread error: ", client.get_status())

func download() -> void:
	buffer.clear()
	client.poll()
	if client.get_status() == HTTPClient.STATUS_CONNECTION_ERROR:
		print("Error 8")
		IP.clear_cache(cdns.get("wiiu"))
		initalConnection()
		return
	elif request_resources == null:
		print("Resource for download are missing")
		return
	elif request_resources.query_path.is_empty() or request_resources.headers.is_empty():
		print("Parameters for download are missing")
		return
	client.request(HTTPClient.METHOD_GET, request_resources.query_path, request_resources.headers)
	while client.get_status() == HTTPClient.STATUS_REQUESTING:
		client.poll()
	while client.get_status() == HTTPClient.STATUS_CONNECTED:
		buffer.append_array(client.read_response_body_chunk())
	emit_signal.call_deferred("download_done")
