extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var player_size
var orientation = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size

func _process(delta):
	# Movement
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		orientation = velocity
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO+player_size/2, screen_size-player_size/2)
	
	# Rotation based on movement
	$AnimatedSprite2D.rotation = orientation.angle() + PI/2
	
	# Animation
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"

func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
