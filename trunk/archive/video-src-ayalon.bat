echo Running Traffic Camera - Ayalon
rem @echo off
set SOURCE_NAME=traffic-cam-ayalon

set Z_HOME=z:\\zion-camera
set LOG_FILE="%Z_HOME%\\log\\video-sources\\%SOURCE_NAME%.log"
set VLM_CONF="%Z_HOME%\\conf\\video-sources\\%SOURCE_NAME%.conf"

set VLC="C:\Program Files\VideoLAN\VLC\vlc.exe"

@echo on

%VLC% -vvv -I telnet --telnet-password a --vlm-conf %VLM_CONF% --file-logging --logfile=%LOG_FILE% 