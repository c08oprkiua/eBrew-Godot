extends Control

var haschanges: bool

#These are the dictionaries for inputting the setting name and
#outputting the node path of that setting
var optdict ={
	"Autoload": "VBoxContainer/TabContainer/App Behavior/Scroller/Lister/Autoload",
	"AutoDownloadRepo": "VBoxContainer/TabContainer/App Behavior/Scroller/Lister/AutoDL",
	"LoadCustomBackgroundMusic": "VBoxContainer/TabContainer/App Behavior/Scroller/Lister/CustBGM",
	"LoadCustomBackgroundImage": "VBoxContainer/TabContainer/App Behavior/Scroller/Lister/CustBG",
	"AutoFTP": "VBoxContainer/TabContainer/App Behavior/Scroller/Lister/AutoFTP"
}

const dirdict = {
	"CustomBackgroundImageDirectory": "VBoxContainer/TabContainer/Directories/Scroller/Lister/ImageDir/BGField",
	"CustomMusicDirectory": "VBoxContainer/TabContainer/Directories/Scroller/Lister/MusicDir/BGMField",
	"HomeBrewDirectory": "VBoxContainer/TabContainer/Directories/Scroller/Lister/DownloadDirectory/BrewField",
	"FTPIPAddress": "VBoxContainer/TabContainer/Directories/Scroller/Lister/FTPInfo/IPField",
	"FTPPort": "VBoxContainer/TabContainer/Directories/Scroller/Lister/FTPInfo/PortField",
}

func _ready():
	if FileAccess.file_exists(BrewInfo.inifilepath):
		ButtonInit()
	else:
		OS.alert("No ini file found, one will be created as soon as you edit your settings and save", "No Settings File")

#These can be combined with a function that calls a match statement based 
#on the Variant type

func ButtonInit():
	BrewInfo.setini.load(BrewInfo.inifilepath)
	if BrewInfo.setini.has_section("AppBehavior"):
		for entries in BrewInfo.setini.get_section_keys("AppBehavior"):
			var value = BrewInfo.setini.get_value("AppBehavior", entries)
			BrewInfo.setini.set_value("AppBehavior", entries, value)
			var custpath = optdict.get(entries)
			get_node(custpath).set_pressed(value)

func DirectoryInit():
	BrewInfo.setini.load(BrewInfo.inifilepath)
	if BrewInfo.setini.has_section("Directories"):
		for entries in BrewInfo.setini.get_section_keys("Directories"):
			var value = BrewInfo.setini.get_value("Directories", entries)
			BrewInfo.setini.set_value("Directories", entries, value)
			var custpath = dirdict.get(entries)
			get_node(custpath).set_text(value)

#Non-toggle buttons and other possble settings elements with unique functions
func _on_repo_download_pressed():
	BetterDownloading.DownloadRepo()

func _on_list_load_pressed():
	BrewInfo.JSONdecoding()

func _on_open_cfg_dir_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://Userfiles"))

func _on_app_delete_pressed():
	DeleteConfirm("Downloads/")

func _on_icon_delete_pressed():
	DeleteConfirm("Icons/")

func DeleteConfirm(items):
	var confirm = load("res://Scenes/Confirm.tscn")
	add_child(confirm.instantiate())
	#put an if/then statement in here about the delete window confirmation
	await SignalBox.Confirm
	print(SignalBox.Confirm)
	if SignalBox.Confirm:
		for entries in DirAccess.get_files_at(BrewInfo.UserFiles+items):
			DirAccess.remove_absolute(BrewInfo.UserFiles+items+entries)
	else: 
		return

#Directory save management
func dirsave(passdir, new_text):
	BrewInfo.setini.set_value("Directories", passdir, new_text)

func dircheck(passdir): #Checks if a file or directory exists, and if so, saves it, if not, error
	var testdir = BrewInfo.setini.get_value("Directories", passdir)
	if testdir.is_absolute_path():
		print("Valid absolute path")
	if testdir.is_relative_path():
		print("Valid relative")
	if not DirAccess.dir_exists_absolute(testdir):
		print("Invalid directory")

func _on_downloaddir_text_submitted(new_text):
	if new_text.is_absolute_path():
		print("Valid absolute path")
	if new_text.is_relative_path():
		print("Valid relative")
	dirsave("HomeBrewDirectory", new_text)

func _on_ImageDir_submitted(new_text):
	dirsave("CustomBackgroundImageDirectory", new_text)

func _on_MusicDir_submitted(new_text):
	dirsave("CustomMusicDirectory", new_text)

func _on_bg_field_text_changed(new_text):
	dirsave("CustomBackgroundImageDirectory", new_text)

func _on_bgm_field_text_changed(new_text):
	dirsave("CustomMusicDirectory", new_text)

func _on_brew_field_text_changed(new_text):
	dirsave("HomeBrewDirectory", new_text)

func _on_ip_field_text_changed(new_text):
	if new_text.is_valid_ip_address:
		dirsave("FTPIPAddress", new_text)

func _on_port_field_text_changed(new_text):
	dirsave("FTPPort", new_text)

func _on_test_con_pressed():
	pass # This will be a special one that connects via HTTPClient

func _on_test_bgm_pressed():
	pass # Replace with function body.

func _on_test_bg_pressed():
	pass # Replace with function body.

func _on_test_dir_pressed():
	pass # Replace with function body.

#Every setting that is a toggle
#Settings much have a node path matched to their setting name in the optdict variable
func OptionSwitchToggled(PassedSetting, buttonstate):
	BrewInfo.setini.set_value("AppBehavior", PassedSetting, buttonstate)

func _on_autodownload_toggled(button_pressed, SettingName):
	OptionSwitchToggled("AutoDownloadRepo", button_pressed)

func _on_auto_load_hbas_toggled(button_pressed):
	OptionSwitchToggled("Autoload", button_pressed)

func _on_load_image_toggle_toggled(button_pressed):
	OptionSwitchToggled("LoadCustomBackgroundImage", button_pressed)

func _on_loadmusic_toggled(button_pressed):
	OptionSwitchToggled("LoadCustomBackgroundMusic", button_pressed)

func _on_auto_ftp_toggled(button_pressed):
	OptionSwitchToggled("AutoFTP", button_pressed)

#Core settings menu UI stuff
func _on_cancel_changes_pressed():
	ButtonInit()

func _on_save_changes_pressed():
	BrewInfo.setini.save(BrewInfo.inifilepath)

func _on_window_close_requested():
	get_parent().hide()
