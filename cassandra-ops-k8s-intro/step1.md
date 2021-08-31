In this step we'll install K8ssandra and deploy the example app.

<details>
<hr>
  <summary style="color:teal">Want to know what is going on in the terminal window?</summary>
We are setting up a Kubernetes cluster for you. The cluster consists of an admin node and three worker nodes. We will run the entire cluster in a single container using something called kind.

<details>
  <summary style="color:teal">What is `kind`?</summary>
<hr>

`kind` is Kubernetes running _inside_ a Docker container.
As you know, most people use Kubernetes to manage systems of Docker containers.
So, `kind` is a Docker container that runs Kubernetes to manage other Docker containers - it's a bit recursive.
<br><br>
We use `kind` so we can create a many-node Kubernetes cluster on a single machine.
`kind` is great because it's relatively lightweight, easy to install and easy to use.
<br><br>
For your reference, here are the commands we used to install `kind`.
<br>

```
curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-$(uname)-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind
```

<hr>

</details>

<hr>
</details>

Once the cluster is ready, you can launch K8ssandra using Helm by clicking the following.

```
# Deploy K8ssandra
helm install k8ssandra-cluster-a k8ssandra/k8ssandra \
  -f config-values.yaml
```{{execute T1}}

<details>
  <summary style="color:teal">What is `Helm`?</summary>
<hr>

Helm is a package manager (like `apt` or `yum`) for Kubernetes.
Helm allows you to install and update Kubernetes applications.
You will notice in the previous command, the sub-command is _install_ followed what we will name the installed package and the _chart_ used to specify the installation.
A chart is a specification file we use to tell Helm how to do the installation.
Helm downloads the charts from a Helm repo.
We'll see more about this later in the course, but you can read more [here](https://helm.sh/).
<hr>

</details>

Now, let's wait for the Cassandra to completely initialize.
The following command will complete when the Cassandra database is ready (this may take a minute or two).

```
# Wait for Cassandra to initialize
kubectl wait \
  --for=condition=Ready cassandradatacenter/dc1 \
  --timeout=240s
```{{execute T1}}

<details>
  <summary style="color:teal">What is `kubectl`?</summary>
<hr>

`kubectl` is the command you use to interact with your Kubernetes cluster.
It is a very versatile command with many sub-commands and options.
Read more [here](https://kubernetes.io/docs/reference/kubectl/overview/).
<hr>

</details>

Once the previous command completes, you have a running Cassandra database inside the K8ssandra ecosystem.
Let's launch the app using Kubernetes by clicking the following.

```
# Deploy the Pet Clinic app
kubectl apply -f petclinic.yaml
```{{execute T1}}

<details>
  <summary style="color:teal">How does Kubernetes use the _yaml_ files (like _petclinic.yaml_)?</summary>
<hr>

The magic of Kubernetes is its declarative nature.
You describe what you want your system to look like and Kubernetes figures out the how to make it so.
The _yaml_ files that you use in Kubernetes are called _manifests_ and are the declarative description of the components within your Kubernetes cluster.

We'll look into this _petclinic.yaml_ file later in this course, but if you are curious, you can take a look at the file by clicking the following.

```
cat petclinic.yaml
```{{execute T2}}

<hr>
</details>

It may take another minute for the app to make the initial connection to Cassandra.
The following commands will wait for a successful connection.

Please be patient as it takes a little while for the app to completely initialize and make the connection to the database.

```
# Waiting for the app pod to be ready
kubectl wait \
  --for=condition=Ready pod \
  --selector=app=petclinic-backend \
  --timeout=90s

# Waiting for the app to connect to Cassandra
while [ $(curl localhost:80/petclinic/api/pettypes 2> /dev/null | wc -l) -gt 0 ];
  do
    sleep 1
  done
```{{execute T1}}

## Excellent! we've deployed the PetClinic app with K8ssandra!
