extends KinematicBody

#stats
var health : int = 100
var moveSpeed : float = 1.0

#attacking
var damageAttack : int = 1
var attackRate : float = 1.0
var attackDist : float = 2.0

var scoreToGive : int = 10

#components
onready var player : Node = get_node("/root/MainScene/Player")
onready var timer : Timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	#setup the timer
	timer.set_wait_time(attackRate)
	timer.start()
	$ChickenSound.play()


func _physics_process(_delta):
	#calculate direction to the player
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	#move the enemy towards the player
	
	dir = move_and_slide(dir * moveSpeed, Vector3.UP)
	look_at(player.global_transform.origin, Vector3.UP)
	

func take_damageToEnemy(damageBullet):
	health -= damageBullet
	print(health)
	if health <= 0:
		die()

func die ():
	queue_free()
	player.add_score(scoreToGive)
	
	
#deals demage to the player
func attack ():
	player.take_damage(damageAttack)
	print("enemy attacking")


func _on_Timer_timeout():
	#if we are at the right distance, attack the player
	if translation.distance_to(player.translation) <= attackDist:
		attack()


