extends Control


var rounds = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_round() -> int:
	return rounds

func inc_round() -> void:
	rounds += 1

func win_check(arr: Array) -> int:
	var player = (rounds + 1) % 2 + 1
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
