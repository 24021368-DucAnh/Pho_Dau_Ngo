extends Node3D

# Runtime-built stylized art slice. Primitive meshes are intentional blockout assets:
# no external downloads, licenses, or Blender files are required to run this scene.

func _ready() -> void:
	_build_environment()
	_build_alley()
	_build_cart()
	_build_food_props()
	_build_stools_and_shopfront()

func _build_environment() -> void:
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#aebbb3")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#d7cbb5")
	env.ambient_light_energy = 0.42
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_exposure = 0.9
	world.environment = env
	add_child(world)

	var sun := DirectionalLight3D.new()
	sun.name = "MorningSun"
	sun.rotation_degrees = Vector3(-42.0, -28.0, 0.0)
	sun.light_color = Color("#f5d9ad")
	sun.light_energy = 0.78
	sun.shadow_enabled = true
	add_child(sun)

	var fill := OmniLight3D.new()
	fill.name = "StallWarmFill"
	fill.position = Vector3(-2.5, 3.1, -0.2)
	fill.light_color = Color("#e9bd88")
	fill.light_energy = 0.38
	fill.omni_range = 5.0
	add_child(fill)

func _build_alley() -> void:
	_box("AlleyFloor", Vector3(14, 0.2, 13), Vector3(0, -0.1, -1.5), Color("#898579"))
	_box("BackLimewash", Vector3(14, 4.5, 0.25), Vector3(0, 2.15, -7.0), Color("#d8ccb5"))
	_box("LeftLimewash", Vector3(0.25, 4.5, 13), Vector3(-7.0, 2.15, -1.5), Color("#c8b99e"))
	_box("RightLimewash", Vector3(0.25, 4.5, 13), Vector3(7.0, 2.15, -1.5), Color("#d4c6ac"))
	# Painted repair patches break up the walls without adding texture dependencies.
	_box("WallRepairA", Vector3(1.7, 0.8, 0.03), Vector3(-4.2, 1.1, -6.84), Color("#b7a58a"))
	_box("WallRepairB", Vector3(2.2, 0.55, 0.03), Vector3(3.3, 2.7, -6.84), Color("#c4b397"))
	_box("DrainChannel", Vector3(0.18, 0.025, 10.0), Vector3(4.7, 0.015, -1.4), Color("#5b5a50"))

func _build_cart() -> void:
	# Cart body and green enamel panels.
	_box("CartBody", Vector3(2.65, 1.0, 1.25), Vector3(-2.0, 0.65, -0.5), Color("#4d6658"))
	_box("CartFrontPanel", Vector3(2.48, 0.66, 0.035), Vector3(-2.0, 0.66, 0.145), Color("#5e7967"))
	_box("CartTimberRail", Vector3(2.82, 0.12, 1.38), Vector3(-2.0, 1.22, -0.5), Color("#75513a"))
	_box("CartWorktop", Vector3(2.72, 0.08, 1.3), Vector3(-2.0, 1.32, -0.5), Color("#aeb3aa"))
	for x in [-3.05, -0.95]:
		for z in [-0.98, -0.02]:
			_cylinder("CartWheel", 0.19, 0.19, 0.12, Vector3(x, 0.25, z), Color("#35322d"), 20)
	_box("CartLowerShelf", Vector3(2.25, 0.08, 0.9), Vector3(-2.0, 0.48, -0.5), Color("#75513a"))
	_box("CartSignBoard", Vector3(1.8, 0.42, 0.09), Vector3(-2.0, 2.05, -0.5), Color("#9c443c"))
	_box("SignTrim", Vector3(1.92, 0.06, 0.11), Vector3(-2.0, 2.28, -0.5), Color("#e4c99d"))
	_box("SignTextBar", Vector3(1.25, 0.045, 0.02), Vector3(-2.0, 2.08, -0.445), Color("#fff0cf"))

func _build_food_props() -> void:
	_build_stock_pot()
	_cylinder("NoodleBasin", 0.27, 0.23, 0.13, Vector3(-2.35, 1.47, -0.5), Color("#e4d4a8"), 28)
	_cylinder("NoodleTop", 0.22, 0.2, 0.025, Vector3(-2.35, 1.55, -0.5), Color("#e8d8a8"), 28)
	_cylinder("RawBeefTray", 0.25, 0.25, 0.07, Vector3(-3.0, 1.43, -0.5), Color("#aeb3aa"), 28)
	for i in range(5):
		_box("RawBeefSlice", Vector3(0.13, 0.025, 0.08), Vector3(-3.12 + float(i) * 0.06, 1.49, -0.57 + float(i % 2) * 0.12), Color("#b76a61"))
	_cylinder("PhoBowl", 0.34, 0.27, 0.16, Vector3(-0.95, 1.48, -0.45), Color("#f4ebd4"), 32)
	_cylinder("PhoBroth", 0.28, 0.28, 0.025, Vector3(-0.95, 1.565, -0.45), Color("#b97a2b"), 32)
	for i in range(6):
		_box("BeefOnPho", Vector3(0.12, 0.018, 0.055), Vector3(-1.13 + float(i % 3) * 0.16, 1.59, -0.55 + float(i / 3) * 0.15), Color("#9c5147"))
	_cylinder("HerbJar", 0.12, 0.12, 0.22, Vector3(-0.45, 1.48, -0.6), Color("#6f8a63"), 20)
	_cylinder("JarLid", 0.13, 0.13, 0.04, Vector3(-0.45, 1.61, -0.6), Color("#d8ccb5"), 20)

func _build_stools_and_shopfront() -> void:
	for pos in [Vector3(1.0, 0.0, -1.9), Vector3(2.15, 0.0, -1.9), Vector3(1.0, 0.0, -3.0)]:
		_cylinder("RedPlasticStoolSeat", 0.32, 0.32, 0.13, pos + Vector3(0, 0.48, 0), Color("#9c443c"), 24)
		for dx in [-0.18, 0.18]:
			for dz in [-0.16, 0.16]:
				_box("StoolLeg", Vector3(0.055, 0.43, 0.055), pos + Vector3(dx, 0.22, dz), Color("#35322d"))
	# A shuttered shopfront and a simple awning create a readable Hanoi alley silhouette.
	_box("ShopDoor", Vector3(1.5, 2.2, 0.08), Vector3(4.9, 1.1, -6.82), Color("#75513a"))
	for i in range(6):
		_box("ShutterSlat", Vector3(1.38, 0.045, 0.04), Vector3(4.9, 0.35 + float(i) * 0.24, -6.75), Color("#9b7657"))
	_box("Awning", Vector3(2.5, 0.12, 1.0), Vector3(4.6, 2.5, -6.25), Color("#9c443c"))
	_box("AwningUnderside", Vector3(2.5, 0.08, 0.92), Vector3(4.6, 2.42, -6.25), Color("#d8ccb5"))
	for x in [3.45, 4.0, 4.55, 5.1, 5.65]:
		_box("AwningStripe", Vector3(0.12, 0.02, 0.92), Vector3(x, 2.47, -6.25), Color("#f0d9b5"))


func _build_stock_pot() -> void:
	# A modest, well-used aluminum stockpot: dull finish, rolled rim, worn bands,
	# simple side handles and a lid set aside. Keep the broth silhouette readable.
	var pot := Node3D.new()
	pot.name = "PROP_stock_pot_old_aluminum"
	add_child(pot)

	var body := _cylinder("PotBody", 0.455, 0.405, 0.58, Vector3(-1.45, 1.65, -0.5), Color("#898d88"), 40, pot)
	body.material_override = _mat(Color("#898d88"), 0.82)
	_cylinder("PotBaseFoot", 0.395, 0.395, 0.055, Vector3(-1.45, 1.365, -0.5), Color("#666b67"), 36, pot)
	_cylinder("RolledTopRim", 0.475, 0.475, 0.065, Vector3(-1.45, 1.958, -0.5), Color("#b1b4ad"), 40, pot)
	_cylinder("InnerDarkLip", 0.432, 0.432, 0.018, Vector3(-1.45, 1.918, -0.5), Color("#555b55"), 36, pot)
	_cylinder("BrothSurface", 0.421, 0.421, 0.018, Vector3(-1.45, 1.927, -0.5), Color("#a96e2d"), 36, pot)

	# Subtle dents/wear are broad and low-contrast, not dirt on the food-contact area.
	_cylinder("LowerWearBand", 0.414, 0.414, 0.035, Vector3(-1.45, 1.43, -0.5), Color("#777b75"), 36, pot)
	_cylinder("UpperWearBand", 0.457, 0.457, 0.025, Vector3(-1.45, 1.78, -0.5), Color("#777c76"), 40, pot)

	for side in [-1.0, 1.0]:
		var handle := _cylinder("SideHandleGrip", 0.055, 0.055, 0.20, Vector3(-1.45 + side * 0.53, 1.77, -0.5), Color("#555a55"), 16, pot)
		handle.rotation_degrees.z = 90.0
		for rivet_z in [-0.565, -0.435]:
			var rivet := _cylinder("HandleRivet", 0.022, 0.022, 0.012, Vector3(-1.45 + side * 0.445, 1.80, rivet_z), Color("#c0c1b9"), 12, pot)
			rivet.rotation_degrees.x = 90.0

	# The lid rests partly over the rear edge, making the vessel feel actively used.
	var lid := _cylinder("LidSetAside", 0.34, 0.34, 0.035, Vector3(-1.43, 1.985, -0.18), Color("#9a9e97"), 32, pot)
	lid.rotation_degrees.z = -12.0
	var lid_knob := _cylinder("LidKnob", 0.055, 0.055, 0.065, Vector3(-1.43, 2.035, -0.18), Color("#676c66"), 16, pot)

	# Light, sparse steam; low opacity keeps the broth and pot rim readable.
	var steam := CPUParticles3D.new()
	steam.name = "BrothSteam"
	steam.position = Vector3(-1.45, 1.97, -0.5)
	steam.amount = 10
	steam.lifetime = 1.7
	steam.emitting = true
	steam.direction = Vector3(0.0, 1.0, 0.0)
	steam.spread = 13.0
	steam.gravity = Vector3(0.0, 0.06, 0.0)
	steam.initial_velocity_min = 0.10
	steam.initial_velocity_max = 0.22
	steam.scale_amount_min = 0.018
	steam.scale_amount_max = 0.035
	var steam_mesh := SphereMesh.new()
	steam_mesh.radius = 0.035
	steam_mesh.height = 0.07
	steam.mesh = steam_mesh
	var steam_material := StandardMaterial3D.new()
	steam_material.albedo_color = Color(0.92, 0.89, 0.82, 0.22)
	steam_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	steam_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	steam_material.roughness = 1.0
	steam_material.no_depth_test = false
	steam_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	steam_material.vertex_color_use_as_albedo = true
	steam.material_override = steam_material
	add_child(steam)

func _box(label: String, size: Vector3, at: Vector3, tint: Color, parent: Node = null) -> MeshInstance3D:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = label
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_node.mesh = mesh
	mesh_node.position = at
	mesh_node.material_override = _mat(tint, 0.88)
	if parent == null:
		add_child(mesh_node)
	else:
		parent.add_child(mesh_node)
	return mesh_node

func _cylinder(label: String, top_radius: float, bottom_radius: float, height: float, at: Vector3, tint: Color, sides: int = 24, parent: Node = null) -> MeshInstance3D:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = label
	var mesh := CylinderMesh.new()
	mesh.top_radius = top_radius
	mesh.bottom_radius = bottom_radius
	mesh.height = height
	mesh.radial_segments = sides
	mesh_node.mesh = mesh
	mesh_node.position = at
	mesh_node.material_override = _mat(tint, 0.62)
	if parent == null:
		add_child(mesh_node)
	else:
		parent.add_child(mesh_node)
	return mesh_node

func _mat(tint: Color, rough: float) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = rough
	return material
