echo Running Zion VLC Cam-Z

set SOURCE_NAME=z-cam-hilton

set Z_HOME=z:\\zion-camera
set LOG_FILE="%Z_HOME%\\log\\video-sources\\%SOURCE_NAME%.log"
set VLM_CONF="%Z_HOME%\\conf\\video-sources\\%SOURCE_NAME%.conf"

set VLC="C:\Program Files\VideoLAN\VLC\vlc.exe"


%VLC% -vvv --vlm-conf %VLM_CONF% --file-logging --logfile=%LOG_FILE%