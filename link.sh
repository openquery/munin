#!/bin/bash

# grep '^\$graphs{' mysql_ | cut -f 2 -d { | cut -f 1 -d } | xargs -n1 -I ^ echo mysql_^ \\

if pidof mysqld
then
  rm -f /etc/munin/plugins/mysql_files_tables
  for m in  \
mysql_bin_relay_log \
mysql_commands \
mysql_connections \
mysql_files \
mysql_tables \
mysql_table_definitions \
mysql_innodb_bpool \
mysql_innodb_bpool_act \
mysql_innodb_bpool_internal_breakdown \
mysql_innodb_insert_buf \
mysql_innodb_adaptive_hash \
mysql_innodb_io \
mysql_innodb_io_pend \
mysql_innodb_log \
mysql_innodb_rows \
mysql_innodb_semaphores \
mysql_innodb_tnx \
mysql_performance \
mysql_innodb_srv_master_thread \
mysql_innodb_queries \
mysql_innodb_read_views \
mysql_innodb_descriptors \
mysql_myisam_indexes \
mysql_network_traffic \
mysql_qcache \
mysql_qcache_mem \
mysql_max_mem \
mysql_replication \
mysql_select_types \
mysql_slow \
mysql_sorts \
mysql_table_locks \
mysql_tmp_tables \
mysql_rows \
mysql_handler_read \
mysql_handler_transaction \
mysql_handler_write \
mysql_handler_tmp \
mysql_execution \
mysql_icp \
mysql_mrr \
    ;
  do
    rm -f "/etc/munin/plugins/${m}"
    ln -s /etc/munin/openquery/mysql_ "/etc/munin/plugins/${m}"
  done
  if [ -e /usr/lib*/galera/libgalera_smm.so ]; then

    for m in  \
mysql_wsrep_cluster_status \
mysql_wsrep_cluster_size \
mysql_wsrep_local_state \
mysql_wsrep_transactions \
mysql_wsrep_writesets \
mysql_wsrep_writesetbytes \
mysql_wsrep_errors \
mysql_wsrep_queue \
mysql_wsrep_concurrency \
mysql_wsrep_flow \
mysql_wsrep_flow_paused \
mysql_wsrep_flow_paused_ns \
mysql_wsrep_distance \
      ;
    do
      rm -f "/etc/munin/plugins/${m}"
      ln -s /etc/munin/openquery/mysql_ "/etc/munin/plugins/${m}"
    done
  fi


fi

pushd /etc/munin/openquery/conf
for conf in * ; do
  [ -e "/etc/munin/plugin-conf.d/${conf}" ] || \
    ln -s "/etc/munin/openquery/conf/${conf}" /etc/munin/plugin-conf.d/
done
popd


if selinuxenabled; then
# Centos 6.4 is munin_services_plugin_exec_t
  semanage fcontext  -a  -t services_munin_plugin_exec_t  /etc/munin/openquery/mysql_ || semanage fcontext -a -t munin_services_plugin_exec_t "/etc/munin/openquery/.*_"
  semanage fcontext  -a  -t munin_etc_t  "/etc/munin/openquery/conf(/.*)?"
  semanage fcontext  -a  -t munin_exec_t  "/etc/munin/openquery/munin-asyncd"


  restorecon -rv /etc/munin/openquery/
  pushd /etc/munin/openquery
  make -f /usr/share/selinux/devel/Makefile
  semodule -i munin_mysql.pp
  popd
fi

service munin-node restart || /etc/init.d/munin-node restart
[ -e /etc/init.d/munin-asyncd ] && service munin-asyncd restart
[ -e /etc/init.d/munin-async  ] && service munin-async  restart
