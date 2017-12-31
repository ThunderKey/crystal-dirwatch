#!/bin/bash

set -e

crystal tool format "$@" $(find -name "*.cr" -not -path "./lib/*")
