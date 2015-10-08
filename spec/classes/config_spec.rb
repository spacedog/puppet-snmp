require 'spec_helper'

describe('snmp::config') do
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
        'ensure'         => 'present',
        'daemon_options' => '-LS0-6d',
        'config_file'    => '/etc/snmp/snmpd.conf',
        'snmpd_config' => {
          # Base snmpd config
          'view' => {
            'systemview' => [
              {
                'type' => 'included',
                'oid'  => '.1.3.6.1.2.1.1',
              },
              {
                'type' => 'included',
                'oid'  => '.1.3.6.1.2.1.25.1.1',
              }
            ]
          },
          # Redhat snmpd config
          'access'                     => {
            'notConfigGroup' => {
              'context'      => '""',
              'version'      => 'any',
              'level'        => 'noauth',
              'prefix'       => 'exact',
              'read'         => 'systemview',
              'write'        => 'none',
              'notify'       => 'none',
            }
          },
          'com2sec'                    => {
            'notConfigUser' => {
              'source'      => 'default',
              'community'   => 'public',
            }
          },
          'dontLogTCPWrappersConnects' => 'yes',
          'group'                      => {
            'notConfigGroup' => [
              {
                'version' => 'v1',
                'secname' => 'notConfigUser',
              },
              {
                'version' => 'v2c',
                'secname' => 'notConfigUser',
              }
            ]
          },
          # lint:ignore:80chars
          'syscontact'  => 'Root <root@localhost> (configure /etc/snmp/snmp.local.conf)',
          # lint:endignore
          'syslocation' => 'Unknown (edit /etc/snmp/snmpd.conf)',
        },
      }
    }
    it { should contain_class('snmp::config') }
    it { should contain_file('/etc/snmp/snmpd.conf').with(
      {
        'ensure'  => 'present',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0600',
        'content' => '######################################################################
# This file is managed by puppet
######################################################################
access notConfigGroup "" any noauth exact systemview none none
com2sec notConfigUser default public
dontLogTCPWrappersConnects yes
group notConfigGroup v1 notConfigUser
group notConfigGroup v2c notConfigUser
syscontact Root <root@localhost> (configure /etc/snmp/snmp.local.conf)
syslocation Unknown (edit /etc/snmp/snmpd.conf)
view systemview included .1.3.6.1.2.1.1
view systemview included .1.3.6.1.2.1.25.1.1
',
      })
    }
    it "should contain daemon_options file_line" do
      should contain_file_line('daemon_options').with( {
        'ensure' => 'present',
        'path'   => '/etc/sysconfig/snmpd',
        'line'   => 'OPTIONS="-LS0-6d"',
        'match'  => '^OPTIONS='
      })
    end

  end
end
