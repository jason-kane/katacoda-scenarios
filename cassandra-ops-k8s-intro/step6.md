If you are building cloud-native apps, you want to access Cassandra using microservices.
But, building microservices a is tedious step you'd like to avoid.
Stargate, which comes with K8ssandra, gives you REST, GraphQL and Document APIs.

In this scenario, we'll try out some of Stargate's APIs.


To use the Stargate APIs, we use the Stargate Auth API to exchange the Cassandra credentials for an auth token.
The Cassandra credentials are stored in a Kubernetes secret, so let's retrieve them by clicking the following.

```
# extract the username
export CASS_USER=\
$(kubectl get secret k8ssandra-cluster-a-superuser -o jsonpath="{.data.username}"\
| base64 --decode)
# extract the password
export CASS_PASS=\
$(kubectl get secret k8ssandra-cluster-a-superuser -o jsonpath="{.data.password}"\
| base64 --decode)
```{{execute}}

We stored the credentials in variables.
Review the contents of the variables by clicking the following.

```
printf "${GREEN}Username is $CASS_USER${NC}\n"
printf "${GREEN}Password is $CASS_PASS${NC}\n"
```{{execute}}


You see that the username is _k8ssandra-cluster-a-superuser_ (which also happens to be the name of the secret).
The password is a random string.

Now, we use the credentials to get an auth token.
The following command retrieves an auth token from the Stargate auth API.

```
curl -L -X POST 'http://localhost:80/v1/auth'    -H 'Content-Type: application/json'    --data-raw '{
     "username": "'"$CASS_USER"'",
     "password": "'"$CASS_PASS"'"
 }' | jq
 ```{{execute}}

So that we don't have to copy and paste this token, let's run that same command and store the resulting token in a variable by clicking the following.

```
export AUTH_TOKEN=$(curl -L -X POST 'http://localhost:80/v1/auth'    -H 'Content-Type: application/json'    --data-raw '{
     "username": "'"$CASS_USER"'",
     "password": "'"$CASS_PASS"'"
 }' | jq -r '.authToken')
```{{execute}}

You can inspect the token value by clicking the following:

```
printf "${GREEN}Auth token is $AUTH_TOKEN${NC}\n"
```{{execute}}

Armed with the auth token, we can access one of the Pet Clinic tables.
The following cURL command retrieves the list of pet types from the Stargate REST API.
Note that this is the same query the Pet Clinic app uses, except the app uses its own microservice instead of using Stargate.

```
curl -L -X GET \
http://localhost:80/v2/keyspaces/spring_petclinic/petclinic_reference_lists/pet_type \
--header "x-cassandra-token: ${AUTH_TOKEN}" | jq
```{{execute}}

Stargate offers several API protocols.
For example, the following command retrieves the same list of pet types using Stargate's GraphQL API.

```
curl http://localhost:80/graphql/spring_petclinic \
    --header "Accept-Encoding: gzip, deflate, br" \
    --header "Content-Type: application/json" \
    --header "Accept: application/json" \
    --header "Connection: keep-alive" \
    --header "DNT: 1" \
    --header "Origin: https://localhost" \
    --header "x-cassandra-token: ${AUTH_TOKEN}" \
    --data '{"query":"query petTypes {petclinic_reference_lists(value: {list_name: \"pet_type\"}) {values {values}}}"}' | jq
```{{execute}}

Stargate provides other APIs, but we won't cover them in this introduction.
However, you get the idea - since K8ssandra includes Stargate, you get a bunch of useful APIs as part of your Cassandra ecosystem.
<br>
## Hey! Stargate gives me APIs!
