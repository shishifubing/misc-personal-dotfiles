#!/bin/env bash

# get api url
kubernetes_api() {

     kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ {print $NF}'

}
