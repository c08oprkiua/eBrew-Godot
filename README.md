# eBrew-Godot
The eBrew mockup brought to life in Godot 4.1

Disclaimer: This project is not officially associated with the original designers/artists behind the eBrew concept

This is a work in progress recreation of https://gbatemp.net/threads/wii-u-new-hbl-gui-concept-new-name-ebrew-store.602363/ which aims for full recreation of all the (visibly deductable) intended functionality in the mockup images (Homebrew Launcher + Homebrew App Store).

Until Godot gets ported to Wii U, this project will be limited to Godot-compatible platforms (Linux, Windows, Android, etc.) as a frontend for the Wii U Homebrew App Store.

As well as recreating the original concept, I've also made some minor changes. So far, this includes: 
* Custom background image support: Put a path to your file into the custom image setting's text box box in settings, press enter, then press save, and if the directory is valid, it will load that image as the background of the app on subsequent uses of the app.

To run this, download the files into a folder and then then add that folder to your project list in Godot (4.1), or run one of the pre-compiled versions present in the releases tab

# To-do
* Add unzipping downloaded homebrew to user defined folder
* Homebrew launcher functionality (loading information on locally saved homebrew)
* Complete download bar implementation
* Finish settings implementation
  * Visually load user saved directories
  * Implement directory save/check button functionality
* Finish compatibility for compiled versions:
  * Linux: Done
  * Windows: Done(?)
  * Android: Change user directories (it's storing userdata in a root access directory, I don't want that)

# Possible future features
* Custom background music

* FTP transfer to Wii U/Switch

* (PC) HBL launching calls launch the app in Cemu

* (PC) Using Wiiload to send homebrew to and launch homebrew on a real Wii U

* Other appstores (Switch HBAS, Open Shop Channel, Universal Updater, etc.)

# Known bugs
* All: If you scroll too fast past an app that doesn't have an icon, there's a small chance that it will not load its icon on the menu side once it is downloaded. This is fixed upon a reboot. I could fix this, but right now it seems like a very niche and harmless thing to impliment some extra checks for.

* All: On occasion, when downloading a homebrew, the app will freeze. I don't quite know what causes this, and it seems to just be the GUI, because the app usually finishes downloading in the background. I have some ideas as to what it is, but yeah, for now, just watch out for that. And it also might just be my computer, because Godot itself also freezes quite a lot on my computer, which seems to be a me-specific issue-

PS: Right now I'm just working with assets I photoshopped out of the few screenshots posted in the above GBATemp thread. If you have a copy of the original assets used in creating the mockups, or are skilled enough in digital art to recreate them from scratch, please let me know and/or make a pull request to add them to the repository.
