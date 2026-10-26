# Automated development release

Merges to `main` run tests, publish an immutable `linux/arm64` image to the
private `courier/agent-gateway` Amazon ECR repository, and use the Courier Dev
Release Bot GitHub App to update the image tag in `courier-common`.

The bot creates and automatically merges a release PR for the development
environment. Argo CD observes that central GitOps commit and deploys the exact
SHA-tagged image to K3s. The deployed image never uses `latest`.

The workflow requires these repository secrets:

- `COURIER_RELEASE_APP_ID`
- `COURIER_RELEASE_APP_PRIVATE_KEY`

The GitHub App needs access to the `courier-common` repository with contents
and pull-request write permissions.
