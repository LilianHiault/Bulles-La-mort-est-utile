extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var move_speed := 200
export var gravity := 500
export var jump_speed := 100

export var spawn_platform = Vector2.ZERO
export var spawn_character = Vector2.ZERO

export var deaths :=0

var velocity := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_character= get_parent().spawn_player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_animation()

func change_animation():
	# face left or right
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	if velocity.y < 0:
		$AnimatedSprite.play("jump")
	else:
		if velocity.x != 0:
			$AnimatedSprite.play("run")
		else:
			$AnimatedSprite.play("idle")

func _physics_process(delta):
	# reset horizontal velocity
	velocity.x = 0
	if self.is_on_floor():
		spawn_platform.y = int(self.position.y +26)
		spawn_platform.x = int(self.position.x)
	
	if position.y >= 270:
		 dies()
	# set horizontal velocity
	
	if Input.is_action_pressed("move_right"):
		velocity.x += move_speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= move_speed
	# Apply gravity -> downward velocity
	velocity.y += gravity * delta
	
	# jump on the next frame
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			$JumpSound.play()
			velocity.y = -jump_speed
	
	
	# move player
	velocity = move_and_slide(velocity, Vector2.UP)

func dies():
	$DeathSound.play()
	deaths +=1
	spawn_platform.x = 0.25 * spawn_platform.x + 0.75* self.position.x
	get_parent().add_Bulle(spawn_platform)
	position = spawn_character
	Events.emit_signal("score_changed",deaths)
	
