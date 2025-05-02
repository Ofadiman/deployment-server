# Deployment Server

A Splunk Deployment Server is a centralized management component that automates the distribution and updating of configuration files, apps, and content to multiple Splunk instances (known as deployment clients) across your environment. It streamlines the process of managing large-scale Splunk deployments by allowing administrators to efficiently push updates and maintain consistency across all clients. This repository provides examples of various deployment server configurations to help you set up and manage your Splunk infrastructure effectively.

## Deployment Types

- [standalone](/standalone/readme.md) – Demonstrates how to deploy a single deployment server instance, connect three deployment clients (universal forwarders), and distribute apps to those clients.
- [cluster](/cluster/readme.md) – Demonstrates how to deploy two deployment server instances in cluster mode using a shared drive, connect two deployment clients (universal forwarders) to each server, and distribute apps to those clients.
- [local-deployment-apps](/local-deployment-apps/readme.md) – Demonstrates how to install Splunk apps during the Docker image build process.
- [leader-follower](/leader-follower/readme.md) - Demonstrates how to deploy a leader deployment server along with two follower deployment servers, which distribute apps to deployment clients connected to the follower deployment servers.
