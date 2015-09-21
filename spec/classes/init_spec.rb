require 'spec_helper'
describe 'snmp' do

  context 'with defaults for all parameters' do
    it { should contain_class('snmp') }
  end
end
