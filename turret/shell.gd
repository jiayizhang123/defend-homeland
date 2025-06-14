extends CharacterBody2D

var target #position of target
var Speed = Config.shellSpeed
var pathName = "" #target's path
var shellDamage
var shellType1 #missile or shocking shell
var slowEnemy #amount of reduced speed

func _physics_process(delta):
	
	#locate the pathSpawner to find the target
	target = null
	var pathSpawnerNode = get_tree().get_root().get_node("main/pathSpawner")
	for i in pathSpawnerNode.get_child_count():
		if pathSpawnerNode.get_child(i).name == pathName:
			#find the target and get the position of enemy under pathfollow2D under path2D
			target = pathSpawnerNode.get_child(i).get_child(0).get_child(0).global_position
	if target != null: #check if target is null in case this enemy is eliminated
		velocity = global_position.direction_to(target) * Speed # set the shell's direction and speed
		look_at(target) #look at the target
		move_and_slide() #collision response
	else:
		queue_free()
	#if collision then bounce	
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null:
			velocity = velocity.bounce(collision.get_normal())

func shellType(t): #show different tyoe of shells
	if t == 2:
		$Sprite2D.hide()
		$Sprite2D1.hide()
		$Sprite2D2.show()
		$Sprite2D3.hide()
	else:
		$Sprite2D.show()
		$Sprite2D1.hide()
		$Sprite2D3.hide()
		$Sprite2D3.hide()

func changeShell(t): #show different tyoe of shells when artillery/turret in grade 3
	if t == 2:
		$Sprite2D.hide()
		$Sprite2D1.hide()
		$Sprite2D2.hide()
		$Sprite2D3.show()
	else:
		$Sprite2D.hide()
		$Sprite2D1.show()
		$Sprite2D3.hide()
		$Sprite2D3.hide()

func _on_area_2d_body_entered(body): #if an object is collided
	if "enemy" in body.name: #if this object is an enemy
		if body.has_method("timer1"): #show the health progressbar of the enemy in 3 seconds
			body.timer1()
		
		if shellType1 == 2: #if the shell is a shocking shell, slow the enemy's speed in seconds
			body.get_node("Timer2").stop()
			body.get_node("Timer2").one_shot = true
			body.get_node("Timer2").wait_time = Config.enemySlowTimer
			body.get_node("Timer2").start()
			body.speed = Config.enemySpeed[Config.level-1] - slowEnemy
			body.health -= shellDamage
		else: #else decrease the health's enemy in terms of the shell's damage
			body.health -= shellDamage
		queue_free() #release the shell 

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the shell when it exits the screen:
	queue_free()

