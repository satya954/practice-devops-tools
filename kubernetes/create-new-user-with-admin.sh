#Create dev-stats-user with a certificate and authorize it
localpath=$(`echo pwd`)
USERNAME="satya-read-user"
USER_CSR_PATH="$localpath/$USERNAME.csr"
USER_CERT_PATH="$localpath/$USERNAME.crt"
USER_KEY_PATH="$localpath/$USERNAME.key"

openssl genrsa -out "$USER_KEY_PATH" 2048
openssl req -new -key "$USER_KEY_PATH" -out "$USER_CSR_PATH" -subj "/CN=$USERNAME/O=monitoring"
openssl x509 -req -in "$USER_CSR_PATH" -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out "$USER_CERT_PATH" -days 365

#Check with below command
#kubectl api-resources
#Create cluster role and cluster rolebinding
echo "Creating ClusterRole & Cluster Role Binding"
kubectl create clusterrole "CR-$USERNAME" --resource='pods,nodes,svc,pods.metrics.k8s.io,nodes.metrics.k8s.io' --verb='get,list,top'
kubectl create clusterrolebinding "CR-BINDING-$USERNAME" --clusterrole "CR-$USERNAME" --user "$USERNAME"

#Check the created user can do some activity
echo "kubectl auth can-i list pods --as $USERNAME"
kubectl auth can-i list pods --as "$USERNAME"
