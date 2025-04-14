# -*- mode: ruby -*-
# frozen_string_literal: true

ENV['LC_ALL'] = 'en_US.UTF-8'

Vagrant.require_version '>= 1.3.5'
# rubocop:disable Metrics/BlockLength
Vagrant.configure('2') do |config|
  config.vm.box = 'packer/debian12kde'
  config.vm.allow_fstab_modification = true
  config.vm.synced_folder '.',
                          '/vagrant',
                          type: 'smb',
                          smb_password: 'xxxx',
                          smb_username: 'xxxx'
  config.vm.allow_hosts_modification = false
  config.vm.network 'public_network',
                    bridge: 'Default Switch'
  config.ssh.insert_key = false
  config.vm.disk  :disk,
                  primary: true,
                  name: 'System',
                  size: '20GB'

  config.vm.provider :hyperv do |hv|
    hv.cpus = 4
    hv.memory = 8192
    hv.maxmemory = 8192
    hv.enable_virtualization_extensions = true
    hv.enable_enhanced_session_mode = true
    hv.vm_integration_services = {
      guest_service_interface: true,
      heartbeat: true,
      key_value_pair_exchange: true,
      shutdown: true,
      time_synchronization: true,
      vss: true
    }
  end

  config.vm.define :devopswk do |wk_cfg|
    wk_cfg.vm.hostname = 'devopswk'
    wk_cfg.trigger.before :"VagrantPlugins::HyperV::Action::StartInstance", type: :action do |trigger|
      trigger.name = 'Mount ISO'
      trigger.ruby do |_env, machine|
        system("pwsh -c \"& {import-module hyper-v; get-vm -Id #{machine.id} | \
        Add-VMDvdDrive -Path vagrant\\cloud-init.iso}\"")
      end
    end
    wk_cfg.vm.provision :ansible_local,
                        playbook: './ansible/playbook_devopswk_provision.yml',
                        config_file: './ansible/ansible.cfg',
                        compatibility_mode: '2.0',
                        raw_arguments: ['-vvv'],
                        become: true
  end
end
# rubocop:enable Metrics/BlockLength
