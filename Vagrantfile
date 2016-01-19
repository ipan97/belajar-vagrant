Vagrant.configure(2) do |c|
  c.vm.box = "ubuntu/trusty64"
  c.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end
  c.vm.provision "shell", path: "provisioning/setup.sh" 
  c.vm.network "forwarded_port", guest: 80, host: 8080
  c.vm.synced_folder "aplikasi", "/home/vagrant/aplikasi", create: true, owner: "www-data", group: "www-data"
end
