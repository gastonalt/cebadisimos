# Guía: Máquina de Estados + Armas acoplables

Cómo está armado el personaje y cómo editarlo sin romper nada.

---

## 1. La idea general

El personaje ya NO decide sus animaciones con un montón de `if`. Tiene un nodo
`StateMachine` con un nodo hijo **por cada estado** (Idle, Walk, Jump, Fall,
Crouch, Slide, Death). Solo UN estado está activo a la vez → las animaciones
nunca se pisan, porque cada una vive en su propio script.

```
Personaje (CharacterBody2D)          ← personaje.gd: física base, constantes, squash
├── Body / BodySprite                ← AnimatedSprite2D del cuerpo (32x32)
├── RightHand  (Marker2D)            ← punto donde se acopla el arma
├── LeftHand   (Marker2D)
└── StateMachine                     ← state_machine.gd (el "director")
    ├── Idle                         ← idle_state.gd
    ├── Walk                         ← walk_state.gd
    └── ...                          ← cada uno hereda BaseState
```

## 2. Cómo funciona

**`base_state.gd`** define los métodos virtuales que cada estado puede override:

| Método | Cuándo se llama | Qué devuelve |
|---|---|---|
| `enter(data)` | al ENTRAR al estado | nada |
| `exit()` | al SALIR | nada |
| `update(delta)` | cada frame | `&"OtroEstado"` o `&""` |
| `physics_update(delta)` | cada frame de física | `&"OtroEstado"` o `&""` |
| `handle_input(event)` | al tocar una tecla | `&"OtroEstado"` o `&""` |

**La regla de oro**: si `physics_update` devuelve el nombre de otro estado,
la máquina cambia solo. Si devuelve `&""`, seguimos en este estado.

```gdscript
func physics_update(delta):
    if Input.is_action_just_pressed("p1_jump"):
        return &"Jump"      # ← la máquina hace exit() aquí y enter() allá
    return &""              # ← sigo siendo Walk
```

## 3. Agregar un estado nuevo (ejemplo: Dash)

1. Crear `scripts/state_machine/personaje/dash_state.gd`:

```gdscript
extends BaseState

@onready var body_sprite: AnimatedSprite2D = $"../../Body/BodySprite"

const DASH_SPEED = 800.0
var _timer := 0.0

func enter(_data := {}) -> void:
    _timer = 0.15                      # dura 0.15 segundos
    body_sprite.play("dash")           # tu animación en personaje.tscn
    owner.velocity.x = owner.body_node.scale.x * DASH_SPEED

func physics_update(delta) -> StringName:
    _timer -= delta
    if not owner.is_alive:
        return &"Death"
    if _timer <= 0.0:
        return &"Idle"                 # o Fall si no está en piso
    return &""

func exit() -> void:
    body_sprite.speed_scale = 1.0
```

2. En Godot, abrir `personaje.tscn` → seleccionar `StateMachine` → agregar
   hijo Node → nombrarlo `Dash` → asignarle el script.
   El orden importa: **el primer hijo es el estado inicial**.

Listo. Los demás estados pueden llegar con `return &"Dash"`.

## 4. Ajustar velocidad / animaciones

Constantes en `personaje.gd`:

| Constante | Valor | Qué es |
|---|---|---|
| `SPEED` | 400 | velocidad caminando |
| `CROUCH_SPEED` | 160 | agachado |
| `ACCELERATION` | 2400 | qué tan rápido alcanza SPEED |
| `JUMP_VELOCITY` | -700 | fuerza del salto |

- **Animación adaptativa**: en `walk_state.gd`, la línea
  `body_sprite.speed_scale = clampf(...)` hace que el muñeco anime más rápido
  cuanto más rápido corre. Cambiá `0.6`/`1.6` para los límites.
- Para editar frames/fps de una animación: abrir `personaje.tscn` →
  `BodySprite` → SpriteFrames en el inspector (o menú Animations abajo).

## 5. Manos estilo Scribblenauts

En `personaje.tscn` hay dos `Marker2D`: `RightHand` y `LeftHand`.
Cuando un arma entra al árbol, su script (`weapon_base.gd`) hace:

```gdscript
position = -right_grip.position   # empuja el arma hasta que SU grip cae EN tu mano
```

Es decir: **cada arma trae su propio marker `RightGripPoint`**, y el acople es
automático sin importar el tamaño del sprite. Por eso pistola, escopeta y
pistola_2 quedan bien tomadas aunque midan distinto.

Si un arma queda mal ubicada: mover su marker `RightGripPoint` en la escena
del ARMA (no del personaje). Ese punto debe coincidir visualmente con la
empuñadura.

## 6. Crear un arma nueva (checklist)

1. Sprites en `sprites/armas/<nombre>/frame_NN.png`.
2. Script `scripts/<nombre>.gd` copiando `pistola.gd` (hereda `WeaponBase`,
   define `_on_fire()`).
3. Escena `scenes/<nombre>.scn` copiando `pistola_2.tscn`:
   - `WeaponSprite` (idle) + `FireEffect` (animación de disparo)
   - Markers: `MuzzlePoint`, `EjectionPoint`, `RightGripPoint`
   - `StateMachine` con hijos `Idle` y `Fire`
4. Conectar señal `FireEffect.animation_finished → _on_fire_effect_finished`.
5. Registrar en `caja_con_arma.gd`: `4: weapon_scene = load(...)`.
   Y poner esa caja en el nivel con `tipo_arma = 4`.

Mapeo actual: **1** = pistola · **2** = escopeta · **3** = pistola_2

## 7. Archivos por si querés mirar

| Archivo | Qué hace |
|---|---|
| `scripts/personaje.gd` | física, constantes, squash & stretch |
| `scripts/state_machine/state_machine.gd` | el director de orquesta (55 líneas) |
| `scripts/state_machine/base_state.gd` | plantilla de estado |
| `scripts/weapons/weapon_base.gd` | clase madre de armas (anclas, manos, disparo) |
| `scenes/pistola_2.tscn` | ejemplo más completo de arma |
