# Breaking Changes

None

# What’s new in Chart Version 1.1.0

With version 1.1.0, the CatalogSource switches to living in icr.io/cpopen instead of docker.io/ibmcom. Added optional parameter `mirrorConfig` that deploys a `ImageContentSourcePolicy'

# What’s new in Chart Version 1.0.0

With ibm-operator-catalog-enablement chart version 1.0.0, the following  
features are available:

- Install of IBM Operator Catalog
- Install of IBMCS Operators

# Fixes

- None

# Prerequisites

Install [Helm client v3](https://cloud.ibm.com/docs/containers?topic=containers-helm#install_v3) on your local machine.

# Documentation

For install, follow instructions [here](https://ibm.biz/operator-catalog-readme).

# Version History

| Chart | Date | Kubernetes Required | Image(s) Supported | Breaking Changes | Details |
| ----- | ---- | ------------ | ------------------ | ---------------- | ------- |
| 1.0.0 | Jun 22, 2020| >=1.17.0 | latest | None | Initial release |
| 1.1.0 | March, 2021| >=1.17.0 | latest | None | Change CatalogSource location to icr.io/cpopen, Add optional mirrorConfig, Add 'Form' support for parameters |
