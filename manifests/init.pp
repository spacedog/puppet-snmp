# == Class snmp
#
# Manages snmp server
#
# === Parameters
#
# [*ensure*] 
#   Ensure the state for all resources except package resources
#   (package_ensure parameter is used for package resource). Must be
#   either 'present' or 'absent'
#
#   Type: String
#   Default: present
#
# [*package*]
#   The name of the package that provide snmpd daemon. OS dependant
#   parameter. Check snmp::params class for default value
#
#   Type: String
#   Default: defined in snmp::params
#
# [*package_ensure*]
#   Parameter ensures state of the package. Must be present (also called 
#   installed), absent, purged, held, latest. Values can match /./ in 
#   order to specify version of the package to install
#
#   Type: String
#   Default: present

class snmp (
  $ensure         = $::snmp::params::ensure,
  $package        = $::snmp::params::package,
  $package_ensure = $::snmp::params::package_ensure,
) inherits ::snmp::params {

  validate_re($ensure, ['^present$', '^absent$'])
  validate_re($package_ensure,[
    '^present$',
    '^installed$',
    '^absent$',
    '^purged$',
    '^held$',
    '^latest$',
    '*.*'
  ])
  validate_string(
    $package,
  )
  # Anchors
  anchor{'snmp::begin':}
  anchor{'snmp::end':}

  class{'snmp::install':
    package        => $package,
    package_ensure => $package_ensure,
  }

  Anchor['snmp::begin'] ->
  Class['snmp::install'] ->
  Anchor['snmp::end']
}
