# eBrew-Godot
The eBrew mockup brought to life in Godot 4.1

Disclaimer: This project is not officially associated with the original designers/artists behind the eBrew concept

This is a work in progress recreation of https://gbatemp.net/threads/wii-u-new-hbl-gui-concept-new-name-ebrew-store.602363/ which aims for full recreation of all the (visibly deductable) intended functionality in the mockup images (Homebrew Launcher + Homebrew App Store).

Until Godot gets ported to Wii U, this project will be limited to Godot-compatible platforms as a frontend for the Wii U Homebrew App Store.

As well as recreating the original concept, I've also made some minor changes. So far, this includes custom background image support (put a `background.png` in the `Userfiles` folder.)
*Note: This is currently nonfunctional while settings are being implemented

To run this, download the files into a folder and then then add that folder to your project list in Godot (4.1), or run one of the pre-compiled versions present in the releases tab

# To-do
* Add downloading and uninstalling homebrew

* Homebrew launcher functionality (loading information on locally saved homebrew):

* Implement download progress bar...somewhere

* Finish settings implementation

* Remake scroll bar for fixed visuals and functional usage

* finish compatibility for compliled versions:

** Linux: Done

** Windows: Done

** Android: Fix loading issues, change user directories (it's storing userdata in a root access directory, I don't want that)


# Possible future features
* Custom background music

* FTP transfer to Wii U/Switch

* (PC) HBL launching calls launch the app in Cemu

* (PC) Using Wiiload to send homebrew to and launch homebrew on a real Wii U

* Other appstores (Switch HBAS, Open Shop Channel, Universal Updater, etc.)

# Known bugs
* All: If you scroll too fast past an app that doesn't have an icon, there's a small chance that it will not load its icon on the menu side once it is downloaded. This is fixed upon a reboot. I could fix this, but right now it seems like a very niche and harmless thing to impliment some extra checks for.

* Windows: Some app asset loading is broken (affects default background image, loading repo, etc.)

PS: If you happen to have the orignal assets for the mockup, let me know and/or make a pull request to add them to the repo, because right now I'm just working with assets I photoshopped out of the few screenshots posted in the above GBATemp thread.
