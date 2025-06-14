extends Panel

var noresponse = 0 #flag for no installation
#turret1: missile artillery, 3 grade
#turret2: shock artillery, 3 grade, slow enemy's speed, less physical attack
#turret3: large range missile artillery, 3 grade

func _ready():
	$crosshair1.hide() #hide crosshair for installation
	$hbox.hide() #hide weapon panel
	get_node("hbox/towerPanel1-3").hide() #hide third weapon for low level
	#set cost for turrets
	get_node("hbox/towerPanel1-1/Label").text = str(Config.turret_cost[0])
	get_node("hbox/towerPanel1-2/Label").text = str(Config.turret_cost[1])
	get_node("hbox/towerPanel1-3/Label").text = str(Config.turret_cost[2])

func _on_mouse_exited(): #if mouse out, hide the crosshair
	if noresponse == 0:
		$crosshair1.hide()
	

func _on_mouse_entered(): #if mouse is in, show the crosshair
	if noresponse == 0:
		$crosshair1.show()
	

func _process(delta):
	if Config.level > 1: #if level >1 , show the third waapon
		get_node("hbox/towerPanel1-3").show()
	if $Timer.is_stopped() : #if timer is stopped, hide the weapon panel
		$hbox.hide()

func _on_gui_input(event):
	if noresponse == 0: #if installation is allowed
		if event is InputEventMouseButton and event.button_mask == 1: #if left button of mouse is pressed
			if DisplayServer.is_touchscreen_available(): #if device is mobile phone or pad with touch screen
				$crosshair1.show() #show the crosshair in 1.5 seconds, because no mouse action.
				$Timer2.stop()
				$Timer2.one_shot = true
				$Timer2.wait_time = 1.5
				$Timer2.start()
			$hbox.show() #show weapon panel in 2 seconds
			$Timer.one_shot = true
			$Timer.wait_time = 2
			$Timer.start()


func _on_timer_2_timeout(): #if timer2 is out, hide the crosshair
	$crosshair1.hide()
