munin
=====

Here are a set of Open Query customisations for Munin.

munin-asyncd has been altered to run strictly on the interval relative to the
wall clock rather than the async starting time.

Other elements here are customisations that we intend to contribute back.

See offical codebase:
https://github.com/munin-monitoring/munin

Using munin-async
-----------------

git clone https://github.com/openquery/munin.git /etc/munin/openquery

If using Debian (and I assume Ubuntu too)
create /etc/default/munin-asyncd and set it with the following:

DAEMON=/etc/munin/openquery/$NAME
DAEMON_ARGS="--spooldir /var/lib/munin-async"

After that /etc/init.d/munin-async will work as normal

Using our plugins
-----------------

git clone https://github.com/openquery/munin.git /etc/munin/openquery

sudo /etc/munin/openquery/link.sh


