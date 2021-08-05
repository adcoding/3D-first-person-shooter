extends RigidBody

var speed : float = 500.0
var damageBullet: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(2) # more is better but more costly


func _on_Bullet_body_entered(body):
	if body.has_method('take_damageToEnemy'):
		body.take_damageToEnemy(damageBullet)
		#destroy()
	

func destroy():
	queue_free()




