export VERSION = 5

ship:
	wagon do ffmpeg ship pushx

ship.debug:
	WAGON_LOG_LEVEL=debug $(MAKE) ship