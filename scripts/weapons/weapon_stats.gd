class_name WeaponStats extends Resource

## Editable weapon configuration resource.
## Create new instances in the FileSystem dock: Right-click > New Resource > WeaponStats.

enum FireMode { SINGLE, BURST, AUTO }

@export var weapon_name: String = ""
@export var damage: int = 1
@export var cooldown_time: float = 0.3
@export var knockback_force: float = 150.0
@export var bullet_speed: float = 600.0
@export var spread: float = 0.0
@export var ammo: int = -1           ## -1 = infinite
@export var max_ammo: int = -1       ## -1 = infinite
@export var reload_time: float = 1.0
@export var fire_mode: FireMode = FireMode.SINGLE
@export var bullet_scene: PackedScene
@export var fire_scene: PackedScene  ## optional per-weapon muzzle scene
