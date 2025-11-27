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
	
	#Alguma coisa
	# Criar o emoji do inimigo - Teste
	var enemy = Label.new()
	enemy.text = "👾"
	enemy.add_theme_font_size_override("font_size", 48)
	
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
