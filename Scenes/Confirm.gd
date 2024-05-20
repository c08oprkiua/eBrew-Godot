extends ConfirmationDialog

func _on_confirmed() -> void:
	SignalBox.emit_signal("Confirm", true)

func _on_canceled() -> void:
	SignalBox.emit_signal("Confirm", false)

func _on_close_requested() -> void:
	SignalBox.emit_signal("Confirm", false)
