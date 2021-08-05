extends Area

enum PickupType {
	Health,
	Ammo
}

#stats
export(PickupType) var type = PickupType.Health
export var amount : int = 10

#bobbing
onready var startYPos : float = translation.y
var bobHeight : float = 1.0
var bobSpeed : float = 1.0
var bobbingUp : bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move us up or down
	translation.y += (bobSpeed if bobbingUp else -bobSpeed) * delta
	#if we are at the top, start moving downwards
	if bobbingUp and translation.y > startYPos + bobHeight:
		bobbingUp = false
	#if we are at the bottom, start moving up	
	elif !bobbingUp and translation.y < startYPos:
		bobbingUp = true

#called when another body enters our collider
func _on_Pickup_body_entered (body):
	#did the player enter our collider?
	#if so giv the stats and destroy the pickup
	if body.name == "Player":
		pickup(body)
		#queue_free()

#called when the player enters the pickup
#give them appropriate stat
func pickup (player):
	
	if type == PickupType.Health:
		player.add_health (amount)
		print("health")

	if type == PickupType.Ammo:
		player.add_ammo (amount)
		print("ammo")