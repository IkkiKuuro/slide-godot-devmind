extends BaseSlide

## Slide 23 - Spawn de inimigos com Timer

var enemy_count = 0
const MAX_ENEMIES = 5
var spawn_timer: Timer
var sprite_frames: SpriteFrames

func setup_slide():
	# Carregar as animações
	sprite_frames = load("res://assets/Animations/Sprite_animations.tres")
	
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
	sprite.sprite_frames = sprite_frames
	sprite.animation = "Inimigo"
	sprite.play()
	sprite.scale = Vector2(2, 2)  # Aumentar tamanho do goomba
	enemy.add_child(sprite)
	
	# Posição aleatória na tela
	var screen_size = get_viewport_rect().size
	var random_x = randf_range(100, screen_size.x - 100)
	var random_y = randf_range(200, screen_size.y - 100)
	
	enemy.position = Vector2(random_x, random_y)
	enemy.modulate.a = 0
	
	# Velocidade aleatória (esquerda ou direita)
	var speed = randf_range(50, 150)
	if randf() > 0.5:
		speed = -speed
	
	# Flip horizontal baseado na direção (invertido)
	if speed > 0:
		sprite.flip_h = true
	
	enemy.set_meta("speed", speed)
	
	add_child(enemy)
	
	# Animação de entrada
	var tween = create_tween()
	tween.tween_property(enemy, "modulate:a", 1.0, 0.5)
	
	enemy_count += 1

func _process(delta):
	# Mover todos os inimigos
	for child in get_children():
		if child is CharacterBody2D and child.has_meta("speed"):
			var speed = child.get_meta("speed")
			child.position.x += speed * delta
			
			# Inverter direção nas bordas
			var screen_width = get_viewport_rect().size.x
			if child.position.x < 50 or child.position.x > screen_width - 50:
				speed = -speed
				child.set_meta("speed", speed)
				var sprite = child.get_node("AnimatedSprite2D")
				# Flip baseado na nova direção (invertido)
				sprite.flip_h = speed > 0

func _exit_tree():
	# Limpar quando sair do slide
	if spawn_timer:
		spawn_timer.queue_free()
