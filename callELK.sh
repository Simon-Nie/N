#!/bin/bash

# Get the parameters
id=\$1
short_name=\$2

# Define the Elasticsearch and Kibana endpoints
elasticsearch_endpoint="http://localhost:9200"
kibana_endpoint="http://localhost:5601"

# Create the role
curl -X PUT "${elasticsearch_endpoint}/_security/role/${id}-${short_name}" -H 'Content-Type: application/json' -d"
{
  \"cluster\": [\"all\"],
  \"indices\": [
    {
      \"names\": [\"${id}*\"],
      \"privileges\": [\"all\"]
    }
  ]
}"



# Create the index pattern
curl -X POST "${kibana_endpoint}/api/index_patterns/index_pattern" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d"
{
  \"attributes\": {
    \"title\": \"${id}-${short_name}\",
    \"timeFieldName\": \"@timestamp\"
  }
}"


#!/bin/bash

# Get the parameters
id=\$1
short_name=\$2

# Define the Elasticsearch and Kibana endpoints
elasticsearch_endpoint="http://localhost:9200"
kibana_endpoint="http://localhost:5601"

# Create the space
curl -X POST "${kibana_endpoint}/api/spaces/space" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d"
{
  \"id\": \"${id}-${short_name}\",
  \"name\": \"${id}-${short_name}\"
}"

# Create the role
curl -X PUT "${elasticsearch_endpoint}/_security/role/${id}-${short_name}" -H 'Content-Type: application/json' -d"
{
  \"cluster\": [\"all\"],
  \"indices\": [
    {
      \"names\": [\"${id}*\"],
      \"privileges\": [\"all\"]
    }
  ],
  \"applications\": [
    {
      \"application\": \"kibana\",
      \"privileges\": [\"all\"],
      \"resources\": [\"space:${id}-${short_name}\"]
    }
  ]
}"

# Define the Elasticsearch and Kibana endpoints
elasticsearch_endpoint="http://localhost:9200"
kibana_endpoint="http://localhost:5601"

# Create the space
curl -X POST "${kibana_endpoint}/api/spaces/space" -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d"
{
  \"id\": \"${id}-${short_name}\",
  \"name\": \"${id}-${short_name}\"
}"

# Create the admin role
curl -X PUT "${elasticsearch_endpoint}/_security/role/${id}-${short_name}-admin" -H 'Content-Type: application/json' -d"
{
  \"cluster\": [\"all\"],
  \"indices\": [
    {
      \"names\": [\"${id}*\"],
      \"privileges\": [\"all\"]
    }
  ],
  \"applications\": [
    {
      \"application\": \"kibana\",
      \"privileges\": [\"all\"],
      \"resources\": [\"space:${id}-${short_name}\"]
    }
  ]
}"

# Create the readonly role
curl -X PUT "${elasticsearch_endpoint}/_security/role/${id}-${short_name}-readonly" -H 'Content-Type: application/json' -d"
{
  \"indices\": [
    {
      \"names\": [\"${id}*\"],
      \"privileges\": [\"read\"]
    }
  ],
  \"applications\": [
    {
      \"application\": \"kibana\",
      \"privileges\": [\"read\"],
      \"resources\": [\"space:${id}-${short_name}\"]
    }
  ]
}"

# Create the admin user
curl -X PUT "${elasticsearch_endpoint}/_security/user/${id}-${short_name}-admin" -H 'Content-Type: application/json' -d"
{
  \"password\" : \"password\",
  \"roles\" : [\"${id}-${short_name}-admin\"],
  \"full_name\" : \"Admin User\"
}"

# Create the readonly user
curl -X PUT "${elasticsearch_endpoint}/_security/user/${id}-${short_name}-readonly" -H 'Content-Type: application/json' -d"
{
  \"password\" : \"password\",
  \"roles\" : [\"${id}-${short_name}-readonly\"],
  \"full_name\" : \"Readonly User\"
}"
