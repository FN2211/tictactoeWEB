extends Control

var GridList = []
var Rounds = 1
var PlayedButtons = []
var PlayedGrids = []
var GridGame = [0, 0, 0, 0, 0, 0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var MainGrid = self.get_node("GridContainer")
	for Grid in MainGrid.get_children():
		GridList.append(getButtonsFromGrid(Grid))

	bindClickEvents()
	updatePlayer()
	pass # Replace with function body.

func getButtonsFromGrid(Grid: Object) -> Array:
	var list = []
	for button in Grid.get_children():
		list.append(button)
	return list

func getPosOfButton(button: Object) -> int:
	var n = 0
	var i = 0
	var grid: Array
	while n == 0:
		if button in GridList[i]:
			grid = GridList[i]
			n = 1
		else:
			i += 1
			
	var index = grid.find(button)
	return index

func getGridOfButton(button: Object) -> int:
	for grid in GridList:
		if button in grid:
			return GridList.find(grid)
	
	return -1

	
func bindClickEvents() -> void:
	for Grid in GridList:
		for button in Grid:
			button.pressed.connect(func(): self._button_pressed(button))
	return

func buttonsToColor(grid: Array) -> Array:
	var colorgrid = []
	for button in grid:
		var color = button.get_theme_stylebox("disabled")
		if color.bg_color == Color(1, 0, 0):
			colorgrid.append(1)
		elif color.bg_color == Color(0, 0, 1):
			colorgrid.append(2)
		else:
			colorgrid.append(0)
	return colorgrid

func win_check(arr: Array) -> int:

	var player = (Rounds + 1) % 2 + 1
	var winPattern = []
	
	for i in range(1,4):
		winPattern.append([arr[i*3-3], arr[i*3-2], arr[i*3-1]])
		winPattern.append([arr[i-1], arr[i-1 + 3], arr[i-1 + 6]])
	winPattern.append([arr[0], arr[4], arr[8]])
	winPattern.append([arr[2], arr[4], arr[6]])
	
	if [player, player, player] in winPattern:
		return 1
	elif 0 not in arr:
		return -1
	else:
		return 0

func updatePlayer() -> void:
	var style = StyleBoxFlat.new()
	var playerPanel = get_node("Panel/Panel/PlayerColor")
	if Rounds%2 == 1:
		style.bg_color = Color(1, 0, 0)
		playerPanel.add_theme_stylebox_override("panel", style)
	else:
		style.bg_color = Color(0, 0, 1)
		playerPanel.add_theme_stylebox_override("panel", style)
	return

func _button_pressed(buttonRef: Object) -> void:
	PlayedButtons.append(buttonRef)
	buttonRef.disabled  = true
	var style = StyleBoxFlat.new()
	if Rounds%2 == 1:
		style.bg_color = Color(1, 0, 0)
		buttonRef.add_theme_stylebox_override("disabled", style)
	else:
		style.bg_color = Color(0, 0, 1)
		buttonRef.add_theme_stylebox_override("disabled", style)
	var gridIndex = getGridOfButton(buttonRef)
	var win_checkIn = win_check(buttonsToColor(GridList[gridIndex]))
	if win_checkIn == 1:
		PlayedGrids.append(gridIndex)
		if Rounds%2 == 1:
			GridGame[gridIndex] = 1
			style.bg_color = Color(1, 0, 0)
			for button in GridList[gridIndex]:
				button.disabled = true
				if button not in PlayedButtons:
					PlayedButtons.append(button)
				button.add_theme_stylebox_override("disabled", style)
		else:
			GridGame[gridIndex] = 2
			style.bg_color = Color(0, 0, 1)
			for button in GridList[gridIndex]:
				button.disabled = true
				if button not in PlayedButtons:
					PlayedButtons.append(button)
				button.add_theme_stylebox_override("disabled", style)
	elif win_checkIn == -1:
		PlayedGrids.append(gridIndex)
		style.bg_color = Color(0, 1, 0)
		for button in GridList[gridIndex]:
			button.add_theme_stylebox_override("disabled", style)
	
	var gameWin = win_check(GridGame)

	if gameWin == 0:
		pass
	elif gameWin == 1:
		print("Spieler" + str((Rounds+1)%2 + 1) + " hat gewonnen!")
		var aftergame = load("res://aftergame/aftergame.tscn").instantiate()
		var node = aftergame.get_node("Panel/Label")
		node.Gupdate(gameWin, (Rounds+1)%2 + 1)
		get_tree().root.add_child(aftergame)
		get_tree().current_scene = aftergame
	else:
		print("Unentschieden!")
		var aftergame = load("res://aftergame/aftergame.tscn").instantiate()
		var node = aftergame.get_node("Panel/Label")
		node.Gupdate(gameWin, (Rounds+1)%2 + 1)
		get_tree().root.add_child(aftergame)
		get_tree().current_scene = aftergame

	Rounds += 1
	updatePlayer()

	var posIndex = getPosOfButton(buttonRef)
	if posIndex in PlayedGrids:
		for grid in GridList:
			for button in grid:
				if button in PlayedButtons:
					button.disabled = true
				else:
					button.disabled = false
	else:	
		var fakeGridlist = GridList.duplicate(true)
		fakeGridlist.pop_at(posIndex)
		for grid in fakeGridlist:
			for button in grid:
				button.disabled = true
		for button in GridList[posIndex]:
			if button not in PlayedButtons:
				button.disabled = false
	
	return
