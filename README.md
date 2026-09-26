# helm-charts
## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

helm repo add givanov https://givanov.github.io/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
givanov` to see the charts.

To install the apcupsd-exporter chart:

    helm install my-apcupsd-exporter givanov/apcupsd-exporter

To install the nebula-sync chart (synchronizes the configuration of a
primary Pi-hole v6 instance to one or more replicas): put the target
credentials into a secret and reference it, so the passwords stay out of
your values:

    kubectl create secret generic pihole-creds \
      --from-literal=primary='https://pihole.example.com|adminpass' \
      --from-literal=replicas='https://pihole2.example.com|adminpass'

    helm install my-nebula-sync givanov/nebula-sync \
      --set sync.cron='0 * * * *' \
      --set sync.runGravity=true \
      --set primary.secretKeyRef.name=pihole-creds \
      --set replicas.secretKeyRef.name=pihole-creds

To uninstall the chart:

    helm delete my-apcupsd-exporter