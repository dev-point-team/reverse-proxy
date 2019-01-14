# reverse-proxy

simple reverse-proxy with help of ngrok (secure introspectable tunnels to localhost)

	#config
	
	1- port to start socket proxy (optional) ,ex:
	port = 1962
	
	2- path to setup ngrok ,it can be any environment variable (optional),ex:
	path = tmp
	
	3- name to rename ngrok (optional),ex:
	name = ngrok.exe
	
	4- authtoken of ngrok account (required),ex
	authtoken = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	
	#how to
	1 - first create account in : https://ngrok.com/ ,copy authtoken 
	2 - past authtoken to config.ini
	3 - open r-proxy.exe
	4 - go to : https://dashboard.ngrok.com/status, if all ok you will see new tunnel online
	this are your socket4 - socket5 information
enjoy
	
