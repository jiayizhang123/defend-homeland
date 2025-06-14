extends Node

var default_score = 200
var default_hitpoints = 10
var default_wave = 3 #number of wave in each level
var score = default_score #set default score at start
var hitpoints = default_hitpoints #home's health
var gameover = 0 #flag of game result

var level = 1 #start from level 1
var wavea = [20,30,30,40,40,50] #number of enemies in each wave
var waveb = [10,15,20,20,25,30] #health of enemy in each wave
var wavec = [10,10,15,15,15,20] #reward of killing enemy in each wave
var waveb_boss = [100,150] #health of boss in each level
var wavec_boss = [100,150] #reward of killing boss in each level
var waveb_ai_ratio = 0.0
var progress_ratio_wave = []
var homex = [852,992] #home position.x in level 1,2
var homey = [56,432] #home position.y in level 1,2
#var home = [homex, homey]
var fingerx = [365,88] #finger position.x in level 1,2
var fingery = [296,552] #finger position.y in level 1,2
var installLocation_n = 5 #number of installation place for turret in a level 
var installLocationx = [816,555,249,938,678,752,520,208,672,296] #installation position.x in level 1,2
var installLocationy = [405,441,460,216,46,288,272,416,48,184] #installation position.y in level 1,2
#var installLocation = [installLocationx, installLocationy]
var wave_n = wavea[0] #wave number
var enemySlowTimer = 3 #timer for slowed enemy
var wave = 1 #wave start from 1

var turret_cost = [50,60,100] #installation cost for type 1,2,3
var turret_upgrade = [40,50,60] #upgrade cost for type 1,2,3
var turret_dismantle = [50,60,100] #dismantling return for type 1,2,3
var turret_range = 200 #default range
var turret3_range = [248, 278, 308] #type 3 turret range for grade 1,2,3

var enemySpeed =[100,150] #enemy speed for level 1,2

var shellDamage = [4,6,8] #grade1, grade2, grade3
var shellSpeed = 600 #shell speed

var shootTimer1 = 1 #default shoot speed timer
var shootTimer2 = 0.5 #faster shoot speed timer for grade 3 turret 
var shellSlowenemy = [25,40,60] #slow degree of type 2 turret for grade 1,2,3
