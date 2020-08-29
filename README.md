# maven-project

Simple Maven Project

When make ssh connection from Ansible to Kubernetes Use user as a Root.

In K8s, 
  - create password for root.
  - Update /etc/ssh/sshd_config/ 
        PermitRootlogin to yes 
        PasswordAuthentication to yes  
  - Reload sshd service.
  
In Ansible
  - Copy ec2-user .ssh/id_rsa.pub key and directly paste (update) in k8s-managemenn-server root user .ssh/authorized_keys.
  - In hosts file
        [Kubernetes]
         ip   ansible_host=root
  - Try for ping
        ansible -i hosts -m ping
     (If successful ping for kubernets then create playbook kubernetes-valaxy-deployment.yml and kubernetes-valaxy-service.yml file and in that create user as a root)
     
  
After that In K8s,As a root user
  - apply kubectl commands
           curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes release/release/stable.txt)/bin/linux/amd64/kubectl
           chmod +x ./kubectl
           sudo mv ./kubectl /usr/local/bin/kubectl
  - install docker
  - create secret for pulling image from  docker private registry
         kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=<un> --docker-password=<pwd>  --docker-email=<email>
  - add in valaxy-deployment.yml deployment file after container section
     imagePullSecrets:
      - name: regcred
