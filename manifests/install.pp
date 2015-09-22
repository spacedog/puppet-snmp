# == Class snmp::install
#
# Installs snmpd package
#
# === Parameters
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
#
# === Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2015 Anton Baranov
#
class snmp::install (
  $package,
  $package_ensure,
) {
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

  package {$package:
    ensure => $package_ensure,
  }

}
