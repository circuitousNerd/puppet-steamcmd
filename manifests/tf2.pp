class steamcmd::tf2 inherits steamcmd (
  $app_id     = '232250',
  $app_name   = 'tf2',
){

  exec { "${steamcmd::home}/steamcmd.sh +login ${steamcmd::steam_user} ${steamcmd::steam_pass} +force_install_dir ${steamcmd::home}/${app_name} +app_update ${app_id} +quit":
    cwd     =>  "${steamcmd::home}",
    creates =>  "${steamcmd::home}/${app_name}",
    user    =>  'steam',
    require =>  staging::deploy['steamcmd_linux.tar.gz'],
  }

}
