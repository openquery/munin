#!/bin/bash

# --no-check-certificate as wget 1.12-1.8.el6 didn't recognise *.domain in SubjectAltName

rm /etc/munin/openquery/mysql_.bak /etc/munin/openquery/numa_.bak
mv /etc/munin/openquery/mysql_ /etc/munin/openquery/mysql_.bak
mv /etc/munin/openquery/numa_ /etc/munin/openquery/numa_.bak
wget --no-check-certificate https://raw.githubusercontent.com/munin-monitoring/munin/devel/plugins/node.d/mysql_ -O /etc/munin/openquery/mysql_ || exit 1
wget --no-check-certificate https://raw.githubusercontent.com/munin-monitoring/munin/devel/plugins/node.d.linux/numa_ -O /etc/munin/openquery/numa_ || exit 1

if [ ! -f /usr/sbin/munin-asyncd.orig ]; then
    cp /usr/sbin/munin-asyncd /usr/sbin/munin-asyncd.orig
    wget --no-check-certificate https://raw.githubusercontent.com/munin-monitoring/munin/devel/node/_bin/munin-asyncd -O /usr/sbin/munin-asyncd || exit 1
    chown root: /usr/sbin/munin-asyncd
fi

chmod a+x /usr/sbin/munin-asyncd /etc/munin/openquery/mysql_ /etc/munin/openquery/numa_

munin-node-configure  --libdir /etc/munin/openquery/ --shell | sh

if selinuxenabled; then
# Centos 6.4 is munin_services_plugin_exec_t
  #semanage fcontext  -a  -t services_munin_plugin_exec_t  /etc/munin/openquery/mysql_ || semanage fcontext -a -t munin_services_plugin_exec_t "/etc/munin/openquery/.*_"
  semanage fcontext  -a  -t munin_selinux_plugin_exec_t  "/etc/munin/openquery(/.*)?"

  restorecon -rv /usr/sbin/munin-asyncd
  restorecon -rv /etc/munin/openquery/
  pushd /etc/munin/openquery
  make -f /usr/share/selinux/devel/Makefile && semodule -i munin_mysql.pp
  popd
fi

service munin-node restart
[ -e /etc/init.d/munin-asyncd ] && service munin-asyncd restart
[ -e /etc/init.d/munin-async  ] && service munin-async  restart
