#!/bin/bash

{{/*
Copyright 2017 The Openstack-Helm Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/}}

set -ex

ceph_activate_namespace() {
  kube_namespace=$1
  CEPH_KEY=$(kubectl get secret ${PVC_CEPH_STORAGECLASS_ADMIN_SECRET_NAME} \
      --namespace=${PVC_CEPH_STORAGECLASS_DEPLOYED_NAMESPACE} \
      -o json | jq -r '.data | .[]')
  {
  cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: "${PVC_CEPH_STORAGECLASS_USER_SECRET_NAME}"
type: kubernetes.io/rbd
data:
  key: $(echo ${CEPH_KEY})
EOF
  } | kubectl create --namespace ${kube_namespace} --validate=false -f -
}

ceph_activate_namespace ${DEPLOYMENT_NAMESPACE}
