extends Node2D

func _on_stone_tablet_interacted(_interactor):
	$StoneTabletOverlay/TextVisualizer.start_text()
	$StoneTabletOverlay/TextVisualizer2.start_text()
