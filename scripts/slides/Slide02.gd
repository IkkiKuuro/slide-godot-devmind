extends Node

@onready var button = $"../MarginContainer/VBoxContainer/InteractiveExample/ClickMeButton"
@onready var character = $"../MarginContainer/VBoxContainer/InteractiveExample/Character"
@onready var animated_sprite = character.get_node("AnimatedSprite2D")
@onready var fps_counter = $"../MarginContainer/VBoxContainer/FPSCounter"

var original_position: Vector2

func _ready():
	button.pressed.connect(_on_button_pressed)
	original_position = character.position
	animated_sprite.play("idle_02")

func _process(_delta):
	fps_counter.text = "FPS: %d" % Engine.get_frames_per_second()

func _on_button_pressed():
	# Troca para animação de pulo
	animated_sprite.play("jump-fall_01")
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	# Subir
	tween.tween_property(character, "position:y", character.position.y - 100, 0.3)
	# Descer
	tween.tween_property(character, "position:y", original_position.y, 0.3)
	# Quando terminar, volta para idle_02
	tween.tween_callback(Callable(animated_sprite, "play").bind("idle_02"))
