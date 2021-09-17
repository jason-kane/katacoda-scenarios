*As your Kubernetes cluster (and your Cassandra cluster) grows, you need to know how it is behaving.
This is where Prometheus and Grafana come in!*

This scenario picks up where the scenario named _Managing Cassandra Clusters in Kubernetes Using the Cass-Operator_ leaves off.
If you have not yet worked through that scenario, you may want to check it out [here](https://katacoda.com/datastax/courses/cassandra-ops-k8s/cassandra-ops-cass-operator).

In this scenario, we'll:
- Set up a Cassandra cluster running on Kubernetes and install the example Pet Clinic app
- Install and configure Prometheus to monitor Cassandra and Kubernetes
- Install and configure Grafana to view metrics for Cassandra and Kubernetes
- Configure Prometheus and Grafana to monitor our Pet Clinic app


---

<p><span style="color:teal">***Note:***</span> *When using Kubernetes and Cassandra, it is important to recognize that we are working with two types of clusters:
<ul>
  <li>Kubernetes clusters - a set of machines called Kubernetes nodes</li>
  <li>Cassandra clusters - a set of those Kubernetes nodes that host and run the Cassandra software</li>
</ul>
*</p>

---



## You're going to love Prometheus and Grafana!
