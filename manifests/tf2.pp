class steamcmd::tf2 (
  $app_id     = '232250',
  $app_name   = 'tf2',
){

  include steamcmd

  exec { "${steamcmd::home}/steamcmd.sh +login ${steamcmd::steam_user} ${steamcmd::steam_pass} +force_install_dir ${steamcmd::home}/${app_name} +app_update ${app_id} +quit":
    cwd     =>  "${steamcmd::home}",
    creates =>  "${steamcmd::home}/${app_name}",
    user    =>  'steam',
    require =>  staging::deploy['steamcmd_linux.tar.gz'],
  }

  file { 'tf2.sh':
    path    => '/usr/local/steam/tf2.sh',
    ensure  => file,
    require => staging::deploy['steamcmd_linux.tar.gz'],
    content => template("steamcmd/tf2.sh.el7.erb"),
  } ->
  file { 'tf2server.service':
    path    => '/etc/systemd/system/tf2server.service',
    ensure  => file,
    require => staging::deploy['steamcmd_linux.tar.gz'],
    content => template("steamcmd/tf2server.service.el7.erb"),
  } ->
  file { 'tf2server.timer':
    path    => '/etc/systemd/system/tf2server.timer',
    ensure  => file,
    require => staging::deploy['steamcmd_linux.tar.gz'],
    content => template("steamcmd/tf2server.timer.el7.erb"),
  } ->
  service { "tf2server":
    enable => true,
  }


}
