all:
	stow --verbose --target=$$HOME --restow dots

delete: 
	stow --verbose --target=$$HOME --delete dots