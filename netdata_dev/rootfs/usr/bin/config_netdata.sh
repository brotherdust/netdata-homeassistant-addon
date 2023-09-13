#!/usr/bin/env bashio

configpath="/config/netdata/etc/netdata/netdata.conf"

# Retrieve the default Netdata configuration
if [ -r $configpath ]
then 
    bashio::log.info "Using existing Netdata Config in $configpath."
else
    bashio::log.info "No Netdata Config found. Creating from default..."
    mkdir /config/netdata
    cp /usr/bin/netdata.conf_default $configpath
    bashio::log.info "Netdata configuration: prefix all netdata paths with /config/netdata/"
    ini-file set -s directories -k config -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k "stock config" -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k log -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k web -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k cache -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k lib -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k lock -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k plugins -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k registry -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k "health config" -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s directories -k "stock health config" -v "/config/netdata/var/log/netdata/debug.log" $configpath
fi

NETDATA_HOSTNAME=$(bashio::config 'hostname')
bashio::log.info "Netdata configuration: set hostname to ${NETDATA_HOSTNAME}"
ini-file set -s global -k hostname -v "${NETDATA_HOSTNAME}" $configpath

NETDATA_PAGE_CACHE_SIZE=$(bashio::config 'page_cache_size')
bashio::log.info "Netdata configuration: set page_cache_size to ${NETDATA_PAGE_CACHE_SIZE}"
ini-file set -s db -k "dbengine page cache size MB" -v "${NETDATA_PAGE_CACHE_SIZE}" $configpath

NETDATA_DBENGINE_DISK_SPACE=$(bashio::config 'dbengine_disk_space')
bashio::log.info "Netdata configuration: set dbengine_multihost_disk_space to ${NETDATA_DBENGINE_DISK_SPACE}"
ini-file set -s db -k "dbengine multihost disk space MB" -v "${NETDATA_DBENGINE_DISK_SPACE}" $configpath

NETDATA_ENABLE_ALARM=$(bashio::config 'enable_alarm')
if [[ ${NETDATA_ENABLE_ALARM} == "false" ]]
then
    bashio::log.info "Netdata configuration: All alarms are DISABLED (${NETDATA_ENABLE_ALARM})"
    ini-file set -s health -k "enabled alarms" -v no $configpath
else
    bashio::log.info "Netdata configuration: All alarms are ENABLED (${NETDATA_ENABLE_ALARM})"
    ini-file set -s health -k "enabled alarms" -v '*' $configpath
fi

NETDATA_ENABLE_LOG=$(bashio::config 'enable_log')
if [[ ${NETDATA_ENABLE_LOG} == "false" ]]
then
    bashio::log.info "Netdata configuration: logging is DISABLED (${NETDATA_DISABLE_LOG})"
    ini-file set -s logs -k debug -v none $configpath
    ini-file set -s logs -k error -v none $configpath
    ini-file set -s logs -k connector -v none $configpath
    ini-file set -s logs -k access -v none $configpath
    ini-file set -s logs -k health -v none $configpath
else
    bashio::log.info "Netdata configuration: logging is ENABLED (${NETDATA_DISABLE_LOG})"
    ini-file set -s logs -k debug -v "/config/netdata/var/log/netdata/debug.log" $configpath
    ini-file set -s logs -k error -v "/config/netdata/var/log/netdata/error.log" $configpath
    ini-file set -s logs -k connector -v "/config/netdata/var/log/netdata/connector.log" $configpath
    ini-file set -s logs -k access -v "/config/netdata/var/log/netdata/access.log" $configpath
    ini-file set -s logs -k health -v "/config/netdata/var/log/netdata/health.log" $configpath
fi