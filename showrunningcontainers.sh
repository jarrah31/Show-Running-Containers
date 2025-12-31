#!/bin/bash
# show the running containers and the ports in use in a nice tabulated list
# NB - there is an exceptions section to modify the output for apps that don't play nicely (initially just watchtower)
# v1.0

#  functions
get_index (){
	find="$1"
	echo "$header"  | grep -b -o "$find" | cut -d: -f1
}

get_field () {
	# takes beginning and ending params to output a field from a string
	start_index=$1
	end_index=$2
	echo "$docker_line" | cut -c$start_index-$end_index
}

hostn=$(hostname)
# get docker ps output
docker_ps_output=$(docker ps )
# Extract the header line (first line)
header=$(echo "$docker_ps_output" | head -n 1)
# Extract the rest of the output (excluding the header)
docker_ps=$(echo "$docker_ps_output" | tail -n +2)

# work out where each field starts from the header line
image_index=$(get_index IMAGE)
command_index=$(get_index COMMAND)
created_index=$(get_index CREATED)
status_index=$(get_index STATUS)
ports_index=$(get_index PORTS)
names_index=$(get_index NAMES)

echo
#ips=$(ip a | grep 192.168.199\.  | tr "/"  " " | awk '{print $2}')
ips=$(ip -br -4 addr show \
| grep -Ev 'lo|docker|veth|br-|virbr' \
| awk '{print $1, $3}' \
| sed 's#/.*##')
echo "Running Docker Containers:"
echo

echo "$docker_ps" | while read -r docker_line; do
	d_image=$(echo $(get_field $image_index $command_index))
	d_command=$(echo $(get_field $command_index $created_index))
	d_created=$(echo $(get_field $created_index $status_index) | tr " " "~")
	d_status=$(echo $(get_field $status_index $ports_index) | tr " " "~")
	d_ports=$(echo $(get_field $ports_index $names_index | sed -e 's/->.*\//\//' -e 's/0.0.0.0://' -e 's/, /,/g' -e 's/,:::.*//') | tr " " "~")
	d_name=$(echo $docker_line | awk '{print $NF}') 

	# exceptions:
	# watchtower says it is using port 8080,but it doesn't unless you have enabled the remote http api - who does that…
	[[  "$d_name" == "watchtower" ]] && d_ports="[excluded]"
	echo "$hostn: $d_name $d_image $d_created $d_status $d_ports"

done |  column -t | tr "~" " " | sort
echo
echo "Server IPs:"
echo "$ips"
echo
