class_name StateMachine extends Node

## Generic node-based state machine.
## Add BaseState children. The first child is the initial state.

signal state_changed(old_state: StringName, new_state: StringName)

var current_state: BaseState = null
var states: Dictionary = {}  # StringName -> BaseState
var _initialized: bool = false

func _ready() -> void:
	# Collect all BaseState children
	for child in get_children():
		if child is BaseState:
			states[child.name] = child
	# Set initial state to first child
	if states.size() > 0:
		current_state = states.values()[0]
	_initialized = true

func _process(delta: float) -> void:
	if current_state == null:
		return
	var next = current_state.update(delta)
	if next != &"":
		transition_to(next)

func _physics_process(delta: float) -> void:
	if current_state == null:
		return
	var next = current_state.physics_update(delta)
	if next != &"":
		transition_to(next)

func _unhandled_input(event: InputEvent) -> void:
	if current_state == null:
		return
	var next = current_state.handle_input(event)
	if next != &"":
		transition_to(next)

func transition_to(state_name: StringName, data: Dictionary = {}) -> void:
	if not states.has(state_name):
		push_warning("StateMachine: state '%s' not found" % state_name)
		return
	if current_state != null:
		current_state.exit()
	var old_name = current_state.name if current_state else &""
	current_state = states[state_name]
	current_state.enter(data)
	state_changed.emit(old_name, state_name)

func get_state() -> StringName:
	return current_state.name if current_state else &""
