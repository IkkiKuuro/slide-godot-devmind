extends BaseSlide

## Slide 23 - Spawn de inimigos com Timer

var enemy_count = 0
const MAX_ENEMIES = 10
var spawn_timer: Timer

func setup_slide():
	# Criar e configurar o Timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 2.0
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	if enemy_count >= MAX_ENEMIES:
		spawn_timer.stop()
		return
	
	# Criar CharacterBody2D para o inimigo
	var enemy = CharacterBody2D.new()
	enemy.name = "Enemy" + str(enemy_count)
	
	# Criar AnimatedSprite2D como filho
	var sprite = AnimatedSprite2D.new()
	sprite.name = "AnimatedSprite2D"
	enemy.add_child(sprite)
	
	# Posição aleatória na tela
	var screen_size = get_viewport_rect().size
	var random_x = randf_range(100, screen_size.x - 100)
	var random_y = randf_range(100, screen_size.y - 100)
	
	enemy.position = Vector2(random_x, random_y)
	enemy.modulate.a = 0
	
	add_child(enemy)
	
	# Animação de entrada
	var tween = create_tween()
	tween.tween_property(enemy, "modulate:a", 1.0, 0.5)
	
	enemy_count += 1

func _exit_tree():
	# Limpar quando sair do slide
	if spawn_timer:
		spawn_timer.queue_free()
