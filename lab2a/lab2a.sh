# 1. Add 6 movies to the database from at least 2 genres (comedy, drama, horror).
# You can use imdb.com to find the information about your selected movies.

curl -v -X PUT http://riak:8098/riak/movies/Parasite \
-H "Content-Type: application/json" \
-d '{"releasedate" : "2019", "runningtime": "2h12min", "genre": "thriller"}'

curl -v -X PUT http://riak:8098/riak/movies/Broker \
-H "Content-Type: application/json" \
-d '{"releasedate": "2022", "runningtime": "2h9min", "genre": "drama"}'

curl -v -X PUT http://riak:8098/riak/movies/Minari \
-H "Content-Type: application/json" \
-d '{"releasedate": "2020", "runningtime": "1h55min", "genre": "drama"}'

curl -v -X PUT http://riak:8098/riak/movies/Interstellar \
-H "Content-Type: application/json" \
-d '{"releasedate": "2014", "runningtime": "2h49min", "genre": "adventure"}'

curl -v -X PUT http://riak:8098/riak/movies/Frozen \
-H "Content-Type: application/json" \
-d '{"releasedate": "2013", "runningtime": "1h42min", "genre": "animation"}'

curl -v -X PUT http://riak:8098/riak/movies/Inception \
-H "Content-Type: application/json" \
-d '{"releasedate": "2010", "runningtime": "2h28min", "genre": "action"}'
	
# 2. Delete one of the movie records.
	
curl -i -X DELETE http://riak:8098/riak/movies/Inception

# 3. Our movie rental business has 3 branches (East, West, South).
# Create these branches. The bucket should be branches.
# The value should be json with the name of the branch.
# Link each of the remaining five movies to at least one of the branches.
# At least one of the movies should link to two branches (i.e. that movie can be foud at 2 stores).
# Come up with an intuitive riaktag such as holds.
# For example, we can lookup if a customer calls looking for a particular movie, and that movie is available at another branch.

curl -X PUT http://riak:8098/riak/branches/East \
-H "Content-Type: application/json" \
-H "Link:</riak/movies/Interstellar>;riaktag=\"holds\", </riak/movies Parasite>;riaktag=\"holds\"" \
-d '{"branchName" : "East"}'
	
curl -X PUT http://riak:8098/riak/branches/West \
-H "Content-Type: application/json" \
-H "Link: </riak/movies/Frozen>; riaktag=\"holds\", </riak/movies Broker>; riaktag=\"holds\"" \
-d '{"branchName" : "West"}'

curl -X PUT http://riak:8098/riak/branches/South \
-H "Content-Type: application/json" \
-H "Link: </riak/movies/Frozen>; riaktag=\"holds\", </riak/movies Minari>; riaktag=\"holds\"" \
-d '{"branchName" : "South"}'

curl -X PUT http://riak:8098/riak/movies/Frozen \
-H "Content-Type: application/json" \
-H "Link: </riak/branches/South>; riaktag=\"belongs\", </riak/branches West>; riaktag=\"belongs\"" \
-d '{"releasedate": "2013", "runningtime": "1h42min", "genre": "animation"}'
	
curl -v -X PUT http://riak:8098/riak/movies/Interstellar \
-H "Content-Type: application/json" \
-H "Link: </riak/branches/East>; riaktag=\"belongs\"" \
-d '{"releasedate": "2014", "runningtime": "2h49min", "genre": "adventure"}'
	
curl -v -X PUT http://riak:8098/riak/movies/Broker \
-H "Content-Type: application/json" \
-H "Link: </riak/branches/West>; riaktag=\"belongs\"" \
-d '{"releasedate": "2022", "runningtime": "2h9min", "genre": "drama"}'
	
curl -v -X PUT http://riak:8098/riak/movies/Parasite \
-H "Content-Type: application/json" \
-H "Link: </riak/branches/East>; riaktag=\"belongs\"" \
-d '{"releasedate": "2019", "runningtime": "2h12min", "genre": "thriller"}'
	
curl -v -X PUT http://riak:8098/riak/movies/Minari \
-H "Content-Type: application/json" \
-H "Link: </riak/branches/South>; riaktag=\"belongs\"" \
-d '{"releasedate": "2020", "runningtime": "1h55min", "genre": "drama"}'

# 4. Download a picture for one of the movies and add it to a bucket named images with the key being the picture name.
# Then link it to the movies.
# Images can be found by searching Google Images and using the Advanced Search feature set to usage rights to "free to use/share" (so as not to violate any copyrights).

curl -X PUT http://riak:8098/riak/images/broker.jpeg \
-H "Content-type: image/jpeg" \
-H "Link: </riak/movies/Broker>; riaktag=\"image\"" \
--data-binary @broker.jpeg

# 5. Run queries listing all the buckets, all the movies found in each branch, and finally of the movie with the picture and its branch.

curl -i http://riak:8098/buckets?buckets=true
	
curl -i http://riak:8098/riak/branches/East/movies,_,_
curl -i http://riak:8098/riak/branches/West/movies,_,_
curl -i http://riak:8098/riak/branches/South/movies,_,_
	
curl -i http://riak:8098/riak/images/perk.jpg/movies,_,_

# 6. All the curl commands need to be tested first on your system and then saved as lab2a.sh.
# The hostname in the file should be changed to http://riak:8098/riak/
# This file and the picture used in Step 4 will be pushed to GitHub for submission.
