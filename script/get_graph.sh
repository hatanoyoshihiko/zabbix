#!/bin/bash

user=Admin
password=zabbix
url=http://192.168.11.200/zabbix/api_jsonrpc.php
graph_url="http://192.168.11.200/zabbix/chart2.php?graphid="$graph_id"&period=43200"

get_token () {
curl -s -XPOST $url \
-H "Content-Type: application/json-rpc" \
-d '{"jsonrpc": "2.0", "method": "user.login", "params": {"user": "'$user'","password": "'$password'"},"id": 1}' | \
jq -r .result
}

get_host_id () {
curl -s -XPOST $url \
-H "Content-Type: application/json-rpc" \
-d '{"jsonrpc":"2.0", "method":"host.get", "id":1, "auth":"'$token'", "params": {}}' | \
jq -r '.result[] | [.hostid, .host] | @csv' | \
awk -F, '{print $1}' | sed -e 's/"//g'
}

get_item_id () {
curl -s -XPOST $url \
-H "Content-Type: application/json-rpc" \
-d '{"jsonrpc":"2.0", "method":"item.get", "id":1, "auth":"'$token'", "params": {}}' | \
jq -r '.result[] | [.itemid, ._key, .name, .hostid] | @csv' | \
awk -F, '{print $1,$4}' |\
sed -e 's/"//g'
}

get_graph_id () {
for i in `echo $host_id`
do
	curl -s -XPOST $url \
	-H "Content-Type: application/json-rpc" \
	-d '{"jsonrpc":"2.0", "method":"graph.get", "id":1, "auth":"'$token'", "params": {"output": "extend", "hostids": "'$i'", "sortfield": "name"}}' | \
	jq -r '.result[].graphid'
done
}

get_graph () {
CNT=0
while read line
do
	curl -s -XGET -b zbx_sessionid=$token "http://192.168.11.200/zabbix/chart2.php?graphid=$graph_id&period=43200" > $host_id.png
done < `cat $host_id`
}

token=`get_token`
hostid=`get_host_id`
itemid=`get_item_id`
graph_id=`get_graph_id`

get_graph
