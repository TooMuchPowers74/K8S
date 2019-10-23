docker --version
        
echo -e "\nInstalling Kubernetes\n"
# Install Kubernetes
while : ;
do
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    if [ $? -eq 0 ]
    then
        break
    else
        echo -e "\nGet Kuberetes key failed. Check internet connection. Retrying in 20 seconds.\n"
        sleep 20
    fi
done

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

while : ;
do
    echo -e "\nInstalling Kubernetes\n"
    sudo apt-get update -qq && sudo apt-get install -qq -y kubeadm
    if [ $? -eq 0 ]
    then
        break
    else
        echo -e "\nKubernetes installation failed. Check internet connection. Retrying in 20 seconds.\n"
        sleep 20
    fi
done