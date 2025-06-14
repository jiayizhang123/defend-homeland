extends Panel

@onready var artillery = preload("res://turret/artillery.tscn") #preload the artillery for different turrets


func _on_gui_input(event):
	
	var tempArtillery = artillery.instantiate() #instantiate the artillery
	if "towerPanel1-1" in get_name(): #check which one i selected by its name, then set animation to show the turret
		tempArtillery.type = 1
		tempArtillery.get_node("artillery1").set_animation("shoot1-1")
	elif "towerPanel1-2" in get_name():
		tempArtillery.type = 2
		tempArtillery.get_node("artillery1").set_animation("shoot2-1")
	elif "towerPanel1-3" in get_name():
		tempArtillery.type = 3
		tempArtillery.get_node("artillery1").set_animation("shoot3-1")
		var shape = CircleShape2D.new() #turret #3 has larger attacking range 
		shape.set_radius(Config.turret3_range[0])
		tempArtillery.get_node("Tower/CollisionShape2D").shape = shape
	
	if event is InputEventMouseButton and event.button_mask == 1: #if left button fo the mouse is pressed
		if Config.score >= Config.turret_cost[(tempArtillery.type - 1)]: #check if player's score is enough 
			Config.score -= Config.turret_cost[(tempArtillery.type - 1)]
			# because a hsplictcontainer is used in another hspplitcontainer
			#set the new artillery in position in given place
			get_parent().get_parent().add_child(tempArtillery) 
			tempArtillery.global_position = get_parent().get_parent().global_position
			tempArtillery.global_position.x += 50
			tempArtillery.global_position.y += 38
			get_parent().get_parent().noresponse = 1
			get_parent().get_parent().get_node("hbox").hide()
		else: #if there is not enough score, play the ineffective sound
			get_node("/root/main/AudioStreamPlayer").play()
			
			

