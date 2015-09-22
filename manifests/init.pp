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
#
# [*config_file*]
#   Path to snmpd configuration file
#
#   Type: String
#   Default: /etc/snmp/snmpd.conf
#
# [*default_snmpd_config*]
#   Hash of OS specific snmpd configuration parameters. This is what you
#   have after installing snmpd package.
#
#   Type: hash
#   Default: check snmp::params::default_snmpd_config
#
# [snmpd_config*]
#   Hash of snmpd configuration parameters. This hash is merged with
#   snmp::params::default_snmpd_config and replace all duplicated values
#   in default config
#
#   Type: hash
#   Default: {}
#
# [*service*]
#   Name of the snmpd service to manage. Check snmp::params
#   for the default value
#
#   Type: String
#   Default: check snmp::params
#
# [*service_ensure*]
#   Whether a service should be running. Valid values are:
#   stopped, running
#
#   Type: String
#   Default: check snmp::params
#
# [*service_enable*]
#   Whether a service should be enabled to start at boot.
#
#   Type: boolean
class snmp (
  $ensure               = $::snmp::params::ensure,
  $package              = $::snmp::params::package,
  $package_ensure       = $::snmp::params::package_ensure,
  $config_file          = $::snmp::params::config_file,
  $default_snmpd_config = $::snmp::params::default_snmpd_config,
  $snmpd_config         = {},
  $service              = $::snmp::params::service,
  $service_ensure       = $::snmp::params::service_ensure,
  $service_enable       = $::snmp::params::service_enable,
) inherits ::snmp::params {

  validate_bool($service_enable)
  validate_hash($snmpd_config)
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
  validate_re($service_ensure,['^stopped$', '^running$'])
  validate_string(
    $package,
    $service,
  )

  # Merg default_snmpd_config and snmpd_confg
  $_snmpd_config = merge($default_snmpd_config, $snmpd_config)

  # Anchors
  anchor{'snmp::begin':}
  anchor{'snmp::end':}

  class{'snmp::install':
    package        => $package,
    package_ensure => $package_ensure,
  }

  class{'snmp::config':
    ensure       => $ensure,
    config_file  => $::snmp::params::config_file,
    snmpd_config => $_snmpd_config,
  }
  class{'snmp::service':
    service        => $service,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }

  Anchor['snmp::begin'] ->
  Class['snmp::install'] ->
  Class['snmp::config'] ~>
  Class['snmp::service'] ->
  Anchor['snmp::end']
}
