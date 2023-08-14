extends Node

#Some Universal static variables, cause I didn't wanna make a new script for them
var version = 0.3

#UI/Misc.
signal InitDir
signal Okaytoloadimg
signal Thisitem
signal Gohere

#Downloading
signal DownloadStarted
signal DownloadPercent
signal DownloadComplete

#Icon Processing
signal DLicon
signal Processimage
signal Processedicon

#Homebrew Management
signal DownloadThis
signal Deletethis

#List loading
signal StartRepoFetch
signal StartList
signal SafeRepo
