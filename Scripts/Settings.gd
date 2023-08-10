extends Control
@export var data: BrewInfo

var usertext
func _ready():
	if FileAccess.file_exists(data.inifilepath):
		ButtonInit()
	else:
		OS.alert("No ini file found, one will be created as soon as you edit your settings and save", "No Settings File")

func ButtonInit():
	data.setini.load(data.inifilepath)
	if data.setini.has_section("AppBehavior"):
		for entries in data.setini.get_section_keys("AppBehavior"):
			var value = data.setini.get_value("AppBehavior", entries)
			data.setini.set_value("AppBehavior", entries, value)
			var custpath = "VBoxContainer/TabContainer/App Behavior/Scroller/Lister/"+entries+"/Toggle"
			get_node(custpath).set_pressed(value)

func DirectoryInit():
	data.setini.load(data.inifilepath)
	if data.setini.has_section("Directories"):
		for entries in data.setini.get_section_keys("Directories"):
			var value = data.setini.get_value("Directories", entries)
			data.setini.set_value("Directories", entries, value)
			var custpath = "VBoxContainer/TabContainer/Directories/Scroller/Lister/"+entries+"/Field"
			get_node(custpath).text(value)

#Non-toggle buttons and other possble settings elements with unique functions
func _on_repo_download_pressed():
	SignalBox.emit_signal("StartRepoFetch")

func _on_list_load_pressed():
	SignalBox.emit_signal("StartList")

func _on_open_cfg_dir_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://Userfiles"))

#Directory save management
func dirsave(passdir, new_text):
	data.setini.set_value("Directories", passdir, new_text)

func _on_user_directory_text_submitted(new_text):
	dirsave("UserDirectory", new_text)

func _on_downloaddir_text_submitted(new_text):
	dirsave("DownloadDirectory", new_text)

#Every setting that is a toggle
#Right now, every setting name in the tree MUST match its config value name, or else
# it will not visually load properly when the settings window is initialized
func OptionSwitchToggled(PassedSetting, buttonstate):
	data.setini.set_value("AppBehavior", PassedSetting, buttonstate)

func _on_autodownload_toggled(button_pressed, SettingName):
	OptionSwitchToggled(SettingName, button_pressed)

func _on_auto_load_hbas_toggled(button_pressed):
	OptionSwitchToggled("Autoload", button_pressed)

func _on_load_image_toggle_toggled(button_pressed):
	OptionSwitchToggled("LoadCustomBackgroundImage", button_pressed)

func _on_loadmusic_toggled(button_pressed):
	OptionSwitchToggled("LoadCustomBackgroundMusic", button_pressed)

#Core settings menu UI stuff
func _on_cancel_changes_pressed():
	ButtonInit()

func _on_save_changes_pressed():
	data.setini.save(data.inifilepath)

func _on_window_close_requested():
	get_parent().hide()
