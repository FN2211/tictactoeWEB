extends GridContainer

var arr = [0,0,0,0,0,0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buttons = self.get_children()
	for button in buttons:
		button.pressed.connect(func(): self._button_pressed(button, buttons))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _button_pressed(buttonRef: Object, buttonList: Array):
	var Game = get_node("../../../Game")
	var rounds = Game.get_round() % 2
	if rounds == 1:
		arr[buttonList.find(buttonRef)] = 1
		buttonRef.disabled = true
		var style = StyleBoxFlat.new()
		style.bg_color = Color(1, 0, 0)
		buttonRef.add_theme_stylebox_override("disabled", style)
	else:
		arr[buttonList.find(buttonRef)] = 2
		buttonRef.disabled = true
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0, 0, 1)
		buttonRef.add_theme_stylebox_override("disabled", style)
		
	var won = Game.win_check(arr)
	if won == 0:
		pass
	elif won == 1:
		print("Spieler" + str((rounds+1)%2 + 1) + " hat gewonnen!")
		for button in buttonList:
			button.disabled = true
			
		var aftergame = load("res://aftergame/aftergame.tscn").instantiate()
		var node = aftergame.get_node("Panel/Label")
		node.getVars(Game, arr, str((rounds+1)%2 + 1))
		get_tree().root.add_child(aftergame)
		get_tree().current_scene = aftergame
	else:
		print("Unentschieden!")
		var aftergame = load("res://aftergame/aftergame.tscn").instantiate()
		var node = aftergame.get_node("Panel/Label")
		node.getVars(Game, arr, str((rounds+1)%2 + 1))
		get_tree().root.add_child(aftergame)
		get_tree().current_scene = aftergame
	Game.inc_round()
