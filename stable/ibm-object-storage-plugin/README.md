# IBM Cloud Object Storage Plug-in
This Helm chart installs the IBM Cloud Object Storage plug-in in a Red Hat OpenShift Container Platform (RHOCP). Cluster admin has to create a new namespace for plugin deployment. The namespace should be accessible only by cluster admin.


## Introduction
[IBM Cloud Object Storage](https://cloud.ibm.com/docs/services/cloud-object-storage?topic=cloud-object-storage-about-ibm-cloud-object-storage#about-ibm-cloud-object-storage) is persistent, highly available storage that you can mount to apps that run in a Kubernetes cluster by using the IBM Cloud Object Storage plug-in. The plug-in is a Kubernetes Flex-Volume plug-in that connects Cloud Object Storage buckets to pods in your cluster. Information that is stored with IBM Cloud Object Storage is encrypted in transit and at rest, dispersed across multiple geographic locations, and accessed over HTTP by using a REST API.

------------------------------------------------------------------------------------------------------------------------------
## Details
When you install the IBM Cloud Object Storage plug-in Helm chart, the following Kubernetes resources are deployed into your RHOCP cluster:
- **IBM Cloud Object Storage driver daemonset**: The daemonset deploys one `ibmcloud-object-storage-driver` pod on every worker node in your cluster. The daemonset contains the Kubernetes flex driver plug-in to communicate with the `kubelet` component in your cluster.
- **IBM Cloud Object Storage plug-in pod**: The pod contains the storage provisioner controllers to work with the Kubernetes controllers.
- **IBM-provided storage classes**: You can use the storage classes to create Cloud Object Storage buckets with a specific configuration.
- **Kubernetes service accounts, RBAC cluster roles and cluster role bindings, SCC**: The service accounts and RBAC roles authorize the plug-in to interact with your Kubernetes resources. SCC allows driver daemonset pods to run as root user and allowing the pods to mount the host path. 

## Prerequisites

- **Red Hat OpenShift Container Platform (RHOCP)**:
  - Create or use an existing standard RHOCP cluster. The RHOCP version should be 4.3 and above.
  - Follow the [instructions](https://cloud.ibm.com/docs/containers?topic=containers-helm#install_v3) to install the Helm client v3 on your local machine. If helm v2 is installed on your local machine or on your cluster, then it is strongly recommended to [migrate from helm v2 to v3](https://cloud.ibm.com/docs/containers?topic=containers-helm#migrate_v3).
  - Install [OpenShift CLI](https://docs.openshift.com/container-platform/4.3/cli_reference/openshift_cli/getting-started-cli.html) (oc).

### Red Hat OpenShift SecurityContextConstraints Requirements

This chart automatically creates a SCC which defines a SecurityContextConstraint that can be used to finely control the permissions/capabilities needed by the driver pods.

Custom SecurityContextConstraints definition:
```

This chart uses below custom SecurityContext Constraints.

	apiVersion: security.openshift.io/v1
	kind: SecurityContextConstraints
	metadata:
  	  name: s3fs-cos-driver-scc
	priority: 0
	defaultAddCapabilities: []
	allowedCapabilities: []
	allowHostDirVolumePlugin: true
	allowHostIPC: false
	allowHostPID: false
	allowHostPorts: false
	allowHostNetwork: true
	allowPrivilegedContainer: false
	allowPrivilegeEscalation: true
	requiredDropCapabilities:
 	 - KILL
 	 - MKNOD
 	 - SETUID
 	 - SETGID
	readOnlyRootFilesystem: false
	runAsUser:
  	  type: RunAsAny
	seLinuxContext:
  	  type: RunAsAny
	fsGroup:
  	  type: RunAsAny
	supplementalGroups:
  	  type: RunAsAny
	users:
	- system:serviceaccount:{{template "ibm-object-storage-plugin.namespace" .}}:ibmcloud-object-storage-driver
	groups: []
	volumes:
  	  - configMap
   	  - downwardAPI
 	  - emptyDir
  	  - hostPath
  	  - persistentVolumeClaim
  	  - projected
  	  - secret
```
### Permissions
To install the Helm chart in your cluster, you must have the **Administrator** platform role.

## Resources Required
The IBM Cloud Object Storage plug-in requires the following resources on each worker node to run successfully:
- CPU: 0.2 vCPU
- Memory: 128MB

## Installing the Chart
Install the IBM Cloud Object Storage plug-in with a Helm chart to set up pre-defined storage classes for IBM Cloud Object Storage. You can use these storage classes to create a PVC to provision IBM Cloud Object Storage for your apps.

### Before you begin

1. Complete the prerequisites for your cluster as outlined in the `Prerequisites` section of this `README`.

2. Retrieve your Cloud Object Storage API endpoint, and the credentials to access your Cloud Object Store.
3. Store the credentials to access your Cloud Object Store in a Kubernetes secret.
   1. Encode the Cloud Object Storage credentials to base64 and note all the base64 encoded values.
      ```
      echo -n "<key_value>" | base64
      ```

   2. Create a configuration file for your Kubernetes secret. The credentials might vary depending on the type of Cloud Object Storage instance you use. You can create the secret, say `secret.yaml` in any namespace that you want.
      Example for Hash-based Message Authentication Code (HMAC) authentication:
      ```
      apiVersion: v1
      kind: Secret
      type: ibm/ibmc-s3fs
      metadata:
        name: <secret_name>
        namespace: <namespace>
      data:
        access-key: <base64_access_key_id>
        secret-key: <base64_secret_access_key>
      ```

      Example for Identity and Access Management (IAM) key authentication:
      ```
      apiVersion: v1
      kind: Secret
      type: ibm/ibmc-s3fs
      metadata:
        name: <secret_name>
        namespace: <namespace>
      data:
        api-key: <base64_apikey>
        service-instance-id: <base64_resource_instance_id>
      ```

   3. Create the Kubernetes secret in your cluster.
      ```
      oc apply -f secret.yaml
      ```

### Installing the Chart

1. Verify that `helm v3` is installed on your local machine.

   ```
   helm version --short
   v3.0.2+g19e47ee
   ``` 

2. Add the Red Hat Helm repository `redhat-helm-charts` to your cluster.

   ```
   helm repo add redhat-charts https://redhat-developer.github.com/redhat-helm-charts 
   ```

3. Update the Helm repo to retrieve the latest version of all Helm charts in this repo.

   ```
   helm repo update
   ```

4. Download the Helm chart and unpack the chart in your current directory. Then, navigate to the `ibm-object-storage-plugin` directory.  

   ```
   helm fetch --untar redhat-charts/ibm-object-storage-plugin && cd ibm-object-storage-plugin
   ```

5.  Install the IBM Cloud Object Storage plug-in. When you install the plug-in, pre-defined storage classes are added to your cluster.

    Example: Install chart from helm registry.

    ```
     helm install ibm-object-storage-plugin redhat-charts/ibm-object-storage-plugin --set license=true
    ```

### Verifying the Chart

1. Verify that the IBM Cloud Object Storage plug-in is installed correctly.
   ```
   oc get pods -n <namespace> -o wide | grep object
   ```
   Example output:
   ```
   ibmcloud-object-storage-driver-9n8g8                              1/1       Running   0          2m
   ibmcloud-object-storage-plugin-7c774d484b-pcnnx                   1/1       Running   0          2m
   ```
   The installation is successful when you see one `ibmcloud-object-storage-plugin` pod and one or more `ibmcloud-object-storage-driver` pods. The number of `ibmcloud-object-storage-driver` pods equals the number of worker nodes in your cluster. All pods must be in a `Running` state for the plug-in to function properly. If the pods fail, run `kubectl describe pod -n <namespace> <pod_name>` to find the root cause for the failure.

2. Verify that the storage classes are created successfully. Note that this output varies depending on the type of cluster you use.
   ```
   oc get storageclass | grep 'ibmc-s3fs'
   ```
   Example output:
   ```
   ibmc-s3fs-rhocp        ibm.io/ibmc-s3fs        Delete          Immediate              false                  4d8h
   ibmc-s3fs-rhocp-perf   ibm.io/ibmc-s3fs        Delete          Immediate              false                  4d8h
   ```

## Removing the Chart
If you do not want to provision and use IBM Cloud Object Storage in your cluster, you can uninstall the Helm chart.

**Note:** Removing the plug-in does not remove existing PVCs, PVs, or data. When you remove the plug-in, all the related pods and daemon sets are removed from your cluster.

1. Find the installation name of your Helm chart.

     ```
     helm ls --all --all-namespaces | grep ibm-object-storage-plugin
     ```

2. Delete the IBM Cloud Object Storage plug-in by removing the Helm chart. Here, `<helm_chart_namespace>` is the namespace where your chart is deployed.

     ```
     helm delete <helm_chart_name> -n <helm_chart_namespace>
     ```

**Verify that the IBM Cloud Object Storage pods are removed.**

   ```
   oc get pods -n <namespace> | grep object-storage
   ```
   The removal of the pods is successful if no pods are displayed in your CLI output.

**Verify that the storage classes are removed.**

   ```
   oc get storageclasses | grep 'ibmc-s3fs'
   ```
   The removal of the storage classes is successful if no storage classes are displayed in your CLI output.

## Configuration
Review the parameters that you can configure for the IBM Cloud Object Storage plug-in installation.

|Parameter|How used|Example|Default value|
|---------|---------------|-------------------|----------|
|`iamEndpoint`|(Optional)If you are using IBM cloud object storage servide, then set the endpoint to IBM Cloud Identity and Access Management API endpoint . |`https://iam.bluemix.net`|`https://iam.bluemix.net`|
|`cos.endpoint`|The S3 API endpoint for your Cloud Object Storage instance that you want to use. The API endpoint varies depending on the type of Cloud Object Storage that you use. | Minio: `http://minio-service.default:9000`|`https://<Endpoint URL>`|
|`cos.storageClass`|The name of the storage class which refers to `Location + Storage Class` / `LocationConstraint` |`standard`| `<StorageClass>`|
|`platform` | The platform on which the plugin is getting deployed (k8s/Openshift) | `Openshift` | `Openshift` |
| `provider`| The cluster provider on which the plugin is getting installed | `rhocp` | `rhocp` |
## Tips:
- By default, object-storage plugin storageclasses are created with `ECDHE-RSA-AES128-GCM-SHA256` as `tls-cipher-suite` for RHCOS. Cipher suite can be overridden from the PVC using `ibm.io/tls-cipher-suite: "<TLS_CIPHER_SUITE>"` under `annotations` section.

## Limitations
- `runAsUser` and `fsGroup` IDs should be same to provide non-root user access to COS volume mount.
- **Platform support:** This Helm chart is validated to run in:
  - RHOCP

## Documentation
Review the following links for further information about IBM Cloud Object Storage.

- [General information about IBM Cloud Object Storage](https://cloud.ibm.com/docs/services/cloud-object-storage?topic=cloud-object-storage-about-ibm-cloud-object-storage#about-ibm-cloud-object-storage).
- [Create your first persistent volume claim (PVC)](https://cloud.ibm.com/docs/containers?topic=containers-object_storage#add_cos) for your app that points to a bucket in Cloud Object Storage.
- [Use Cloud Object Storage in a Kubernetes stateful set](https://cloud.ibm.com/docs/containers?topic=containers-object_storage#cos_statefulset).
