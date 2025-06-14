extends CanvasLayer

var audio_player #for backgraound music

func showLabel(t): #show message
	$Label1.text = t
	$Label1.show()

func _ready(): #hide the elements
	$Label1.hide()
	$Button.hide()
	$Button2.hide()
	audio_player = AudioStreamPlayer.new() 
	self.add_child(audio_player)
	audio_player.stream = load('res://asset/Theme1.mp3') #background music
	audio_player.stream.loop = true
	audio_player.play()
	
	

func _on_button_pressed(): #pressed to restart the game
	get_node("/root/main").restart()


func _on_button_2_pressed(): #pressed to quit the game
	get_tree().quit()
