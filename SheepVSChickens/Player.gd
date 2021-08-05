extends KinematicBody

# stats
var curHp : int = 10
var maxHp : int = 10
var ammo : int = 15
var score : int = 0

# physics
var moveSpeed : float = 5.0
var jumpForce : float = 7.0
var gravity : float = 12.0
var speed : float = 400.0

# cam look
var minlookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 0.5

# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

# player components
onready var camera = get_node("Camera")

onready var muzzle : Spatial = get_node("Camera/GunModel/Muzzle")
onready var bulletScene = load("res://Bullet.tscn")

onready var ui : Node = get_node("/root/MainScene/CanvasLayer/UI")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# hide and lock the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#set the UI
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(ammo)
	ui.update_score_text(score)


# called every physics step
func _physics_process(delta):
	
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	if Input.is_action_pressed('move_forward'):
		input.y -= 1
	if Input.is_action_pressed('move_backward'):
		input.y += 1
	if Input.is_action_pressed('move_left'):
		input.x -= 1
	if Input.is_action_pressed('move_right'):
		input.x += 1
		
	# get forward and right direction
	input = input.normalized()
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	# set the velocity
	vel.x = (forward * input.y + right * input.x).x * moveSpeed
	vel.z = (forward * input.y + right * input.x).z * moveSpeed
	
	# apply gravity
	vel.y -= gravity * delta
	
	# move the player 
	vel = move_and_slide(vel, Vector3.UP)
	
	# jump if we press the jump button and standing on the floor 
	if Input.is_action_pressed('jump') and is_on_floor():
		vel.y = jumpForce


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#rotate camera along x axis
	camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y), 0, 0) * lookSensitivity * delta
	# clamp the vertical camera rotation
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minlookAngle, maxLookAngle)
	#rotate player along y axis
	rotation_degrees -= Vector3(0, rad2deg(mouseDelta.x), 0) * lookSensitivity * delta
	#reset the mouse delta vector
	mouseDelta = Vector2()
	
	#check to see if we are shooting
	if Input.is_action_just_pressed("shoot") and ammo > 0:
		shoot()

# called when an input is detected
func _input(event):
	# did the mouse move?
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

# called when press the shoot button - spawn a new bullet
func shoot():
	var bullet = bulletScene.instance()
	get_node("/root/MainScene").add_child(bullet)
	bullet.add_central_force(-global_transform.basis.z * speed)
	bullet.global_transform = muzzle.global_transform
	bullet.scale = Vector3.ONE
	
	ammo -= 1

	$SheepSound.play()
	ui.update_ammo_text(ammo)

func take_damage (damageAttack):
	curHp -= damageAttack
	ui.update_health_bar(curHp, maxHp)
	if curHp <= 0:
		die()

#called when the health reaches 0
func die():
	pass
	get_tree().reload_current_scene() #stop the game when die

#called when we kill an enemy
func add_score (amount):
	score += amount
	ui.update_score_text(score)
	
#adds an amount of health to the player
func add_health (amount):
	curHp += amount
	ui.update_health_bar(curHp, maxHp)
	if curHp > maxHp:
		curHp = maxHp
	
	
#adds an amount of ammo to the player
func add_ammo (amount):
	ammo += amount	
	ui.update_ammo_text(ammo)
