#!/bin/bash
#
# runTests script REQUIRED ONLY IF additional application verification is 
# needed above and beyond helm tests.
#
# Pre-req environment: authenticated to cluster, kubectl cli install / setup complete, & chart installed

# Exit when failures occur (including unset variables)
set -o errexit
set -o nounset
set -o pipefail


# Setup and execute application test on installation
echo "Running application test"

# Create pre-requisite components
[[ `dirname $0 | cut -c1` = '/' ]] && installDir=`dirname $0`/ || installDir=`pwd`/`dirname $0`/

kubectl delete -f $installDir/test-pvc.yaml --ignore-not-found
kubectl apply -f $installDir/test-pvc.yaml

status=$(kubectl get pvc | grep  "cos-test-pvc" | awk '{print $2}')
counter=1
while [ $counter -le 5 ]
do
    status=$(kubectl get pvc | grep  "cos-test-pvc" | awk '{print $2}')
    if [[ $status == *"Bound"* ]]; then
        echo "PVC is in bound state"
        break
    else
       echo "PVC not in bound state"
       sleep 3
    fi
    echo "$counter out of 5 loops done"
    ((counter++))
done

if [[ $counter -le 5 ]]; then
    exit 0
else
    exit 1
fi
