class steamcmd (
  $user					=	'steam',
  $group				=	'steam',
  $home					=	'/usr/local/steam',
  $app_id				=	'',
  $steam_user			=	'',
  $steam_pass			=	'',
  $app_name				=	'',
  $force_install_dir	=	'',
)

class { 'staging':
  path	=>	$home,
  owner	=>	$user,
  group	=>	$group,
}

staging::deploy { 'steamcmd_linux.tar.gz':
  source	=>	'http://media.steampowered.com/client/steamcmd_linux.tar.gz'
  target	=>	$home,
  creates	=>	"${home}/steamcmd.sh",
}

group { $group:
  ensure	=	present,
}

user { $user:
  ensure	=>	present,
  managehome	=> true,
  home	=>	$home,
  gid	=>	$group,
}

file { $home:
  ensure	=>	directory,
  owner	=>	$user,
  group	=>	$group,
}

case #operatingsystem {
  'debian','ubuntu': {
    package { 'lib32gcc1',
	  ensure	=>	present,
	}
  }
  'redhat','centos','fedora','Scientific': {
    package { ['glibc.i686'. 'libstdc++.i686']:
	  ensure	=>	present,
	}
  }
}

exec { "${home}/steamcmd.sh +login ${steam_user} ${steam_pass} +force_install_dir ${home}/${force_install_dir} +app_update ${app_id} +quit":
  cwd	=>	"${home}",
  creates	=>	"${home}/${force_install_dir}"
}