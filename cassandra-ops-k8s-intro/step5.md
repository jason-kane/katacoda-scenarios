Cassandra operations management used to be a bit daunting.
One aspect of Cassandra management that used to be especially difficult to manage was _repair_.
But, thanks to _Reaper_, we can automate this task.

<details>
<hr>
  <summary style="color:teal">What is repair?</summary>
Cassandra's architecture is highly distributed and scalable due to data replication.
Whenever you replicate data, it is possible for the replicas to be out of sync.
Repair (an unfortunate name since nothing is really broken) is the process of making sure all data replicas are consistent.
You can read more [here](https://cassandra.apache.org/doc/latest/operating/repair.html).
<hr>
</details>

Let's look at the Reaper UI by clicking the following.

<div style="background-color:#cccccc">[Reaper](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/reaper/webui)</div>

Let's take a quick tour of Reaper by scheduling a repair task.
Click _Schedules_.

![Reaper main UI](./assets/ReaperMain.png)

Click _Add schedule_ to expand the form.

![Add schedule](./assets/AddSchedule.png)

Fill out the form and click _Add schedule_.

![Schedule form](./assets/ScheduleForm.png)

In a minute or so, you can see that the repair task has started by clicking _Clusters_.

![Running repair](./assets/RunningRepair.png)

## I get it! Reaper makes Cassandra repair easy!
