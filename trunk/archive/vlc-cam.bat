echo Running Zion VLC Cam-Z

C:\Program Files\VideoLAN\VLC>vlc.exe  http://www.camstreams.com/asx.asp?user=diddy0071 --sout "#transcode{vcodec=mp4v,vb=800,scale=1}:duplicate{dst=std{access=http,mux=asf,dst=0.0.0.0:8080/test}}" --sout-keep

vlc.exe  -vvv http://www.camstreams.com/asx.asp?user=diddy0071 --sout "#duplicate{dst=\"transcode{vcodec=mp4v,vb=800,scale=1}:std{access=http,mux=asf,dst=0.0.0.0:8080/test}\", dst=\"transcode{vcodec=mp4v,vb=800,scale=1}:std{access=http,mux=asf,dst=0.0.0.0:8081/test}\"}" --sout-keep


vlc.exe  -vvv http://www.camstreams.com/asx.asp?user=diddy0071 --sout "#duplicate{dst=\"transcode{vcodec=mp4v,vb=800,scale=1}:std{access=http,mux=asf,dst=0.0.0.0:8080/test}\"}" --sout-keep


vlc.exe -vvv http://127.0.0.1:8081/test --sout "#duplicate{dst=display}"


vlc.exe  -vvv "http://switch3.castup.net/cunet/gm.asp?format=wm&s=0E226176877E4F62BF69AB0B09A7C4A9&ci=15375&ak=35143679&ClipMediaID=21335&authi=&autht=&dr=" --sout "#duplicate{dst=\"transcode{vcodec=mp4v,width=160,hight=120}:std{access=http,mux=asf,dst=0.0.0.0:8080/iphone}\"}" --sout-keep
vlc.exe -vvv http://127.0.0.1:8080/iphone --sout "#duplicate{dst=display}"


"http://switch3.castup.net/cunet/gm.asp?format=wm&s=0E226176877E4F62BF69AB0B09A7C4A9&ci=15375&ak=35143679&ClipMediaID=21335&authi=&autht=&dr="



vlc.exe  -vvv "http://switch3.castup.net/cunet/gm.asp?format=wm&s=0E226176877E4F62BF69AB0B09A7C4A9&ci=15375&ak=35143679&ClipMediaID=21335&authi=&autht=&dr=" --sout "#duplicate{dst=\"transcode{vcodec=mp4v,fps=2.0,width=160,hight=120}:std{access=http,mux=asf,dst=0.0.0.0:8080/iphone}\"}" --sout-keep


vlc.exe -vvv "http://switch3.castup.net/cunet/gm.asp?format=wm&s=0E226176877E4F62BF69AB0B09A7C4A9&ci=15375&ak=35143679&ClipMediaID=21335&authi=&autht=&dr=" --sout "#duplicate{dst=display}"


vlc.exe -vvv rtsp://localhost:5554/z-cam-hilton-a --sout "#duplicate{dst=display}"



rem
rem    Obtain a stream from an an Input stream, and transcode into one or more streams
rem     The streams are served using HTTP and ASF mux
rem
vlc.exe  -vvv "http://switch3.castup.net/cunet/gm.asp?format=wm&s=0E226176877E4F62BF69AB0B09A7C4A9&ci=15375&ak=35143679&ClipMediaID=21335&authi=&autht=&dr=" --sout "#duplicate{dst=\"transcode{vcodec=mp4v,vb=200,width=160,hight=120}:std{access=http,mux=asf,dst=0.0.0.0:8080/iphone}\", dst=\"transcode{vcodec=mp4v,vb=800,scale=1}:std{access=http,mux=asf,dst=0.0.0.0:8081/test}\"}" --sout-keep
vlc.exe  -vvv "http://switch3.castup.net/cunet/gm.asp?format=wm&s=0E226176877E4F62BF69AB0B09A7C4A9&ci=15375&ak=35143679&ClipMediaID=21335&authi=&autht=&dr=" --sout "#duplicate{dst=\"transcode{vcodec=mp4v,vb=200,width=160,hight=120}:std{access=http,mux=asf,dst=0.0.0.0:8080/iphone}\"}" --sout-keep


rem      End User   Access  to the Customer Streaming Server
vlc.exe -vvv http://127.0.0.1:9999/test --sout "#duplicate{dst=display}"
vlc.exe -vvv http://127.0.0.1:9999/iphone --sout "#duplicate{dst=display}"