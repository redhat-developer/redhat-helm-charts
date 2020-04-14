###############################################################################
# Licensed Materials - Property of IBM.
# Copyright IBM Corporation 2018. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Contributors:
#  IBM Corporation - initial API and implementation
###############################################################################
#!/bin/bash
#
#

# Exit when failures occur (including unset variables)
set -o errexit
set -o nounset
set -o pipefail

# Check kubectl is installed
command -v kubectl > /dev/null 2>&1 || { echo "kubectl pre-req is missing."; exit 1; }

echo "Run pre-install cleanup..."
# kubectl delete pod -n kube-system ibmcloud-object-storage-driver-test \
#        --ignore-not-found

# Perform complete clean-up
for scname in $(kubectl get StorageClass -l app=ibmcloud-object-storage-plugin \
        -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
do
    echo "removing StorageClass =>  $scname"
    kubectl delete StorageClass ${scname} --ignore-not-found
done

for clsrolebinding in $(kubectl get ClusterRoleBinding --all-namespaces \
        -l app=ibmcloud-object-storage-plugin \
        -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
do
    echo "removing ClusterRoleBinding => $clsrolebinding"
    kubectl delete ClusterRoleBinding ${clsrolebinding} --ignore-not-found
done

for clsrole in $(kubectl get ClusterRole --all-namespaces \
        -l app=ibmcloud-object-storage-plugin \
        -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
do
    echo "removing ClusterRole => $clsrole"
    kubectl delete ClusterRole ${clsrole} --ignore-not-found
done

for rolebinding in $(kubectl get RoleBinding --all-namespaces \
        -l app=ibmcloud-object-storage-plugin \
        -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}')
do
    echo "RoleBinding => {$rolebinding}"
    if [[ ! -z "$rolebinding" ]]; then
        nsname=$(echo $rolebinding | awk '{ print $1 }')
        rbname=$(echo $rolebinding | awk '{ print $2 }')
        if [[ ! -z "$rbname" ]]; then
            echo "removing RoleBinding => ${nsname}/${rbname}"
            kubectl delete RoleBinding -n ${nsname} ${rbname} --ignore-not-found
        fi
    fi
done

for rolebinding in $(kubectl get RoleBinding --all-namespaces \
        -l app=ibmcloud-object-storage-driver \
        -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}')
do
    echo "RoleBinding => {$rolebinding}"
    if [[ ! -z "$rolebinding" ]]; then
        nsname=$(echo $rolebinding | awk '{ print $1 }')
        rbname=$(echo $rolebinding | awk '{ print $2 }')
        if [[ ! -z "$rbname" ]]; then
            echo "removing RoleBinding => ${nsname}/${rbname}"
            kubectl delete RoleBinding -n ${nsname} ${rbname} --ignore-not-found
        fi
    fi
done

for deploy in "$(kubectl get Deployments --all-namespaces \
    -l app=ibmcloud-object-storage-plugin \
    -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}')"
do
    echo "Deployment => {$deploy}"
    if [[ ! -z "$deploy" ]]; then
        nsname=$(echo $deploy | awk '{ print $1 }')
        dpname=$(echo $deploy | awk '{ print $2 }')
        if [[ ! -z "$deploy" ]]; then
            echo "removing Deployment => ${nsname}/${dpname}"
            kubectl delete Deployment -n ${nsname} ${dpname} --ignore-not-found
        fi
    fi
done

for daemonset in "$(kubectl get DaemonSets --all-namespaces \
    -l app=ibmcloud-object-storage-driver \
    -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}')"
do
    echo "DaemonSet => {$daemonset}"
    if [[ ! -z "$daemonset" ]]; then
        nsname=$(echo $daemonset | awk '{ print $1 }')
        dsname=$(echo $daemonset | awk '{ print $2 }')
        if [[ ! -z "$dsname" ]]; then
            echo "removing DaemonSet => ${nsname}/${dsname}"
            kubectl delete DaemonSet -n ${nsname} ${dsname} --ignore-not-found
        fi
    fi
done

svcaccount=$(kubectl get ServiceAccount --all-namespaces \
    -l app=ibmcloud-object-storage-driver \
    -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}')
echo "ServiceAccount => {$svcaccount}"
if [[ ! -z "$svcaccount" ]]; then
    nsname=$(echo $svcaccount | awk '{ print $1 }')
    svcaccount=$(echo $svcaccount | awk '{ print $2 }')
    if [[ ! -z "$svcaccount" ]]; then
        echo "removing ServiceAccount => ${nsname}/${svcaccount}"
        kubectl delete ServiceAccount -n ${nsname} ${svcaccount} --ignore-not-found
    fi
fi

svcaccount=$(kubectl get ServiceAccount --all-namespaces \
    -l app=ibmcloud-object-storage-plugin \
    -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}')
echo "ServiceAccount => {$svcaccount}"
if [[ ! -z "$svcaccount" ]]; then
    nsname=$(echo $svcaccount | awk '{ print $1 }')
    svcaccount=$(echo $svcaccount | awk '{ print $2 }')
    if [[ ! -z "$svcaccount" ]]; then
        echo "removing ServiceAccount => ${nsname}/${svcaccount}"
        kubectl delete ServiceAccount -n ${nsname} ${svcaccount} --ignore-not-found
    fi
fi
