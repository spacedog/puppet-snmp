class snmp::params {
  $ensure = 'present'

  case $::osfamily {
    /^(Debian|Ubuntu)$/: {
      $package = 'snmpd'
    }
    default: {
      $package = 'net-snmp'
    }
  }

  $package_ensure = 'present'
}
