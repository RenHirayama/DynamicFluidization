#!/bin/bash

output_path=$1
energy=$2

source ./default_parameters.sh

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--threshold)
      threshold="$2"
      shift # past argument
      shift # past value
      ;;
    --mom|--max_3mom)
      max_3mom="$2"
      shift # past argument
      shift # past value
      ;;
    -m|--method)
      method="$2"
      shift # past argument
      shift # past value
      ;;
    -f|--fluid_time|--formation_time_factor)
      fluid_time="$2"
      shift
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

configs_path="${output_path}/${energy}/configs/"
templates_path="configs/"
mkdir -p ${configs_path}

for module in IC Hydro Sampler Afterburner; do 
  template="${module}_${method}_template.yaml"
  config=${template/_template/${threshold}_${energy}}
  echo ${template} ${config}
  sed -e "s|OUTPUT_PATH|${output_path}|g" -e "s/ENERGY/${energy}/g" -e "s/METHOD/${method}/g" \
      -e "s/THRESHOLD/${threshold}/g" -e "s/MAX_3MOM/${max_3mom}/g" -e "s/FLUID_TIME/${fluid_time}/g" \
      "${templates_path}/${template}" > "${configs_path}/${config}"
done
