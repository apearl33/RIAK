# Load the data into Riak 
./lab2b/load_data.erl ./lab2b/goog.csv

# Return the entire data set
curl -vSsf -X POST http://riak:8098/mapred -H 'Content-Type: application/json' -d \
'{"inputs":"goog",
"query":[{"map":{"language":"javascript",
"name":"Riak.mapValuesJson",
"keep":true}}]}'

# 1. Write a map-only query for our google data that finds all the days where the low was less than $450.00.

curl -XPOST http://riak:8098/mapred \
-H 'Content-Type: application/json' \
-d '{
"inputs":"goog",
"query":[{"map":{"language":"javascript",
"source":"function(value, keyData, arg) {
var data = Riak.mapValuesJson(value)[0];
if(data.Low && data.Low < 450.00)
return [value.key];
else
return [];
}"}}]}'

# 2. Write a map-only query for our google data that finds all of the days where the close was lower than the open.
# (You will need to write your own map phase function.
# You can modify the one given for 1.)

curl -XPOST http://riak:8098/mapred \
-H 'Content-Type: application/json' \
-d '{
"inputs":"goog",
"query":[{"map":{"language":"javascript",
"source":"function(value, keyData, arg) {
var data = Riak.mapValuesJson(value)[0];
if(data.Open && data.Close && data.Close < data.Open)
return [value.key];
else
return [];
}"}}]}'

# 3. To submit your lab, push a lab2b.sh script with the appropriate curl commmands to the drone Lab2b folder.
