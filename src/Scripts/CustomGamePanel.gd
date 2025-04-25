extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_custom_pressed() -> void:
	if !$Seed.text.is_empty():
		get_parent().play(hash($Seed.text), $EnemyType.selected, $GeneratorAmount.value, $ChaosAmount.value, int($SpawnNeutralNpcs.button_pressed), $AdditionalLives.value, $FacilityMap.selected)
	else:
		get_parent().play(-1, $EnemyType.selected, $GeneratorAmount.value, $ChaosAmount.value, int($SpawnNeutralNpcs.button_pressed), $AdditionalLives.value, $FacilityMap.selected)
