extends Control

var voices = DisplayServer.tts_get_voices_for_language("en") #tts engine
var voice_id = voices[0] #female voice
var audio_player #for backgraound music

func _ready():
	audio_player = AudioStreamPlayer.new() 
	self.add_child(audio_player)
	audio_player.stream = load('res://asset/smallheart.ogg') #background music
	audio_player.stream.loop = true
	audio_player.play()
	$Panel/Panel1.hide()

func _on_start_pressed(): #pressed to start the game
	get_tree().change_scene_to_file("res://main.tscn") #start game if start button is pressed

func _on_help_pressed(): #read out the help message
	var text1 = "Please click the crosshair on the map to install turret, kill the monster to defend the homeland"
	DisplayServer.tts_speak(text1, voice_id, 100) #read help message
	$Panel/Panel1.show()
	$Timer.stop()
	$Timer.one_shot = true
	$Timer.wait_time = 6
	$Timer.start()

func _on_quit_pressed(): 
	get_tree().quit() #quit game


func _on_timer_timeout():
	$Panel/Panel1.hide()
