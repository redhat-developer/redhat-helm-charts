## Introduction

This document describes how to deploy Enterprise MongoDB v4.4 on RedHat's OpenShift Container Platform on  IBM Power Systems
The docker image leveraged are custom built for IBM Power Architecture i.e. ppc64le

## Chart details

The Helm chart creates the following resources:
- Service with the name, `<release_name>-ibm-mongodb-enterprise-helm-service`
- Deployment with the name, `<release_name>-ibm-mongodb-enterprise-helm-deployment`
- NetworkPolicy with the name, `<release_name>-ibm-mongodb-enterprise-helm-network-policy`
- Route with the name, `<release_name>-ibm-mongodb-enterprise-helm-route`

**Note** : Here, `<release name>` refers to the name of the helm release.

## Prerequisites

- Ensure to install Kubernetes version 1.16.0-0 or later

- Ensure to install Helm version 3.0.0 or later

- The default images are available through ibmcom/ibm-enterprise-mongodb-ppc64le

- Create a persistent volume with the access mode as 'Read write many' and a minimum of 10 GB space.

## Configuration

#### Instructions to create PV and allocation ####

Navigate to `pre-req` folder

- Edit pv.yaml to include name of the persistent volume
- Update storageClassName
- Update the storage ( default GB ) to be allocated to the persistent volume
- Update NFS server details
- Add the path from the nfs server to be mounted

Once the values are updated, create the pv
```
$oc create -f pv.yaml
```
Note : StorageClassName in values.yaml should be same as the one provided while creating
persistent volume (pv.yaml)

## Instructions to deploy this helm chart
Git clone this repository on your server -

```
cd $HOME/
git clone https://github.com/redhat-developer/redhat-helm-charts
cd redhat-helm-charts/stable/ibm-mongodb-enterprise-helm/
```

Create a New Project

```
export NAMESPACE=ibm
oc new-project $NAMESPACE
```

Update the following variables in values.yaml file -

`database.adminuser` , `database.adminpassword` ,`database.name_database`

this information would be leveraged and corresponding custom user/password with superadmin privileges would be created on MongoDB instance.

Add an hostname/IP for the incoming http traffic by updating `values.ingress.host` variable

Update the `values.global.persistance.claims.storageClassName` variable, which specfies the StorageClassName, Same as the one used by persistent volume                             

Also update `global.persistence.claims.name` in values.yaml file -

Update SCC in your Namespace, this would be required to allow mongodb container to be executed -

```
oc adm policy add-scc-to-group anyuid system:authenticated
oc adm policy add-scc-to-user anyuid system:serviceaccount:$NAMESPACE:mongodb
```


Installing helm chart

`helm install <HELM_NAME> -f ./values.yaml ../ibm-mongodb-enterprise-helm/`

e.g :-

`helm install test -f ./values.yaml ../ibm-mongodb-enterprise-helm/` 

To validate if chart got installed successfully -

```
[root@p634-bastion ~]# helm ls
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/.kube/config
NAME	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART                            	APP VERSION
test	harsha   	1       	2021-01-19 11:49:53.626581975 -0500 EST	deployed	ibm-mongodb-enterprise-helm-0.1.0	1.16.0     
[root@p634-bastion ~]# oc get po
NAME                                                           READY   STATUS    RESTARTS   AGE
test-ibm-mongodb-enterprise-helm-deployment-7d77767cf8-mspj4   1/1     Running   0          3m37s
[root@p634-bastion ~]# 

```

### Expose your deployment, outside OCP
To expose your application outside OCP Cluster, expose the deployment -

```
[root@p1213-bastion templates]# oc expose deployment test-ibm-mongodb-enterprise-helm-deployment --type=NodePort --name=test-ibm
service/test-ibm exposed
[root@p1213-bastion templates]# oc get nodes
NAME                                STATUS   ROLES           AGE   VERSION
p1213-master.p1213.cecc.ihost.com   Ready    master,worker   13d   v1.19.0+a5a0987
[root@p1213-bastion templates]# oc get svc
NAME                                       TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                                                     AGE
test-ibm                                   NodePort       172.30.22.77     <none>        27017:31466/TCP                                                                                             14s
test-ibm-mongodb-enterprise-helm-service   ClusterIP      172.30.78.82     <none>        27017/TCP                                                                                                   85m
```

##### Common variables that could be modified on the helm chart

| Parameter                                                                         | Description                                                                 
| --------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `values.replicaCount`                                                             | Specified number of identical pods to be available                          |
| `values.image.repository`                                                         | Image repository address from which the helm chart will pull the image      |
| `values.image.pullPolicy`                                                         | Container image details of appserver                                        |
| `values.image.tag`                 												| Image tag,version of the image to be pulled form the repository             |
| `values.database.adminuser`														| Admin user to be created for MongoDB database 							  |
| `values.database.adminpassword`													| Password to for the Admin user                                              |
| `values.database.name_database`												    | Default database to be created on startup of MongoDB                        |
| `values.service.port`														    	| Port on which MongoDB instance will be started                              |
| `values.autoscaling.minReplicas`                                                   | Minimum replicas that needs to be present as the part of deployment         |
| `values.autoscaling.maxReplicas`                                                   | Maximum replicas/ pods the deployment can scale     						  |
| `values.autoscaling.targetCPUUtilizationPercentage`                                | Maximum CPU that the pod could utilize on the host                          |
| `values.global.persistance.claims.name`											| Name of persistant volume claim                                             |
| `values.global.persistance.accessMode`                                            | Accessmode of the persistant volume                                         |
|																					  | ReadWriteOnce — the volume can be mounted as read-write by a single node    |
|																					  | ReadOnlyMany — the volume can be mounted read-only by many nodes            |
|																					  | ReadWriteMany — the volume can be mounted as read-write by many nodes       |
| `values.global.persistance.capacity`                                              | Capacity to be allocated to persistant values claim based on  capacityUnit  |
| `values.global.persistance.capacityUnit`											| Capacity Unit in Gigabytes or Megabytes                                     |
| `values.global.persistance.claims.storageClassName`										| StorageClassName which is used for the persistant volume                    |
| `values.ingress.host`                                       | Ingress hostname/ip to process the incoming http traffic |
| `values.global.persistance.mountPath`												| Mount Path to be used on the host                                           |
