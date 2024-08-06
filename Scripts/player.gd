extends CharacterBody3D


const SPEED = 5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var smooth_animation := Vector2()
var target: CharacterBody3D = null
var attack_range = 2.0

@onready var animation_player: AnimationPlayer = $mesh/AnimationPlayer





func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0
	
	if Input.is_action_just_pressed("attack"):
		target = _get_closest_enemy()
		if target:
			_attack()
			print_debug("atacar inimigo")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal_rotation = $camera/horizontal.global_transform.basis.get_euler().y
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, horizontal_rotation)
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$mesh.rotation.y = lerp_angle($mesh.rotation.y, atan2(-direction.x, -direction.z), delta * 5)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	smooth_animation = lerp(smooth_animation, input_dir, delta * 10)

	move_and_slide()
	
	
func _get_closest_enemy():
	var closest_distance = INF
	var closest_enemy = null
	var enemies = get_tree().get_nodes_in_group("Enemies")
	
	for enemy in enemies:
		var distance = global_transform.origin.distance_to(enemy.global_transform.origin)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
			
	return closest_enemy
		
func _move_towards_target(delta):
	if target:
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		var movement = direction * SPEED * delta
		move_and_slide()
		
func _attack():
	if target:
		var distance_to_target = global_transform.origin.distance_to(target.global_transform.origin)
		if distance_to_target <= attack_range:
			$mesh/AnimationPlayer.play("attack")
			target.take_damage(10)
		else:
			_move_towards_target(get_process_delta_time())
	
