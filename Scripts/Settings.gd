extends Control
@export var data: BrewInfo

var usertext
func _ready():
	if FileAccess.file_exists(data.inifilepath):
		for UserDirectory in data.setini.get_sections():
			$"TabContainer/App Behavior/AutoLoad/Toggle".set_pressed(data.setini.get_value("AppBehavior", "Autoload"))
		#$"TabContainer/App Behavior/LoadBackgroundImage/Toggle".set_pressed(data.setini.get_value("AppBehavior", "LoadBackgroundImage"))
		#$"TabContainer/Directories/UserDir/Field".text = data.setini.get_value("Directories", "UserDirectory")
	else:
		OS.alert("No ini file found, one will be created as soon as you edit your settings and save", "No Settings File")

#Non-toggle buttons and other possble settings elements with unique functions
func _on_repo_download_pressed():
	SignalBox.emit_signal("StartRepoFetch")

func _on_list_load_pressed():
	SignalBox.emit_signal("StartList")

func _on_open_cfg_dir_pressed():
	#This is broken, fix with DirAccess
	OS.shell_open(data.inifilepath)

#Directory save management
func dirsave(passdir, new_text):
	data.setini.set_value("Directories", passdir, new_text)

func _on_user_directory_text_submitted(new_text):
	dirsave("UserDirectory", new_text)

func _on_downloaddir_text_submitted(new_text):
	dirsave("Download Directory", new_text)

#Every setting that is a toggle
func OptionSwitchToggled(PassedSetting, buttonstate):
	data.setini.set_value("AppBehavior", PassedSetting, buttonstate)

func _on_autodownload_toggled(button_pressed):
	OptionSwitchToggled("AutoDownloadRepo", button_pressed)

func _on_auto_load_hbas_toggled(button_pressed):
	OptionSwitchToggled("Autoload", button_pressed)

func _on_load_image_toggle_toggled(button_pressed):
	OptionSwitchToggled("LoadCustomBackgroundImage", button_pressed)

func _on_loadmusic_toggled(button_pressed):
	OptionSwitchToggled("LoadCustomBackgroundMusic", button_pressed)

#Core settings menu UI stuff
func _on_cancel_changes_pressed():
	get_parent().hide()

func _on_save_changes_pressed():
	data.setini.save(data.inifilepath)

func _on_window_close_requested():
	get_parent().hide()
