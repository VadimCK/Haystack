#!/bin/bash
export RACK_ENV="production"
bundle exec puma -b tcp://127.0.0.1:3000
