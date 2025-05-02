## Cluster Deployment

Cluster deployment enables [up to three deployment servers](https://docs.splunk.com/Documentation/Splunk/9.4.1/Updating/Implementascalabledeploymentserversolution#:~:text=The%20maximum%20number%20of%20deployment%20servers%20in%20a%20cluster%20is%20limited%20to%203.) to communicate via a shared drive.

Deployment apps are stored in the `$SPLUNK_HOME/etc/deployment-apps` directory, which is mounted to all deployment servers. Similarly, client events are stored in the `$SPLUNK_HOME/var/log/client_events` directory, also mounted across all deployment servers.

Each deployment server writes changes to `serverclass.conf` to a temporary file. Other deployment servers then use this file to asynchronously update their own `serverclass.conf`. Synchronization of `serverclass.conf` across deployment servers can take up to [60 seconds](https://docs.splunk.com/Documentation/Splunk/9.4.1/Updating/Implementascalabledeploymentserversolution#:~:text=It%20can%20take%20up%20to%2060%20seconds%20for%20the%20deployment%20servers%20to%20sync%20server%20class%20updates.).

Once synchronization is complete, all deployment servers will have an identical `serverclass.conf` file and will display the same applications and clients that have performed phone home operations.
