extends StaticBody2D

var shell = preload("res://turret/shell.tscn") #preload the shell/missile
var pathName #enemy's path
var targets = [] #set the target array for enemies
var audio_player #set the audio for shooting
var shootTimer = Config.shootTimer1 #set the timer for shooting speed
var upgrade = 1 #set the grade of artillery/turret
var type = 1  #set the type of artillery/turret

var towerpanel #used for ungrade to grade 2
var towerpanel1 #used for ungrade to grade 3
var	towerdismantle = preload("res://turret/tower_dismantle.tscn") #preload the panel for dismantling
@onready var shootSound =load('res://turret/asset/Shoot_2.wav') #preload the sound of shooting

func _ready():
	audio_player = AudioStreamPlayer.new() #add instance for audio player
	self.add_child(audio_player)  
	audio_player.stream = shootSound 
	$Node2D/hbox2.hide() #hide the weapon upgarde panel at start
		
func _process(delta):
	if targets: #if there exist targets, then shoot
		self.look_at(targets.front().get_parent().global_position) #look at first target
		pathName = targets.front().get_parent().get_parent().name #get first target's path name 
		if $Timer.is_stopped() and pathName != null: #keep control of the shooting speed
			shoot()
			$Timer.one_shot = true
			$Timer.wait_time = shootTimer
			$Timer.start()
	else: #if there is no target, clear the shells in shell container
		if get_node("shellContainer") != null:
			for i in get_node("shellContainer").get_child_count():
				get_node("shellContainer").get_child(i).queue_free()

func shoot(): #shoot a shell
	
	$artillery1.play("shoot" + str(type) + "-" + str(upgrade)) #play shooting animation
	
	var tempShell = shell.instantiate() #create an instance of shell
	tempShell.shellType(type) #set the type of shell
	tempShell.pathName = pathName #set the target path
	tempShell.shellType1 = type #shelltype1 indicates the shocking shell to slow the enemy
	tempShell.shellDamage = Config.shellDamage[(upgrade-1)] #set the damage in terms of artillery/turret grade
	if type == 2: #artillery/turret #2 shoots shocking shell
		tempShell.shellDamage = int(Config.shellDamage[(upgrade-1)]/3)
		tempShell.slowEnemy = Config.shellSlowenemy[(upgrade-1)]
	if upgrade == 3: #shell of artillery/turret #3 changes the shape of shell
		tempShell.changeShell(type)
	get_node("shellContainer").add_child(tempShell) #add a shell into shell container
	#set the shell's starting position at the muzzle of artillery/turret
	tempShell.global_position = $Muzzle.global_position
	audio_player.play() #play shooting sound

func _on_tower_body_entered(body): #if a enemy enters into range, then add it into targets array
	if "enemy" in body.name:
		if not body in targets: #if this one is not exsted in targets array, then add it
			targets.append(body)
			

func _on_tower_body_exited(body): #if a enemy leave the range, then delete it from targets array
	if body in targets:
		targets.erase(body)
	
func _on_a_panel_gui_input(event): #weapon ungrade panel is activated
	var str2 = "res://turret/tower_panel2-" + str(type) + ".tscn" #used to preload related type of artillery/turret #2
	var str3 = "res://turret/tower_panel3-" + str(type) + ".tscn" #used to preload related type of artillery/turret #3
	towerpanel = load(str2)
	towerpanel1 = load(str3)	
	
	if event is InputEventMouseButton and event.button_mask == 1: #if left button of mouse is pressed 
		#first , clear all the previous upgrade list of weapons
		for i in get_node("Node2D/hbox2").get_child_count():
			get_node("Node2D/hbox2").get_child(i).queue_free()
		#add the new ungrade list of weapons according to the grade of artillery/turret
		if upgrade < 3: #if grade<3, show upgrade panel
			var temptowerpanel
			if upgrade == 2: #if grade=2, then show upgrade panel 3
				temptowerpanel = towerpanel1.instantiate()
			else:
				temptowerpanel = towerpanel.instantiate()
			get_node("Node2D/hbox2").add_child(temptowerpanel)
			#preset the cost of upgrade
			temptowerpanel.get_node("Label").text = str(Config.turret_upgrade[(type-1)])
		#add dismantle panel at the end of weapon upgrade panel
		var temptowerdismantle = towerdismantle.instantiate()
		#preset the return of dismantle
		temptowerdismantle.get_node("Label").text = str(Config.turret_cost[type-1])
		get_node("Node2D/hbox2").add_child(temptowerdismantle)
		$Node2D/hbox2.show() #show the weapon upgrade panel
	
		get_node("Tower/CollisionShape2D").show() #show the attacking range in Timer2's time
		$Timer2.one_shot = true
		$Timer2.wait_time = 1.5
		$Timer2.start()
	#if the left button of mouse is released, hide the attacking range
	if event is InputEventMouseButton and event.button_mask == 0:
		get_node("Tower/CollisionShape2D").hide()
	
#hide the upgarde panel when time is over
func _on_timer_2_timeout():
	$Node2D/hbox2.hide()
