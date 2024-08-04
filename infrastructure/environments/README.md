# Environments

The resources contained with govern all the Infrastructure that runs
PMQs Cloud, this is mostly split into two key pieces: Primus & Commons.

This top level directory splits us down by the environment that Terraform
deploys to, i.e. a distinct Cloud Provider/Service. At present, we only use
Terraform Cloud and GCP but this can be expanded in future if we start to need/desire
other platforms.