#!  /bin/bash  
#
# 


ZSTREAM_BASEDIR=/home/gadi/zstream
source $ZSTREAM_BASEDIR/bin/zion-stream.sh


function zstream_vidsrc_usage()
{
	zstream_log "activated with wrong syntax - "$0
	echo "Usage: "$0" <video-src-conf-file>"
}

function zstream_vidsrc_verify_command()
{
	local vidsrc_conf="$1"
	if [ "$vidsrc_conf" == "" ] 
	then
	   zstream_vidsrc_usage
	   exit -1
	fi	
	
	if [ ! -e $vidsrc_conf ]
	then
		zstream_log "The specified file $vidsrc_conf couldn't found"
		exit -1
	fi
}


function zstream_conf_get_n_transcodes()
{	
	retval=`grep "video-source.output.transcode.*.name" $1 | wc -l`
}

function zstream_conf_get_output_streams()
{
	local n=$(zstream_conf_get_n_transcodes $1 ; echo $retval)
	local vidsrc_name=$(zstream_conf_get_value $1 video-source.name ; echo $retval)
	local address=$(zstream_conf_get_value $1 video-source.output.address ; echo $retval)
	local port=$(zstream_conf_get_value $1 video-source.output.port ; echo $retval)
	local stream
	local vlm_params
	local dst
	local i=1
	local sep=""


	retval=""
	while [ $i -le $n ]
	do
		if [ $i -eq 2  ]; then sep="," ; fi
		stream=$(zstream_conf_get_value $1 video-source.output.transcode.$i.name ; echo $retval)
		vlm_params=$(zstream_conf_get_value $1 video-source.output.transcode.$i.vlm-param ; echo $retval)
		dst="\"transcode{"$vlm_params"}:std{access=http,mux=asf,dst="$address:$port"/"$vidsrc_name"/"$stream"}\""
		retval="dst=$dst"$sep$retval
		let "i+=1"
	done
}

ZSTREAM_VIDSRC_CONF=$1
zstream_vidsrc_verify_command $ZSTREAM_VIDSRC_CONF

ZSTREAM_NAME=$(zstream_conf_get_value $ZSTREAM_VIDSRC_CONF video-source.name ; echo $retval)
ZSTREAM_STREAMDIR=$ZSTREAM_VIDSRCDIR/$ZSTREAM_NAME




ZSTREAM_VIDSRC=$(zstream_conf_get_value $ZSTREAM_VIDSRC_CONF video-source.input.stream_url ; echo $retval)
ZSTREAM_OUTPUTS=$(zstream_conf_get_output_streams $ZSTREAM_VIDSRC_CONF ; echo $retval)
ZSTREAM_LOGFILE=$ZSTREAM_STREAMDIR/vlc.log

echo "**** Loading Video Stream Source Aggregator ****" >$ZSTREAM_LOGFILE

ZSTREAM_CMDLINE=$VLC" -vvv -I telnet \""$ZSTREAM_VIDSRC"\" --http-reconnect --sout '#duplicate{"$ZSTREAM_OUTPUTS"}' --sout-keep --file-logging --logfile="$ZSTREAM_LOGFILE

echo $ZSTREAM_CMDLINE >> $ZSTREAM_LOGFILE
eval $ZSTREAM_CMDLINE &
zstream_write_pid "$ZSTREAM_LOGFILE" $ZSTREAM_STREAMDIR/vlc.pid


exit 0