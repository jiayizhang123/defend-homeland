extends Panel


func _on_gui_input(event): #upgrade type 1 turret to grade 2  
	if event is InputEventMouseButton and event.button_mask == 1:
		if Config.score >= Config.turret_upgrade[0]:  #check if player's score is enough 
			Config.score -= Config.turret_upgrade[0]
			get_parent().get_parent().get_parent().get_node("artillery1").play("shoot1-2")
			get_parent().get_parent().get_node("hbox2").hide()
			get_parent().get_parent().get_parent().upgrade = 2
		else: #if there is not enough score, play the ineffective sound
			get_node("/root/main/AudioStreamPlayer").play()
		
