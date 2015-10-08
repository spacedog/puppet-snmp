# == Class snmp::config
#
# Configures snmpd
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
# [*config_file*]
#   Path to snmpd configuration file
#
#   Type: String
#   Default: /etc/snmp/snmpd.conf
#
class snmp::config (
  $ensure,
  $config_file,
  $snmpd_config,
  $daemon_options,
) {
  include snmp::params

  validate_re($ensure, ['^present$', '^absent$'])
  validate_hash(
    $snmpd_config,
  )
  validate_string($daemon_options)

  file {$config_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/snmpd.conf.erb"),
  }

  file {$::snmp::params::daemon_options_file:
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  $_line = "${::snmp::params::daemon_options_prefix}=\"${daemon_options}\""
  file_line {'daemon_options':
    ensure => $ensure,
    path   => $::snmp::params::daemon_options_file,
    line   => $_line,
    match  => "^${::snmp::params::daemon_options_prefix}=",
  }
}
