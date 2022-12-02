#!/bin/bash

set -euo pipefail

export JAVA_HOME=$(which java | xargs readlink -f | sed "s:/bin/java::")

HADOOP_DATA_DIR="/var/lib/hadoop"
HADOOP_LOG_DIR="$HADOOP_DATA_DIR/logs"
HIVE_DATA_DIR="/var/lib/hive"
HIVE_LOG_DIR="$HIVE_DATA_DIR/logs"

export HMS_DBTYPE=${HMS_DBTYPE:-derby}

function print_help {
  echo "Supported commands:"
  #todo: help

  echo ""
  echo "Other commands can be specified to run shell commands."
}

function run_namenode() {
  if [ ! -f "${HADOOP_DATA_DIR}/namenode_initialized" ]; then
    $HADOOP_HOME/bin/hdfs namenode -format
    touch ${HADOOP_DATA_DIR}/namenode_initialized
  fi

  exec $HADOOP_HOME/bin/hdfs namenode
}

function run_datanode() {
  exec $HADOOP_HOME/bin/hdfs datanode
}

function run_resource_manager() {
  exec $HADOOP_HOME/bin/yarn resourcemanager
}

function run_node_manager() {
  exec $HADOOP_HOME/bin/yarn nodemanager
}

function run_history_server() {
  exec $HADOOP_HOME/bin/mapred historyserver
}


function run_hive_metastore() {
  # If the derby files do not exist, then initialize the schema.
  if [ ! -f "${HIVE_DATA_DIR}/metastore_initialized" ]; then
    $HIVE_HOME/bin/schematool -dbType $HMS_DBTYPE -initSchema
    touch ${HIVE_DATA_DIR}/metastore_initialized
  fi
  # Start the Hive Metastore.
  exec $HIVE_HOME/bin/hive --service metastore
}

function run_hive_server2() {
  # Start the Hive Server2.
  exec $HIVE_HOME/bin/hive --service hiveserver2
}


# If no arguments are passed, print the help.
if [[ $# -eq 0 ]]; then
  print_help
  exit 1
fi

mkdir -p $HADOOP_DATA_DIR
mkdir -p $HADOOP_LOG_DIR
mkdir -p $HIVE_DATA_DIR
mkdir -p $HIVE_LOG_DIR
if [[ "$1" == "nn" ]]; then
  run_namenode
  exit 0
elif [[ "$1" == "dn" ]]; then
  run_datanode
  exit 0
elif [[ "$1" == "rm" ]]; then
  run_resource_manager
  exit 0
elif [[ "$1" == "nm" ]]; then
  run_node_manager
  exit 0
elif [[ "$1" == "hs" ]]; then
  run_history_server
  exit 0
elif [[ "$1" == "hms" ]]; then
  run_hive_metastore
  exit 0
elif [[ "$1" == "hs2" ]]; then
  run_hive_server2
  exit 0
elif [[ "$1" == "help" ]]; then
  print_help
  exit 0
fi
# Support calling anything else in the container.
exec "$@"
