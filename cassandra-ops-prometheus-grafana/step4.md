In the previous step, we configured Prometheus to capture metrics about the Cassandra cluster.
In this step, we'll configure some dashboards in Grafana so we can view those metrics.

We perform this configuration by creating a Kubernetes _ConfigMap_.

<details>
  <summary style="color:teal">What is a Kubernetes ConfigMap?</summary>
  <hr>
  A ConfigMap is a set of key/value pairs that Kubernetes manages.
  Other Kubernetes components (like pods, or services or even Grafana) access the ConfigMaps to obtain runtime configuration information.
  Grafana uses a ConfigMap to store the list and configurations of the dashboards it displays.
  As such, we can modify the dashboards at runtime by changing the values in the ConfigMap.
  <br>
  Here's a common point of confusion: we can use _yaml_ files to create ConfigMaps, but the _yaml_ file is NOT the ConfigMap.
  The ConfigMap is stored within the Kubernetes space.
  <br>
  Note that a Kubernetes _Secret_ is like a ConfigMap (i.e., it's a set of key/value pairs), except the values are encoded.
  Use Secrets, instead of ConfigMaps, for storing things like passwords.
  For example, if you carefully inspect the _petclinic.yaml_ file, you will find a _SecretKeyRef_ that tells the Pet Clinic backend to find the Cassandra username and password that is stored in a Secret.
  <hr>
</details>

Here's the command to create the ConfigMap from the _yaml_ file.

```
kubectl create -f dashboards_configmap.yaml
```{{execute T1}}

You can see that the command applies a manifest file named <i>dashboards_configmap.yaml</i>.
We can look at this manifest.

<div style="background-color:#cccccc"> **Open** `dashboards_configmap.yaml`{{open}}</div>

This is also a pretty long and scary file.
But don't worry, we aren't going to drag you through it.
We will tell you that it is a list of dashboard descriptions.
Let's take a look at the dashboards we have just introduced.
<br>
Go to the Grafana browser tab and hover over the _Dashboards_ icon on the left and click _Manage_ from the pop-up menu.
Or, just click the following link to take you there in a new browser tab.

<div style="background-color:#cccccc">[Grafana Dashboards](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/grafana/dashboards)</div>
<br>
Then, select _Cassandra Overview_ from the list of dashboards.

This dashboard shows you useful metrics about your Cassandra database.
You may notice the metrics are divided into the following sections:
- Request Throughputs
- Nodes Status
- Data Status
- Cassandra Internals
- Hardware/Operating System
- JVM/Garbage Collection


---

<p><span style="color:teal">***Note:***</span> *
You may notice that the Cassandra Node status is incorrect.
This dashboard is part of the open source K8ssandra project and this is a known bug in that project.

You can check out the status of the bug [here](https://github.com/k8ssandra/k8ssandra/issues/198).

Or, the bug may be fixed by now - that's the beauty of open source!
*</p>

---


Each of the sections of the dashboard represents important things you want to consider when managing a Cassandra cluster.
You are probably familiar with Hardware and Operating System metrics, so scroll down to that section and see if you can determine what the CPU utilization is and how much memory is currently being used.


## Fantastic! Now, we can see what's happening in our Cassandra cluster!
