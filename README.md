munin
=====

Here are a set of Open Query customisations for Munin.

Elements from our contributions upstream that we pull back to the current version:

munin-asyncd has been altered to run strictly on the interval relative to the
wall clock rather than the async starting time. (upstream version 2.1.10+/2.0.24+)

mysql\_ plugin - lots of added graphs

numa\_ plugin - new

See offical codebase:
https://github.com/munin-monitoring/munin

Using munin-async
-----------------

git clone https://github.com/openquery/munin.git /etc/munin/openquery

If using Debian (and I assume Ubuntu too)
create /etc/default/munin-asyncd and set it with the following:

DAEMON_ARGS="--spooldir /var/lib/munin-async"

After that /etc/init.d/munin-async will work as normal

Using our plugins
-----------------

git clone https://github.com/openquery/munin.git /etc/munin/openquery

sudo /etc/munin/openquery/link.sh


