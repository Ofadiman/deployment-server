# Leader-Follower Deployment

A **leader-follower deployment** is a Splunk deployment architecture featuring a single leader deployment server and one or more follower deployment servers. The leader deployment server centrally stores deployment apps and distributes them to the follower deployment servers, which act as deployment clients to the leader.

The leader deployment server is configured to distribute configuration apps to `$SPLUNK_HOME/etc/apps` directory and deployment apps to `$SPLUNK_HOME/etc/deployment-apps` directory on the follwers.

Universal Forwarders connect to the follower deployment servers and download Splunk apps from them, which allows to scale deployment fleet horizontally.
