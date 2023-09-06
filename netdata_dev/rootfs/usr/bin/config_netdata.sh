#!/usr/bin/env bashio

# Retrieve the default Netdata configuration
if [ -r /config/netdata/config/netdata.conf ]
then 
    bashio::log.info "Using existing Netdata Config."
else
    bashio::log.info "No Netdata Config found. Creating from default..."
    /opt/netdata/bin/netdata -d -p 19999 & sleep 2
    mkdir -p /config/netdata/{config,lib,cache}
    curl -so /config/netdata/config/netdata.conf http://localhost:19999/netdata.conf
    pkill -9 netdata
fi

# Configure Netdata
TAB=$'\t'

NETDATA_HOSTNAME=$(bashio::config 'hostname')
bashio::log.info "Netdata configuration: set hostname to ${NETDATA_HOSTNAME}"
sed -i "s/${TAB}# hostname = .*/${TAB}hostname = ${NETDATA_HOSTNAME}/" /config/netdata/config/netdata.conf

NETDATA_PAGE_CACHE_SIZE=$(bashio::config 'page_cache_size')
bashio::log.info "Netdata configuration: set page_cache_size to ${NETDATA_PAGE_CACHE_SIZE}"
sed -i "s/${TAB}# page cache size = .*/${TAB}page cache size = ${NETDATA_PAGE_CACHE_SIZE}/" /config/netdata/config/netdata.conf

NETDATA_DBENGINE_DISK_SPACE=$(bashio::config 'dbengine_disk_space')
bashio::log.info "Netdata configuration: set dbengine_multihost_disk_space to ${NETDATA_DBENGINE_DISK_SPACE}"
sed -i "s/${TAB}# dbengine multihost disk space = .*/${TAB}dbengine multihost disk space = ${NETDATA_DBENGINE_DISK_SPACE}/" /config/netdata/config/netdata.conf

NETDATA_ENABLE_ALARM=$(bashio::config 'enable_alarm')
if [[ ${NETDATA_ENABLE_ALARM} == "false" ]]
then
    bashio::log.info "Netdata configuration: alarm is ${NETDATA_DISABLE_ALARM}"
    sed -i "s/${TAB}# enabled = .*/${TAB}enabled = no/" /config/netdata/config/netdata.conf
fi

NETDATA_ENABLE_LOG=$(bashio::config 'enable_log')
if [[ ${NETDATA_ENABLE_LOG} == "false" ]]
then
    bashio::log.info "Netdata configuration: logging is DISABLED (${NETDATA_DISABLE_LOG})"
    sed -i "s/${TAB}# debug log = .*/${TAB}debug log = none/" /config/netdata/config/netdata.conf
    sed -i "s/${TAB}# error log = .*/${TAB}error log = none/" /config/netdata/config/netdata.conf
    sed -i "s/${TAB}# access log = .*/${TAB}access log = none/" /config/netdata/config/netdata.conf
fi

bashio::log.info "Netdata configuration: set config path to /config/netdata/config"
sed -i "s+${TAB}# config directory = .*+${TAB}config directory = /config/netdata/config #DO NOT EDIT+" /config/netdata/config/netdata.conf

bashio::log.info "Netdata configuration: set lib path to /config/netdata/lib"
sed -i "s+${TAB}# lib directory = .*+${TAB}lib directory = /config/netdata/lib #DO NOT EDIT+" /config/netdata/config/netdata.conf

bashio::log.info "Netdata configuration: set cache path to /config/netdata/cache"
sed -i "s+${TAB}# cache directory = .*+${TAB}cache directory = /config/netdata/cache #DO NOT EDIT+" /config/netdata/config/netdata.conf

bashio::log.info "Netdata configuration: set home path to /config/netdata/cache"
sed -i "s+${TAB}# home directory = .*+${TAB}home directory = /config/netdata/cache #DO NOT EDIT+" /config/netdata/config/netdata.conf