#!/bin/bash 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# sar_graph.sh - Makes pretty web pages from sar
# Written by Damian Zaremba - Released under GPLv3
# Extended by Paul Buetow - Released under GPLv3
#													
# Please note this is a quick hack to demonstrate it can be done 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

SAFILE=$1
HTML_DST=$2
GNU_PLOT=$(whereis gnuplot | cut -d' ' -f2)
SADF=$(whereis sadf | cut -d' ' -f2)
GRAPH_TYPE="image"
#GRAPH_TYPE="ascii"
POST_COMMANDS=''

usage () {
	echo "Usage: $0 <SAFILE> <GRAPHDEST>"
}

# Some functions for writing out the html, just incase you ever want to make it pretty or something..
make_header () {
	HTML="<html><head><title>Sar graphs!</title></head><body>"$HTML;
}

make_footer () {
	HTML=$HTML"</body></html>";
}

make_graph () {
	if [ -z "$1" ]; then return 1; else title=$1; fi
	if [ -z "$2" ]; then return 1; else format=$2; fi
	if [ -z "$3" ]; then return 1; else field=$3; fi

	echo "Making $title"
	output_file=$(echo $title | sed 's/ /_/g')

	if [ "$GRAPH_TYPE" == "image" ];
	then
		output_format="png"
		output_file=$output_file".png"
		output_size="set term png size 1200,300"
	else
		if [ "$GRAPH_TYPE" == "ascii" ]
		then
			output_format="dumb"
			output_file=$output_file".txt"
			output_size=""
		fi
	fi

	output_path=$HTML_DST"/"$output_file
	dat_file=$(mktemp /tmp/sar_graph.XXX)
	echo "Data file: $dat_file"
	$SADF -- $format $SAFILE | awk '/'$field'/ {print $3" "$6}' > $dat_file
	
	echo "set terminal $output_format;
	$output_size;
	set title '$title';
	set xdata time;
	set timefmt '%s';
	set xlabel 'Time';
	plot '$dat_file' using 1:2 with lines title '$title';" | $GNU_PLOT > $output_path
	echo "Outputted $output_file"
	
	if [ "$GRAPH_TYPE" == "image" ];
	then
		HTML=$HTML'<img src="'$output_file'" alt="'$title'" />'
	else
		if [ "$GRAPH_TYPE" == "ascii" ]
		then
		HTML=$HTML'<iframe src="'$output_file'" width="800px" scrolling="no"></iframe>'
		fi
	fi
}

# Check safile exists
if [ ! -f "$SAFILE" ];
then
	usage
	exit 1;
fi

# Check destination argument exists
if [ -z "$HTML_DST" ];
then
	usage
	exit 1;
fi

# Check gnuplot is all good
if [ ! -x "$GNU_PLOT" ];
then
	echo "Please ensure gnuplot is avaible on \$PATH"
	exit 1
fi

# Check sadf is all good
if [ ! -x "$SADF" ]
then
	echo "Please ensure sadf is avaible on \$PATH"
	exit 1;
fi

# Check graph type
if [ "$GRAPH_TYPE" != "image" ] && [ "$GRAPH_TYPE" != "ascii" ]
then
	echo "Invalid graph type specified"
	exit 1;
fi

# Main script stuff

if [ -d $HTML_DST ]; then
	find $HTML_DST -name \*.png | xargs rm
else
	mkdir -p "$HTML_DST"
fi

HTML=""

# Mem stuff
make_graph "Mem used perc" "-r" "%memused"
make_graph "Swap used perc" "-r" "%swpused"

# CPU stuff
for i in user nice system iowait idle; do
	make_graph "CPU $i" "-u" "%$i"
done

# load avg
make_graph "1min Load avg" "-q" "ldavg-1"
make_graph "5min Load avg" "-q" "ldavg-5"
make_graph "15min Load avg" "-q" "ldavg-15"

# Network
for i in rxpck txpck rxkB txkB rxcmp txcmp rxmcst; do
	make_graph "Network eth0 ${i} per sec" "-n DEV" "eth0.*${i}.s"
done

# Network Errors
for i in rxerr txerr coll rxdrop txdrop txcarr rxfram rxfifo txfifo; do
	make_graph "Network errors eth0 ${i} per sec" "-n EDEV" "eth0.*${i}.s"
done

# Make the html index
echo "Writing $HTML_DST/index.html"
make_header; make_footer
echo $HTML > "$HTML_DST/index.html"

# Post stuff
`$POST_COMMANDS`

# Tidy
rm -rf "$base_dir" /tmp/sar_graph*
