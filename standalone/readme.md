# Standalone Deployment

Standalone deployment is a type of deployment in which there is only 1 deployment server to which other splunk instances are connected.

# Installing apps

Apps are downloaded and installed during docker image build process. Credentials used to authenticate to splunkbase are stored in `secrets` directory, and mounted to Dockerfile during build process as [docker secrets](https://docs.docker.com/compose/how-tos/use-secrets/).

- `splunkbase_username.txt` - The splunkbase username (in the form of an email address).
- `splunkbase_password.txt` - The password used for the provided email address.
