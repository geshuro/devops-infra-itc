#!/usr/bin/env bash

set -e

# This script takes two arguments in the json input
#   manifest_file: the path to a manifest file to be diffed against what's online
#   kubeconfig: the path to the kubeconfig file

# Extract "manifest_file" and "kubeconfig" arguments from the input into
# MANIFEST_FILE and KUBECONFIG shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "MANIFEST_FILE=\(.manifest_file) KUBECONFIG=\(.kubeconfig)"')"

DRIFT="$( kubectl --kubeconfig ${KUBECONFIG} diff -f ${MANIFEST_FILE} || true)"
if [[ -z "${DRIFT}" ]]; then
  CHANGED="false"
else
  CHANGED="true"
fi

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg changed "${CHANGED}" '{"changed":$changed}'
