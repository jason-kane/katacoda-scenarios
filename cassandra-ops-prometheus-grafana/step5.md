Besides monitoring our Cassandra cluster, we can also monitor our app!

The example Pet Clinic app exports metrics that we can scrape from Prometheus and view in Grafana.
Let's create a ServiceMonitor for our app.

```
kubectl apply -f petclinic_service_monitor.yaml
```{{execute T1}}

Let's look at the manifest we just applied.

<div style="background-color:#cccccc"> **Open** `petclinic_service_monitor.yaml`{{open}}</div>


Remember, a ServiceMonitor is a Prometheus Operator CRD made to be an interface between Prometheus and Kubernetes services.
Notice that we can use the name of the CRD (_ServiceMonitor_) as the _kind_.
<br>

As you scroll down through the manifest, you also see that we have configured the ServiceMonitor to talk to the Pet Clinic backend service with a path of _/actuator/prometheus_.
<br>

Return to the Prometheus browser tab and go to the _Targets_ page (select _Status_ and the _Targets_).
Or, click the following to open a new tab to the _Targets_ page.

<div style="background-color:#cccccc">[Prometheus Targets](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/prometheus/targets)</div>


You may need to refresh the page a few times, but eventually, at the bottom of the list, you will see the Pet Clinic ServiceMonitor target.

## Wow! ServiceMonitor makes it easy to add the app as a Prometheus endpoint!
