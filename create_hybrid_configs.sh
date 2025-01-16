#!/bin/bash

output_path=$1
energy=$2
method=$3
threshold=$4

configs_path="${output_path}/${method}${threshold}/${energy}/configs/"
templates_path="configs/"
mkdir -p ${configs_path}

for module in IC Hydro Sampler Afterburner; do 
  template="${module}_${method}_template.yaml"
  config=${template/_template/${threshold}_${energy}}
  echo ${template} ${config}
  sed -e "s|OUTPUT_PATH|${output_path}|g" -e "s/ENERGY/${energy}/g" -e "s/METHOD/${method}/g" -e "s/THRESHOLD/${threshold}/g" "${templates_path}/${template}" > "${configs_path}/${config}"
done
