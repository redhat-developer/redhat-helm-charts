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

# - determine directory path of script which contains storage class definition file
[[ `dirname $0 | cut -c1` = '/' ]] && postinstallDir=`dirname $0`/ || postinstallDir=`pwd`/`dirname $0`/

# Perform cleanup script before we begin in case the previous build died without running it
$postinstallDir/../clean-up.sh

# Create storageclass to be used for application testing
kubectl apply -f $postinstallDir/storageClass.yaml
