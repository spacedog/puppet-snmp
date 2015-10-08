require 'spec_helper'

describe 'snmp::user' do
  let(:title) { 'test_user' }
  let(:facts) {
    {
      :fqdn            => 'test.example.com',
      :hostname        => 'test',
      :ipaddress       => '192.168.0.1',
      :operatingsystem => 'CentOS',
      :osfamily        => 'RedHat'
    }
  }

  it { should compile }
  it { should contain_class('snmp::params') }

  let (:default_params) {{}}
  context 'with defaults for all parameters' do
    let (:params) {default_params}


    it "should contain snmppass file" do
      should contain_file('/root/.test_user_snmppass').with(
        :ensure  => 'present',
        :mode    => '0600',
        :replace => false,
      )
    end
    
    it "should stop snmpd service if snmppass file changes" do
      should contain_exec('test_user_stop_snmpd').with(
        :command     => '/sbin/pidof snmpd && /sbin/service snmpd stop || true',
        :refreshonly => true,
        :subscribe   => 'File[/root/.test_user_snmppass]',
      )
    end

    it "should set password for user if snmppass file changes" do 
      should contain_exec("test_user_reset_password").with(
        :refreshonly => true,
        :subscribe   => 'Exec[test_user_stop_snmpd]'
      )
      should contain_exec("test_user_reset_password").with_command(
        /^\/bin\/echo createUser test_user SHA \w+ AES \w+ >> \/var\/lib\/net\-snmp\/snmpd\.conf$/
      )
    end

  end
  context "with minimal pramas init set" do
    let(:default_params) {
      {
        :authpass => 'someauthpass'
      }
    }

    it "should contain snmppass file" do
      should contain_file('/root/.test_user_snmppass').with(
        :ensure  => 'present',
        :mode    => '0600',
        :replace => false,
      )
    end
    
    it "should stop snmpd service if snmppass file changes" do
      should contain_exec('test_user_stop_snmpd').with(
        :command     => '/sbin/pidof snmpd && /sbin/service snmpd stop || true',
        :refreshonly => true,
        :subscribe   => 'File[/root/.test_user_snmppass]',
      )
    end

    it "should set password for user if snmppass file changes" do 
      should contain_exec("test_user_reset_password").with(
        :refreshonly => true,
        :subscribe   => 'Exec[test_user_stop_snmpd]'
      )
    end

    context "with privpass not set" do
      let(:params) do
        default_params.merge(
          { :privpass => '' }
        )
      end
      it do
        should contain_exec("test_user_reset_password").with_command(
        /^\/bin\/echo createUser test_user SHA someauthpass AES someauthpass >> \/var\/lib\/net\-snmp\/snmpd\.conf$/
      )
      end
    end
    context "with privpass is set" do
      let(:params) do
        default_params.merge(
          { :privpass => 'someprivpass' }
        )
      end
      it do
        should contain_exec("test_user_reset_password").with_command(
        /^\/bin\/echo createUser test_user SHA someauthpass AES someprivpass >> \/var\/lib\/net\-snmp\/snmpd\.conf$/
      )
      end
    end
  end
end
