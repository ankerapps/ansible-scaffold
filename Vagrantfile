node_definitions = [
  {
    :ip => "192.168.99.10",
    :ssh_port => 2210,
    :hostname => "example.vagrant"
  },
  {
    :ip => "192.168.99.11",
    :ssh_port => 2211,
    :hostname => "example2.vagrant"
  }
]

Vagrant.configure("2") do |config|
  node_definitions.each do |node_definition|

    config.vm.define node_definition[:hostname] do |node|
      node.vm.box = "generic/ubuntu1804"

      node.vm.network "private_network", ip: node_definition[:ip]
      node.vm.network :forwarded_port, guest: 22, host: node_definition[:ssh_port], id: 'ssh'

      node.vm.synced_folder ".", "/vagrant", disabled: true
      node.vm.provider "virtualbox" do |vb|
        vb.memory = "2024"
        vb.gui = false
      end

      ssh_pub_key = File.readlines(".ssh/ansible.pub").first.strip
      node.vm.provision 'shell', inline: 'mkdir -p /root/.ssh'
      node.vm.provision 'shell', inline: "echo #{ssh_pub_key} >> /root/.ssh/authorized_keys"
      
      node.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y python
      
      SHELL

    end
  end
end
