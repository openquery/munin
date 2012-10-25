#!/bin/sh


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
