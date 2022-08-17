#!/usr/bin/env bash

set -euo pipefail
echo '$seq' >  '$id$fix'
runpsipred_single '$id$fix'
