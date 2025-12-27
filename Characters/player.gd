extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -300.0
@export var double_jump_velocity: float = -250.0
var has_double_jumped = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var animation_locked: bool = false
var direction: Vector2 = Vector2.ZERO
var was_in_air: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		has_double_jumped = false
		if was_in_air:
			land()
		was_in_air = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			jump()
		elif !has_double_jumped:
			velocity.y = double_jump_velocity
			has_double_jumped = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction= Vector2(Input.get_axis("ui_left", "ui_right"),
	Input.get_axis("ui_up", "ui_down"))
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	update_facing_direction()
	update_animation()
	move_and_slide()
	
func update_animation():
	if not animation_locked:
		if direction != Vector2.ZERO:
			animated_sprite.play("run")
		else:
			animated_sprite.play("Idle")
		

func update_facing_direction():
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
		
func jump():
	velocity.y = JUMP_VELOCITY
	was_in_air = true
	animated_sprite.play("jump_start")
	animation_locked = true
	
func land():
	animated_sprite.play("jump_end")
	animation_locked = true


func _on_animated_sprite_2d_animation_finished() -> void:
	animation_locked = false
