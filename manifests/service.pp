# == Class snmp::service
#
# Manages snmpd service
#
# === Parameters
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
#
# === Authors
#
# Anton Baranov <abaranov@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2015 Anton Baranov
class snmp::service(
  $service,
  $service_ensure,
  $service_enable,
){
  validate_bool($service_enable)
  validate_re($service_ensure,['^stopped$', '^running$'])
  validate_string($service)

  service {$service:
    ensure => $service_ensure,
    enable => $service_enable,
  }
}

