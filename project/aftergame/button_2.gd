extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self._button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _button_pressed():
	print("Start...")
	var root = get_tree().root
	for node in root.get_children():
		if node.name == "Game" or node.name == "GGame":
			get_tree().root.remove_child(node)
	get_tree().change_scene_to_file("res://Test.tscn")
