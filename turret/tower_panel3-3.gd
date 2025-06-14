extends Panel


func _on_gui_input(event): #upgrade type 3 turret to grade 3 
	if event is InputEventMouseButton and event.button_mask == 1:
		if Config.score >= Config.turret_upgrade[2]: #check if player's score is enough 
			Config.score -= Config.turret_upgrade[2]
			get_parent().get_parent().get_parent().get_node("artillery1").play("shoot3-3")
			get_parent().get_parent().get_node("hbox2").hide()
			get_parent().get_parent().get_parent().upgrade = 3
			#upgrade shooting speed
			get_parent().get_parent().get_parent().shootTimer = Config.shootTimer2
			var shape = CircleShape2D.new() #set larger range
			shape.set_radius(Config.turret3_range[2])
			get_parent().get_parent().get_parent().get_node("Tower/CollisionShape2D").shape = shape
		else: #if there is not enough score, play the ineffective sound
			get_node("/root/main/AudioStreamPlayer").play()
