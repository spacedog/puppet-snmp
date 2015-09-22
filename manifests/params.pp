# == Class snmp::params
#
#  Default values for other classes in ::snmp module
#
# === Parameters
#
# None
#
# === Author
#
# Anton Baranov <abaranov@linuxfoundation.org
#
# === Copyright
# Copyright 2015 Anton Baranov
#
class snmp::params {
  $ensure         = 'present'
  $package_ensure = 'present'
  $config_file    = '/etc/snmp/snmpd.conf'
  $service        = 'snmpd'
  $service_ensure = 'running'
  $service_enable = true

  $base_snmpd_config = {
    'view' => {
      'systemview' => [
        {
          'type' => 'included',
          'oid'  => '.1.3.6.1.2.1.1',
        },
        {
          'type' => 'included',
          'oid'  => '.1.3.6.1.2.1.25.1.1',
        }
      ]
    }
  }

  # OS dependent parameters
  case $::osfamily {
    /^(Debian|Ubuntu)$/: {
      $package = 'snmpd'
      $os_snmpd_config = {
        'agentaddress'            => 'udp:127.0.0.1:161',
        'defaultmonitors'         => 'yes',
        'disk'                    => {
          '/'    => {
            'minspace' => '10000',
          },
          '/var' => {
            'minspace' => '5%',
          },
        },
        'extend-sh'               => {
          'test2'   => {
            'prog'  => 'echo Hello, world! ; echo Hi there ; exit 35'
          }
        },
        'extend'                  => {
          'test1'   => {
            'prog'  => '/bin/echo  Hello, world!',
          }
        },
        'includealldisks'         => '10%',
        'iquerysecname'           => 'internalUser',
        'linkupdownnotifications' => 'yes',
        'load'                    => {
          'max1'  => '12',
          'max5'  => '10',
          'max15' => '5',
        },
        'master'                  => 'agentx',
        'proc'                    => {
          'mountd' => {},
          'ntalkd' => {
            'max'  => 4
          },
          'sendmail' => {
            'max'    => 10,
            'min'    => 4,
          },
        },
        'rocommunity'             => {
          'public'    => [
            {
              'source' => 'default',
              'view'   => 'systemonly',
            }
          ],
        },
        'rouser'                  => {
          'authOnlyUser' => {
          },
          'internalUser' => {
          },
        },
        'syscontact'              => 'Me <me@example.org>',
        'syslocation'             => 'Sitting on the Dock of the Bay',
        'sysservices'             => 72,
        'trapsink'                => {
          'localhost'   => {
            'community' => 'public',
          },
        }

      }
    }
    default: {
      $package = 'net-snmp'
      $os_snmpd_config ={
        'access'                     => {
          'notConfigGroup' => {
            'context'      => '""',
            'version'      => 'any',
            'level'        => 'noauth',
            'prefix'       => 'exact',
            'read'         => 'systemview',
            'write'        => 'none',
            'notify'       => 'none',
          }
        },
        'com2sec'                    => {
          'notConfigUser' => {
            'source'      => 'default',
            'community'   => 'public',
          }
        },
        'dontLogTCPWrappersConnects' => 'yes',
        'group'                      => {
          'notConfigGroup' => [
            {
              'version' => 'v1',
              'secname' => 'notConfigUser',
            },
            {
              'version' => 'v2c',
              'secname' => 'notConfigUser',
            }
          ]
        },
        # lint:ignore:80chars
        'syscontact'  => 'Root <root@localhost> (configure /etc/snmp/snmp.local.conf)',
        # lint:endignore
        'syslocation' => 'Unknown (edit /etc/snmp/snmpd.conf)',
      }
    }
  }

  # Snmpd config
  $default_snmpd_config = merge($base_snmpd_config, $os_snmpd_config)

}
