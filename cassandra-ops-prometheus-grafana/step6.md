In this step, we'll configure Grafana with a dashboard for the Pet Clinic app.
To do this we need to add a dashboard definition to the Grafana ConfigMap.

Start by opening the Pet Clinic dashboard definition just to see what it looks like - it's a bit long.

<div style="background-color:#cccccc"> **Open** `petclinic_dashboard.yaml`{{open}}</div>

Now, let's append that file to the ConfigMap manifest that defines the other Grafana dashboards.

```
cat dashboards_configmap.yaml petclinic_dashboard.yaml > updated_dashboard_configmap.yaml
```{{execute T1}}

If you really want to, you can look at the updated ConfigMap manifest (but be forewarned, it's really long).

<div style="background-color:#cccccc"> **Open** `updated_dashboard_configmap.yaml`{{open}}</div>

Let's update the values of the ConfigMap.

```
kubectl replace -f updated_dashboard_configmap.yaml
```{{execute T1}}


Return to the Grafana browser tab and hover over the _Dashboards_ icon on the left and click _Manage_ from the pop-up menu.
Or, to open a new browser tab to the correct page, click the following.

<div style="background-color:#cccccc">[Grafana Dashboards](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/grafana/dashboards)</div>


Then, select _Spring PetClinic Metrics_ (near the bottom of the list - if you don't see it, refresh the browser tab).

On this simple dashboard, you see the request latencies and the request activity for the Pet Clinic app.
Open a new browser tab to the Pet Clinic Pet Types page.

<div style="background-color:#cccccc">[Pet Clinic - Pet Types](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/pettypes)</div>


Refresh the page a few times to create some app request activity.
Now, go back to the Pet Clinic dashboard and see how your activity is reflected in the metrics - you may have to wait a minute or so for the dashboard to update.
Alternatively, see if you can figure out how to increase the dashboard refresh rate (Hint: look in the top-right corner of the dashboard).

## Amazing! We can monitor both Pet Clinic and Cassandra from Grafana!
