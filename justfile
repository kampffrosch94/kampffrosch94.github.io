draft:
    hugo serve -DEF

build:
	hugo

server:
    hugo server --buildDrafts --navigateToChanged
