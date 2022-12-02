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
echo "Add sentry at ${SENTRY_HOME} to build context"
cp -r $SENTRY_HOME ./build_context/sentry
echo "Add ranger at ${RANGER_HOME} to build context"
cp -r $RANGER_HOME ./build_context/ranger
echo "Add hadoop-lzo at ${HADOOP_LZO} to build context"
cp -r $HADOOP_LZO ./build_context/hadoop-lzo

docker build -t $IMAGE_NAME --build-arg CONTEXT_DIR=./build_context .

echo "Cleanup build context"
rm -rf ./build_context

echo "Done. The image is built with name ${IMAGE_NAME}."
