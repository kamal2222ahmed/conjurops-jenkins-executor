# Installs security patches
# http://packages.ubuntu.com/trusty-updates/unattended-upgrades
package 'unattended-upgrades'
execute 'unattended-upgrade -v'
