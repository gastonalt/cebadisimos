extends CharacterBody2D
## @onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite: Sprite2D = $Sprite2D  # o Sprite2D si no usás animaciones

@export var player_id: int = 1  # 1 o 2 según el jugador

## @export var canShoot = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	var path = "res://player%d.png" % player_id
	var tex = load(path)
	sprite.texture = tex

func _physics_process(delta: float) -> void:
	var prefix = "p%d_" % player_id  # con esto genero p1_ o p2_ para escuchar las teclas
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
##	if velocity.y != 0:
##		anim.play("jump")
##	else:
##		anim.play("iddle")
	# Handle jump.
	if Input.is_action_just_pressed(prefix + "jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(prefix + "left", prefix + "right")
	var arma_holder = get_node("arma_holder")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = (direction != 1)
		arma_holder.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
##	if Input.is_key_pressed(KEY_G) and canShoot:
##		pass

	move_and_slide()
