#!/bin/bash

#
# This script gets the original 3scale template, converts it to JSON and
# scale down the DeploymentConfig's replicas to 0.
#

curl -s -o amp.yml https://raw.githubusercontent.com/3scale/3scale-amp-openshift-templates/2.0.0.GA/amp/amp.yml
yaml2json amp.yml |jq '(.objects[]|select(.kind== "DeploymentConfig").spec.replicas) |= 0' > amp.json
