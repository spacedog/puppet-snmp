require 'spec_helper'

describe('snmp::install') do
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

  context 'with basic init defaults' do
    let(:params) {
      {
        'package'        => 'snmp',
        'package_ensure' => 'present'
      }
    }
    it { should contain_class('snmp::install') }
    it { should contain_package('snmp').with({
      'ensure' => 'present',
    })
    }
  end
end
