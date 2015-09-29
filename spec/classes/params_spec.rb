require 'spec_helper'

describe('snmp::params') do
  context 'with defaults for all parameters' do
    it { should contain_class('snmp::params') }
  end
end
