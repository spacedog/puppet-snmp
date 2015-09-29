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
    it { should contain_anchor('snmp::end') }
  end
end
