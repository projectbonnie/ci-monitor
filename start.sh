#!/bin/bash
cd /Users/pophealth/ci-monitor
. /usr/local/rvm/scripts/rvm
rvm use 1.9.2
foreman start
