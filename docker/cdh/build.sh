#!/bin/bash -e

IMAGE_NAME=$1

# Make build context
echo "Making build context..."
mkdir build_context
echo "Add hbase at ${HBASE_HOME} to build context"
cp -r $HBASE_HOME ./build_context/hbase
echo "Add hadoop at ${HADOOP_HOME} to build context"
cp -r $HADOOP_HOME ./build_context/hadoop
echo "Add hive at ${HIVE_HOME} to build context"
cp -r $HIVE_HOME ./build_context/hive

echo "Prepare JDBC Driver from ${POSTGRES_JDBC_DRIVER} to build context"
cp ${POSTGRES_JDBC_DRIVER} ./build_context/hive/lib/

docker build -t $IMAGE_NAME --build-arg CONTEXT_DIR=./build_context .

echo "Cleanup build context"
rm -rf ./build_context

echo "Done. The image is built with name ${IMAGE_NAME}."