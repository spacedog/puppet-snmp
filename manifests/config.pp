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
) {
  validate_re($ensure, ['^present$', '^absent$'])
  validate_absolute_path($config_file)
  # TODO: add more checks for parameters inside snmpd_config hash
  validate_hash(
    $snmpd_config,
  )

  file {$config_file:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/snmpd.conf.erb"),
  }

}
