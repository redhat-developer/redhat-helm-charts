# What's new in IBM MongoDB Based Helm Chart's

- Support for ppc64le architecture only.

## Breaking Changes

## Documentation

## Fixes

N/A

## Prerequisites

1. Kubernetes version >= 1.16.0-0
2. Helm version >= 3.0.0
3. The default images for IBM's MongoDB Based Helm Chart can be loaded from https://hub.docker.com/u/ibmcom/ibm-enterprise-mongodb-ppc64le
4. Create a persistent volume with access mode as 'Read write many' with minimum 10GB space.

## Version History

| Chart | Date            | Kubernetes Required | Image(s) Supported                           | Breaking Changes | Details                                                                                   |
| ----- | --------------- | ------------------- | -------------------------------------------- | ---------------- | ----------------------------------------------------------------------------------------- |
| 0.1.0 | Mar, 2021       | >=1.16.0-0          | ibm-enterprise-mongodb-ppc64le	       | N/A              | This is the version for IBM's MongoDB Based Helm Chart				      |
| 0.2.0 | May, 2021	  | >=1.16.0-0          | ibm-enterprise-mongodb-ppc64le               | N/A              | Fixes manual PVC name allotment							      |
| 0.3.0 | Feb, 2022       | >=1.16.0-0          | ibm-enterprise-mongodb-ppc64le               | N/A              | Fixes non-root isues and updates README.md                                                          |
