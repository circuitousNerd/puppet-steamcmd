class steamcmd (
  $user       = 'steam',
  $group      = 'steam',
  $home       = '/usr/local/steam',
  $steam_user = 'anonymous',
  $steam_pass = '',
){

  staging::deploy { 'steamcmd_linux.tar.gz':
    source	=>  'http://media.steampowered.com/client/steamcmd_linux.tar.gz',
    target	=>  $home,
    creates	=>  "${home}/steamcmd.sh",
  }

  group { $group:
    ensure  =>  present,
  }

  user { $user:
    ensure      =>  present,
    managehome  =>  true,
    home        =>  $home,
    gid         =>  $group,
  }

  file { $home:
    ensure  =>	directory,
    owner   =>	$user,
    group   =>	$group,
    recurse =>	true,
    before  =>  staging::deploy['steamcmd_linux.tar.gz'],
  }

  case $operatingsystem {
    'debian','ubuntu': {
      package { 'lib32gcc1': ensure => present, }
    }
    'redhat','centos','fedora','Scientific': {
      package { ['glibc.i686', 'libstdc++.i686', 'ncurses-libs']:
        ensure  =>  present,
      }
    }
  }
}
