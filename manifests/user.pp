# == define snmp::user
#
# Manages SNMPv3 users
#
# === Parameters
#
# [*username*]
#   Defines the name of the user
#
#   Type: string
#   Default: $title
#
# [*authtype]
#   Authentication types to use. Must be MD5 or SHA
#
#   Type: string
#   Default: SHA
#
# [*authpass*]
#   Authentication passphrase for user
#
#   Type: string
#   Default: undef
#
# [*privtype*]
#   Privacy protocols type to use. Should be AES or DES
#
#   Type: string
#   Default: AES
#
# [*privpass*]
#   If the privacy passphrase is not specified, it is assumed to be the same as
#   the authentication passphrase
#
#   Type: string
#   Default: undef
#
# === Author
#
# Anton Baranov <abaranov@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2015 Anton Baranov
#
define snmp::user (
  $authpass       = undef,
  $privpass       = undef,
  $authtype       = 'SHA',
  $privtype       = 'AES',
){
  include snmp::params

  validate_re($authtype, ['^SHA$','^MD5$'])
  validate_re($privtype, ['^AES$','^DES$'])
  validate_string($authpass)
  validate_string($privpass)

  $_authpass = pick($authpass, fqdn_rand_string(16,'','authpass'))
  $_privpass = pick($privpass, $authpass, fqdn_rand_string(16,'','privpass'))

  file { "/root/.${title}_snmppass":
    ensure  => $::snmp::params::ensure,
    replace => false,
    content => "${title} / ${_authpass} / ${_privpass}\n",
    mode    => '0600',
  }
  exec { "${title}_stop_${::snmp::params::service}":
    command     => '/sbin/pidof snmpd && /sbin/service snmpd stop || true',
    refreshonly => true,
    subscribe   => File["/root/.${title}_snmppass"],
  }
  exec { "${title}_reset_password":
    # lint:ignore:80chars
    command     => "/bin/echo createUser cacti ${authtype} ${_authpass} ${privtype} ${_privpass} >> ${::snmp::params::varsnmpdir}/${::snmp::params::service}.conf",
    # lint:endignore
    refreshonly => true,
    subscribe   => Exec["${title}_stop_${::snmp::params::service}"],
  }
}
