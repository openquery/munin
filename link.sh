#!/bin/bash


if pidof mysqld
then
  for m in  \
    mysql_bin_relay_log \
    mysql_commands \
    mysql_connections \
    mysql_files_tables \
    mysql_innodb_bpool \
    mysql_innodb_bpool_act \
    mysql_innodb_insert_buf \
    mysql_innodb_io \
    mysql_innodb_io_pend \
    mysql_innodb_log \
    mysql_innodb_rows \
    mysql_innodb_semaphores \
    mysql_innodb_tnx \
    mysql_myisam_indexes \
    mysql_network_traffic \
    mysql_qcache \
    mysql_qcache_mem  \
    mysql_replication \
    mysql_select_types \
    mysql_slow \
    mysql_sorts \
    mysql_table_locks \
    mysql_tmp_tables \
    ;
  do
    rm -f "/etc/munin/plugins/${m}"
    ln -s /etc/munin/openquery/mysql_ "/etc/munin/plugins/${m}"
  done
fi

pushd /etc/munin/openquery/conf
for conf in * ; do
  [ -e "/etc/munin/plugin-conf.d/${conf}" ] || \
    ln -s "/etc/munin/openquery/conf/${conf}" /etc/munin/plugin-conf.d/
done
popd


if selinuxenabled; then
  semanage fcontext  -a  -t services_munin_plugin_exec_t  /etc/munin/openquery/mysql
  semanage fcontext  -a  -t munin_etc_t  "/etc/munin/openquery/conf(/.*)?"
  semanage fcontext  -a  -t munin_exec_t  "/etc/munin/openquery/munin-asyncd"


  restorecon -rv /etc/munin/openquery/
fi

service munin-node restart || /etc/init.d/munin-node restart
service munin-async restart || /etc/init.d/munin-async restart
