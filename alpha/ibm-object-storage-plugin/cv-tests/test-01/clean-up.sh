#!/bin/bash
#
# Clean-up script REQUIRED ONLY IF 'helm delete <releasename> --purge' for
# this test path will result in orphaned components.
#
# For example, if PersistantVolumes (PVs) are created as pre-requisite to chart installation
# they will need to be deleted post helm delete.
#
# Parameters :
#   -c <chartReleaseName>, the name of the release used to install the helm chart
#
# Pre-req environment: authenticated to cluster & kubectl cli install / setup complete

# Exit when failures occur (including unset variables)
set -o errexit
set -o nounset
set -o pipefail

echo "Run cleanup..."
kubectl delete pod -n kube-system ibmcloud-object-storage-driver-test --ignore-not-found
kubectl delete pod ibmcloud-object-storage-driver-test --ignore-not-found
kubectl delete pvc "cos-test-pvc" --ignore-not-found
kubectl delete sc ibmc-s3fs-default --ignore-not-found
