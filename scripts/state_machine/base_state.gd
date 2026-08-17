class_name BaseState extends Node

## Virtual methods — override in each state subclass.

## Called when entering this state. data is a Dictionary with arbitrary context.
func enter(_data: Dictionary = {}) -> void:
	pass

## Called when exiting this state.
func exit() -> void:
	pass

## Called every _process frame. Return a State name (StringName) to transition, or &"" to stay.
func update(_delta: float) -> StringName:
	return &""

## Called every _physics_process frame. Return a State name to transition, or &"" to stay.
func physics_update(_delta: float) -> StringName:
	return &""

## Called when an input event occurs. Return a State name to transition, or &"" to stay.
func handle_input(_event: InputEvent) -> StringName:
	return &""
