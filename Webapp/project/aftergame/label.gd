extends Label


func getVars(f, arr, player) -> void:
	update(f, arr, player)
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func Gupdate(winnVar, winningPlayer) -> void:
	if winnVar == 1:
		self.text = "Herzlichen Glückwunsch, Spieler" + str(winningPlayer) + "! Du hast gewonnen"
	else:
		self.text = "Unentschieden!"

func update(Game, arr, winningPlayer) -> void:
	var winner = Game.win_check(arr)
	print(winningPlayer)
	if winner == 1:
		self.text = "Herzlichen Glückwunsch, Spieler" + str(winningPlayer) + "! Du hast gewonnen"
	else:
		self.text = "Unentschieden!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
