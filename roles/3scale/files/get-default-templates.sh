#!/bin/bash

#
# This script gets the original 3scale template, converts it to JSON,
# scales down the DeploymentConfig's replicas to 0 and disable triggers.
#

curl -s -o amp.yml https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.0.0.GA/amp/amp.yml
yaml2json amp.yml |jq '(.objects[]|select(.kind== "DeploymentConfig").spec.replicas) |= 0 | (.objects[]|select(.kind== "DeploymentConfig").spec.triggers) |= []' > amp.json
