*This scenario introduces the components of a cloud-native application deployed with Cassandra in Kubernetes, including the components of the K8ssandra ecosystem.*

<details>
  <summary style="color:teal">What is K8ssandra?</summary>
<hr>

According to the K8ssandra website, K8ssandra provides a production-ready platform for running Apache Cassandra on Kubernetes. This includes automation for operational tasks such as repairs, backups, and monitoring. Read more [here](https://k8ssandra.io/).
<hr>
</details>


In this scenario, we will:
- Install the K8ssandra ecosystem
- Deploy the Pet Clinic app
- Use Prometheus to collect system metrics
- Use Grafana to monitor the Cassandra database
- Use Reaper to manage Cassandra data replica consistency
- Access Cassandra using Stargate APIs

We'll deploy the example Pet Clinic app on K8ssandra.
Then we'll take a tour of the K8ssandra ecosystem.

Let's get started!
