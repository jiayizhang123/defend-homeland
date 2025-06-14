extends Node2D

var audio_player1
var voices = DisplayServer.tts_get_voices_for_language("en") #tts engine
var voice_id = voices[0] #female voice
@onready var uh_oh = preload("res://asset/uh-oh.mp3") #load sound for ineffective action
@onready var destroyed = preload("res://asset/wood-smash.mp3") #load sound for home collapsed
@onready var ding = preload("res://asset/Coin_4.wav") #load sound for warning of a new wave

func start():
	#preset the position of artillery/turret installation for different level
	var x = 0
	#set all the positions of installation for artilleries/turrets
	for i in get_node("/root/main").get_children(): 
		if "installLocation" in i.name:
			i.position.x = Config.installLocationx[(Config.level-1)*Config.installLocation_n+x]
			i.position.y = Config.installLocationy[(Config.level-1)*Config.installLocation_n+x]
			x += 1
	#preset the postion of home and finger
	$home.position.x = Config.homex[Config.level-1]
	$home.position.y = Config.homey[Config.level-1]
	$Finger.position.x = Config.fingerx[Config.level-1]
	$Finger.position.y = Config.fingery[Config.level-1]
	#show tilemap according to game level
	if Config.level == 1:
		$TileMap.show()
		$TileMap2.hide()
	elif Config.level == 2:
		$TileMap.hide()
		$TileMap2.show()
	#set timer to count down for a new wave
	$Timer1.one_shot = true
	$Timer1.wait_time = 3
	$Timer1.start()
	get_node("/root/main/hud/Label1").show() #show label in order to show seconds left
	for i in get_node("/root/main").get_children(): #show the installation place for artilleries/turrets
		if "installLocation" in i.name:
			i.get_node("crosshair1").show()
	$Finger.show() #show finger indicating the point that monsters come out
	#pulse the wave text to give the warning of new round
	get_node("/root/main/hud/RichTextLabel").text = "[pulse freq=1.0 color=#ffffff40 ease=-2.0]Wave:" + str(Config.wave) + "[/pulse]"
	#speak out the level
	DisplayServer.tts_speak("Level "+ str(Config.level), voice_id, 100)
	
	

func _ready():
	start() #invoke start
	$AudioStreamPlayer.stream = uh_oh #load sound for ineffective action
	$AudioStreamPlayer.stream.loop = false # no loop
	$AudioStreamPlayer2.stream = destroyed #load sound for home collapsed
	$AudioStreamPlayer2.stream.loop = false # no loop
	audio_player1 = AudioStreamPlayer.new() 
	audio_player1.stream = ding #load sound of new round warning
	self.add_child(audio_player1) 
	
func intrude(ani): #if house is invaded once
	#if house's health is empty or boss intrudes the home
	if Config.hitpoints <= 1 or (ani == "goblin" or ani == "skelleton"): 
			Config.hitpoints = 0 #lose the game
			get_node("/root/main/hud").showLabel('You Lose!') #show message
			get_node("/root/main/hud/Button").show() #show restart button
			get_node("/root/main/hud/Button2").show() #show quit button
			noTouch() #prohibit building turret
			if Config.gameover == 0:
				get_node("/root/main/home").play("collapse") #play collapsed animation
				get_node("/root/main/AudioStreamPlayer2").play() #play explostion sound
				DisplayServer.tts_speak("You Lose", voice_id, 100) #speak out 
			Config.gameover = 1 #set game over flag = 1
			Config.level = 1 # reset the level to 1
	else:
		Config.hitpoints -= 1 #decrese 1 hitpoint 
		get_node("/root/main/home").play("shake") #play shaking animation
		$AudioStreamPlayer.play()

func _process(delta): #real time process
	if !$Timer1.is_stopped(): #if Timer1 is not stopped, show seconds left
		get_node("/root/main/hud/Label1").text = str(ceil($Timer1.time_left)) #round and ceil the time
	else: #if timer1 is stopped, then stop the pulse effect of wave text
		get_node("/root/main/hud/RichTextLabel").text = "Wave:" + str(Config.wave) 
	
	if Config.gameover == 2: #if game is win
		if get_node("/root/main/pathSpawner").get_child_count() < 2: #wait clear of all enemies
			#display message and button
			get_node("/root/main/hud").showLabel('You Win!') 
			get_node("/root/main/hud/Button").show()
			get_node("/root/main/hud/Button2").show()
			noTouch() #prohibit to install or upgrade of artillery/turret
	elif Config.gameover == 0 and Config.wave_n == 0: #if game is not over and one wave is over
		if get_node("/root/main/pathSpawner").get_child_count() < 2: #wait clear of all enemies
			if Config.wave == 3: #if wave reaches the last one of level
				Config.waveb_ai_ratio = 0.0 #reset ai_ratio for enemy's health in next level
				Config.progress_ratio_wave.clear()
				Config.level += 1 #level up
				if Config.level == 3: # if level reaches the last level
					Config.gameover = 2 # set game win flag = 2
					Config.level = 1 # reset the level to 1
					DisplayServer.tts_speak("You Win", voice_id, 100) #speak out
				else: # if no the last level, then start a new round
					Config.gameover = 4 # next level
					get_node("/root/main/hud/Label1").text = "Level " + str(Config.level-1) + " is cleared!"
					get_node("/root/main/hud/Label1").show()
					await get_tree().create_timer(2.0).timeout
					
					get_node("/root/main").restart()
				return
			else: # if not the last wave, then next wave 
				#a bit of AI algorithm
				#calculate the eneemy's health ratio in next wave in terms of average progress ratio in current wave
				var sum = 0.0
				for element in Config.progress_ratio_wave:
					sum += element
				Config.waveb_ai_ratio = (1 - sum/Config.wavea[(Config.level-1) * Config.default_wave]) * (randf()/2+0.5)
				
				Config.progress_ratio_wave.clear()
				Config.wave += 1  
				 # reset the number of new wave and countdwon, then start
				Config.wave_n = Config.wavea[(Config.level-1) * 3]
				$Timer1.stop()
				$Timer1.one_shot = true
				$Timer1.wait_time = 3
				$Timer1.start()
				get_node("/root/main/hud/Label1").show() #show count down number
				#wave pulse effect
				get_node("/root/main/hud/RichTextLabel").text = "[pulse freq=1.0 color=#ffffff40 ease=-2.0]Wave:" + str(Config.wave) + "[/pulse]"
	

func noTouch():
	for i in get_node("/root/main").get_children(): #prohbit the installation of artillery/turret
		if "installLocation" in i.name:
			i.noresponse = 1
			for j in i.get_children(): #prohibit the upgrade the artillery/turret
				if "Artillery" in j.name:
					j.get_node("Node2D/hbox2").hide()

func _on_timer_1_timeout(): #when timer1 is out, hide the finger and crosshair
	get_node("/root/main/hud/Label1").hide()
	$Finger.hide()
	audio_player1.play()
	for i in get_node("/root/main").get_children(): 
		if "installLocation" in i.name:
			i.get_node("crosshair1").hide()

func restart(): #restart the game or round
	get_node("/root/main/home").set_animation("shake") #reset the home picture
	for i in get_node("/root/main/pathSpawner").get_children(): #clear all the enemies
		if "Path2D" in i.name:
			i.queue_free()
	for i in get_node("/root/main").get_children(): #allow to install artillery/turret
		if "installLocation" in i.name:
			i.noresponse = 0
			i.get_node("hbox/towerPanel1-3").hide() #hide the third weapon for low level
			for j in i.get_children(): #clear all the artilleries/turrets in the map
				if "Artillery" in j.name:
					j.queue_free()
	#reset hitpoints, wave, score and wave number
	Config.hitpoints = Config.default_hitpoints
	Config.wave = 1
	Config.score = Config.default_score
	Config.wave_n = Config.wavea[(Config.level-1) * Config.default_wave]
	Config.progress_ratio_wave.clear()
	#if game over or win , set game level to 1
	if Config.gameover != 0:
		Config.gameover = 0
		
	#hide and message panel and button, update the level number and start
	get_node("/root/main/hud/Label1").hide()
	get_node("/root/main/hud/Button").hide()
	get_node("/root/main/hud/Button2").hide()
	get_node("/root/main/levelNumber").set_animation(str(Config.level)) #display level number
	get_node("/root/main").start()

