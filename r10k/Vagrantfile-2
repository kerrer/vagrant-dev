Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  config.vm.synced_folder "puppet", "/etc/puppet"

  config.vm.synced_folder "openvpn", "/root/openvpn"

  config.vm.provision "shell",
    inline: "
        export FACTER_vagrant=1;
        FQDN=`hostname --fqdn`;
        mkdir -p /etc/openvpn/keys;
        cp /root/openvpn/key-store/ca.crt /etc/openvpn/keys/;
        cp /root/openvpn/key-store/$FQDN.crt /etc/openvpn/keys/;
        cp /root/openvpn/key-store/$FQDN.key /etc/openvpn/keys/;
        cp /root/openvpn/key-store/dh2048.pem /etc/openvpn/keys/;
        puppet apply /etc/puppet/environments/production/manifests/site.pp --confdir=/etc/puppet/ --environment=production --environmentpath=/etc/puppet/environments/
    "

  config.vm.define "vpn" do |vpn|
    vpn.vm.hostname = "vpn.techpunch.com"
    vpn.vm.network :private_network, ip: "192.168.5.10"
    vpn.vm.network "forwarded_port", guest: 1194, host: 1194
    vpn.vm.provision :hosts
  end

  config.vm.define "dummy" do |dummy|
    dummy.vm.hostname = "dummy.techpunch.com"
    dummy.vm.network :private_network, ip: "192.168.5.20"
    dummy.vm.provision :hosts
  end
end
