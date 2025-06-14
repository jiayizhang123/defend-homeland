extends Panel


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_mask == 1:
		get_parent().get_parent().get_parent().get_parent().noresponse = 0
		get_parent().get_parent().get_node("hbox2").hide()
		get_parent().get_parent().get_parent().queue_free()
		
		Config.score += Config.turret_dismantle[(get_parent().get_parent().get_parent().type - 1)]
		
