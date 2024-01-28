extends ConfirmationDialog

func _on_confirmed():
	SignalBox.emit_signal("Confirm", true)

func _on_canceled():
	SignalBox.emit_signal("Confirm", false)

func _on_close_requested():
	SignalBox.emit_signal("Confirm", false)
