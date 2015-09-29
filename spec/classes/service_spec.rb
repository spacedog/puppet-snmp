require 'spec_helper'
describe 'snmp::service' do
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
    let (:params) {{}}

    it do
      expect {
        should compile
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError,
        /Must pass /)
    end
  end

  context 'with basic init parameters' do
    let(:params) {
      {  
        'service' => 'snmp',
        'service_ensure' => 'running',
        'service_enable' => true,
      }
    }

    context 'with defaults for all parameters' do
      it { should contain_class('snmp::service') }
      it { should contain_service('snmp').with(
        'ensure'     => 'running',
        'enable'     => true,
      ) }
    end
  end
end
