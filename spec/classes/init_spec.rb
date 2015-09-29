require 'spec_helper'
describe 'snmp' do
  let(:facts) {
    {
      :fqdn            => 'test.example.com',
      :hostname        => 'test',
      :ipaddress       => '192.168.0.1',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat'
    }
  }

  context 'with defaults for all parameters' do
    it { should contain_class('snmp') }
    it { should contain_anchor('snmp::begin') }
    it { should contain_class('snmp::install').that_requires('Anchor[snmp::begin]') }
    it { should contain_class('snmp::config').that_requires('Class[snmp::install]') }
    it { should contain_class('snmp::service').that_subscribes_to('Class[snmp::config]') }
    it { should contain_anchor('snmp::end').that_requires('Class[snmp::service]') }
  end
end
