# eBrew-Godot
The eBrew mockup brought to life in Godot 4.1

Disclaimer: This project is not officially associated with the original creator of the eBrew mockups

This is a work in progress recreation of https://gbatemp.net/threads/wii-u-new-hbl-gui-concept-new-name-ebrew-store.602363/ which aims for full recreation of all the (visibly deductable) intended functionality visible in the mockup images (Homebrew Launcher + Homebrew App Store). Until Godot gets ported to Wii U, this project will be limited to desktop platforms as a frontend for the Homebrew App Store.

As well as recreating the original concept, I've also made some minor changes. So far, this includes custom background image support (put a `background.png` in the `Userfiles` folder.)

To run this, download the files into a folder and then then add that folder to your project list in Godot (4.1). Compiled version support is currently not functional, but I am going to add it later

# To-do
add downloading homebrews

homebrew launcher functionality

impliment download progress bar... somewhere

impliment a settings screen (override custom background/bgm, auto-load HBAS, set download directory, etc.)

compatibility for compliled versions


# Possible future features
custom background music

FTP transfer to Wii U/Switch


# Known bugs
Item 0 in the HBAS repo currently doesn't load, and instead, at the very bottom of the in-app list, is an empty item that will crash the app when focused. 

PS: If you happen to have the orignal assets of the mockup, let me know and/or make a pull request to add them to the repo, because right now I'm just working with assets I edited out of the few screenshots posted in the above GBATemp thread.

