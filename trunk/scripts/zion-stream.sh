#!  /bin/bash  
#
# 

ZSTREAM_BASEDIR=/home/gadi/zstream
VLC=/usr/bin/vlc

ZSTREAM_CUSTOMER_BASEDIR=$ZSTREAM_BASEDIR/customers
ZSTREAM_VIDSRCDIR=$ZSTREAM_BASEDIR/video-sources
ZSTREAM_BINDIR=$ZSTREAM_BASEDIR/bin


#
# The main logging function
#
function zstream_log()
{
	echo $1
}

#
#  Write a process id into a specifc location
#   @param 1 - a string that identfies the process uniquely 
#   @param2 - the file (full path) where we want to write the PID
#
function zstream_write_pid()
{
	local vidsrc_id=$1
	local write_path=$2
	
	pid=$(ps aux | grep $vidsrc_id | grep -v grep  | awk '{print $2}')
	
	echo $pid > $2	
}

#
#  Obtain the <value> from a <name>=<value> pair in a given configuration file
#
function zstream_conf_get_value()
{
	local conf="$1"
	local attr="$2"
	
	retval=`grep $attr $conf |  sed "s/=/  /" | awk '{print $2}'`
}

function zstream_create_runtime_dirs()
{
	local basedir=$1
	
			
	if [ ! -d  $basedir/zstream ]; then mkdir $basedir/zstream ; fi
	if [ ! -d  $basedir/zstream/bin ]; then mkdir $basedir/zstream/bin ; fi
	if [ ! -d  $basedir/zstream/video-sources ]; then mkdir $basedir/zstream/video-sources ; fi
	if [ ! -d  $basedir/zstream/customers ]; then mkdir $basedir/zstream/customers ; fi
}






