#!/bin/bash
while [ ! -f /usr/local/bin/wait.sh ] || [ $(stat -c "%a" /usr/local/bin/wait.sh) != "755" ]; do sleep 1; done

# Manually setting this because the auto-configured JAVA_HOME isn't very reliable. This path is valid for ubuntu:1604 (Java 8) and ubuntu:1804 (Java 11) at least.
JAVA_HOME="/usr/lib/jvm/default-java"
export GREEN='\033[0;32m'
export NC='\033[0m'
clear
wait.sh
