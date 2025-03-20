#COPY the USER CRT & KEY FILES

localpath=$(`echo pwd`)
USERNAME="satya-read-user"
USER_CSR_PATH="$localpath/$USERNAME.csr"
USER_CERT_PATH="$localpath/$USERNAME.crt"
USER_KEY_PATH="$localpath/$USERNAME.key"

CLUSTER_NAME="cluster.local"
CLUSTER_URL="https://elb-testssdkube.medplusindia.com:6443"

kubectl config set-cluster "$CLUSTER_NAME" --server="$CLUSTER_URL" --certificate-authority=/etc/kubernetes/pki/ca.crt
kubectl config set-credentials "$USERNAME" --client-certificate "$USER_CERT_PATH" --client-key "$USER_KEY_PATH"
kubectl config set-context --cluster "$CLUSTER_NAME" --user "$USERNAME" "$USERNAME-context@$CLUSTER_NAME"
kubectl config use-context "$USERNAME-context@$CLUSTER_NAME"
