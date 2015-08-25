#!  /bin/bash  
#
# 


ZSTREAM_BASEDIR=/home/gadi/zstream
source $ZSTREAM_BASEDIR/bin/zion-stream.sh



function zstream_customer_start_usage()
{
	zstream_log "activated with wrong syntax - "$0
	echo "Usage: "$0" <customer-name>"
}

function zstream_customer_start_verify_command()
{
	local customer="$1"
	if [ "$customer" == "" ] 
	then
	   zstream_customer_start_usage
	   exit -1
	fi	
	
	if [ ! -e $ZSTREAM_CUSTOMER_BASEDIR/$customer ]
	then
		zstream_log "Missing customer configuration directory - $ZSTREAM_BASEDIR/customer/$customer"
		exit -1
	fi

	if [ ! -e $ZSTREAM_CUSTOMER_BASEDIR/$customer/customer.conf ]
	then
		zstream_log "Missing customer configuration file at $ZSTREAM_BASEDIR/customer/$customer/customer.conf"
		exit -1
	fi	
}

function zstream_customer_get_n_video_sources()
{	
	retval=`grep "customer.video_source.*.name" $1 | wc -l`
}

function zstream_customer_get_n_streams()
{
	local conf=$1
	retval=`grep "customer.video_source.$2.stream.*" $conf | wc -l`
}

function zstream_verify_stream_configured()
{
	local conf=$1
	local stream=$2
	
	retval=`grep "video-source.output.transcode.*.name=$vidsrc" $conf | wc -l`
}

function zstream_generate_customer_vlm_conf()
{
	local conf=$1
	local vlmconf=$2
	local n_sources=$(zstream_customer_get_n_video_sources $conf ; echo $retval)
	local url_prefix=$(zstream_conf_get_value $1 customer.server.base-url ; echo $retval)
	local base_url=$address:$port/$url_prefix
	local i=1

	
	echo "# Zion Streams - Automatically Generated VLM Configuration - Do Not Edit " > $vlmconf
	echo "# Date:   "`date`" " >> $vlmconf
	echo "# Source: $conf" >> $vlmconf
	echo "# " >> $vlmconf
	echo " " >> $vlmconf			
	
	while [ $i -le $n_sources ]
	do
		# Obtain the number of streams we are using from a stream source
		local n_streams
		local vidsrc
		local j
		local instream_address
		local instream_port

		n_streams=$(zstream_customer_get_n_streams $conf $i ; echo $retval)
		vidsrc=$(zstream_conf_get_value $conf customer.video_source.$i.name ; echo $retval)
		
		if [ ! -e  $ZSTREAM_VIDSRCDIR/$vidsrc/video-source.conf ]
		then
			zstream_log "Missing video source file $ZSTREAM_VIDSRCDIR/$vidsrc/video-source.conf"
			echo " " >> $vlmconf			
			echo "# " >> $vlmconf			
			echo "# Skipped configuration for $vidsrc." >> $vlmconf			
			echo "# The file $ZSTREAM_VIDSRCDIR/$vidsrc/video-source.conf is missing " >> $vlmconf			
			echo "# " >> $vlmconf	
			echo " "  >> $vlmconf	
			let "i+=1"
			continue
		fi
		
		instream_address=$(zstream_conf_get_value $ZSTREAM_VIDSRCDIR/$vidsrc/video-source.conf video-source.output.address ; echo $retval)
		instream_port=$(zstream_conf_get_value $ZSTREAM_VIDSRCDIR/$vidsrc/video-source.conf video-source.output.port ; echo $retval)
		
		j=1
		while [ $j -le $n_streams ]
		do
			local configured
			local stream=$(zstream_conf_get_value $conf customer.video_source.$i.stream.$j ; echo $retval)

			input_url="http://"$instream_address":"$instream_port"/"$vidsrc"/"$stream
			
			configured=$(zstream_verify_stream_configured $ZSTREAM_VIDSRCDIR/$vidsrc/video-source.conf $stream ; echo $retval)
			
			if [ "$configured" == "0" ] ; then zstream_log "[warn] Can't find $stream in $ZSTREAM_VIDSRCDIR/$vidsrc/video-source.conf" ; fi 
			
			echo " " >> $vlmconf
			echo "# " >> $vlmconf
			echo "# VLM Stream definition for $vidsrc/$stream" >> $vlmconf
			echo "# " >> $vlmconf
			echo "new      "$vidsrc"-"$stream" vod enabled" >> $vlmconf
			echo "setup    "$vidsrc"-"$stream" input "$input_url >> $vlmconf
			echo "setup    "$vidsrc"-"$stream" option http-reconnect" >> $vlmconf
			
			let "j+=1"
		done
		
		let "i+=1"
	done
	
	retval=0
}

ZSTREAM_CUSTOMER=$1
zstream_customer_start_verify_command $ZSTREAM_CUSTOMER

ZSTREAM_CUSTOMERDIR=$ZSTREAM_CUSTOMER_BASEDIR/$ZSTREAM_CUSTOMER
ZSTREAM_CUSTOMER_CONF=$ZSTREAM_CUSTOMERDIR/customer.conf
ZSTREAM_CUSTOMER_VLM_CONF=$ZSTREAM_CUSTOMERDIR/vlm.conf
ZSTREAM_LOGFILE=$ZSTREAM_CUSTOMERDIR/vlc.log

zstream_generate_customer_vlm_conf $ZSTREAM_CUSTOMER_CONF $ZSTREAM_CUSTOMER_VLM_CONF
if [ "$retval" != "0" ]
then
	zstream_log "Failed to generate vlm confoguration file for $ZSTREAM_CUSTOMER"
	zstream_log "Please check $ZSTREAM_CUSTOMER_CONF"
	exit -1
fi


echo "**** Starting Customer $ZSTREAM_CUSTOMER - Streaming Server ****" >$ZSTREAM_LOGFILE

address=$(zstream_conf_get_value $ZSTREAM_CUSTOMER_CONF customer.server.address ; echo $retval)
port=$(zstream_conf_get_value $ZSTREAM_CUSTOMER_CONF customer.server.port ; echo $retval)

ZSTREAM_CMDLINE=$VLC" -vvv -I telnet --vlm-conf "$ZSTREAM_CUSTOMER_VLM_CONF" --file-logging --logfile="$ZSTREAM_LOGFILE" --rtsp-host "$address":"$port

echo $ZSTREAM_CMDLINE >> $ZSTREAM_LOGFILE
eval $ZSTREAM_CMDLINE &
zstream_write_pid "$ZSTREAM_LOGFILE" $ZSTREAM_STREAMDIR/vlc.pid


exit 0