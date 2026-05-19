all:
	stow --verbose --target=$$HOME --restow dots
	matugen image assets/default_wallpaper.jpg -m dark --source-color-index 0

update:
	git pull
	stow --verbose --target=$$HOME --restow dots

remove: 
	stow --verbose --target=$$HOME --delete dots
	rm -rf ~/.local/state/quickshell/hematite