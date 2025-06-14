extends CharacterBody2D

var speed = Config.enemySpeed[Config.level-1] #set enemy's speed in terms of game level

var health = 0 #preset the health

var death_f #status of death

var progressBarTime = 3 #used to show the health's strength

func _ready():
	#set the health
	health = int(Config.waveb[((Config.level-1)*Config.default_wave+Config.wave -1)] * (1+Config.waveb_ai_ratio))
	death_f = false
	$AnimatedSprite2D.flip_h = true #flip the direction in terms of picture of enemy
	#show different type of enemy in terms of level and wave
	if Config.level == 1:
		if Config.wave == 1 :
			$AnimatedSprite2D.set_animation("bat")
		if Config.wave == 2 :
			$AnimatedSprite2D.set_animation("crab")
		if Config.wave == 3 :
			if "PathFollow2D1a" in get_parent().name:
				if Config.wave_n == 1:
					$AnimatedSprite2D.set_animation("goblin")
					health = Config.waveb_boss[(Config.level-1)]
				else:
					$AnimatedSprite2D.set_animation("bat")
			if "PathFollow2D1b" in get_parent().name:
				$AnimatedSprite2D.set_animation("crab")
	elif Config.level == 2:
		if Config.wave == 1 :
			$AnimatedSprite2D.set_animation("turnip")
		if Config.wave == 2 :
			$AnimatedSprite2D.set_animation("zombie")
		if Config.wave == 3 :
			if "PathFollow2D2a" in get_parent().name:
				if Config.wave_n == 1:
					$AnimatedSprite2D.set_animation("skelleton")
					health = Config.waveb_boss[(Config.level-1)]
				else:
					$AnimatedSprite2D.set_animation("turnip")
			if "PathFollow2D2b" in get_parent().name:
				$AnimatedSprite2D.set_animation("zombie")
	$ProgressBar.max_value = health #show the progressbar
	$ProgressBar.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#move the enemy in terms of its speed
	get_parent().set_progress(get_parent().get_progress() + speed * delta)
	#hide the progressbar when timer is out
	if $Timer.is_stopped() :
		$ProgressBar.hide()
	if $Timer2.is_stopped() : #recover the speed after timer2 is out when hit by a shocking shell
		speed =  Config.enemySpeed[Config.level-1]
	#if enemy invade the home
	if get_parent().get_progress_ratio() == 1 and !death_f:
		death() #clear the enemy
		get_node("/root/main").intrude($AnimatedSprite2D.get_animation()) #call the function of 
	if health <= 0 and !death_f:
		var eName = $AnimatedSprite2D.get_animation()
		death()
		# get reward from killing an enemy
		if Config.wave == 3 and (eName == "goblin" or eName == "skelleton"):
			Config.score += Config.wavec_boss[(Config.level-1)] #boss
		else:
			Config.score += Config.wavec[((Config.level-1)*Config.default_wave+Config.wave-1)]
		
# release the enemy
func death():
	death_f = true
	$AnimatedSprite2D.set_animation("explosion")
	$AnimatedSprite2D.play("explosion")
	await $AnimatedSprite2D.animation_finished
	get_parent().get_parent().queue_free()
	Config.progress_ratio_wave.append(get_parent().get_progress_ratio())

# show the progressbar of health
func timer1():
	if $Timer.is_stopped():
		$ProgressBar.show()
		$Timer.one_shot = true
		$Timer.wait_time = progressBarTime
		$Timer.start()


