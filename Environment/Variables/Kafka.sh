#!/usr/bin/env bash
export PATH=$USER_ENV_UTILS/Kafka/latest/bin:$PATH
alias kafka-start='kafka-server-start.sh ~/Environment/Utilities/Kafka/latest/config/server.properties'
alias kafka-stop='kafka-server-stop.sh'
