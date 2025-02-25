#!/bin/bash

output=$1
energy=$2
evmin=$3
evmax=$4

source ./default_parameters.sh
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--threshold)
      threshold="$2"
      shift # past argument
      shift # past value
      ;;
    -m|--mom|--max_3mom)
      max_3mom="$2"
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

bash create_hybrid_configs.sh HYBRID_PATH/${output} ${energy} --method "DynFlu" --threshold ${threshold} --fluid_time ${fluid_time}
sed  -e "s|OUTPUT_PATH|${output}|g" -e "s/ENERGY/${energy}/g" \
     -e "s/THRESHOLD/${threshold}/g" -e "s/MAX_3MOM/${max_3mom}/g" \
     -e "s/EVMIN/${evmin}/" -e "s/EVMAX/${evmax}/" \
     submit_template.sh > job_run_"${output}"_ft"${fluid_time}"_en"${energy}"_DynFlu"${threshold}"_${evmin}-${evmax}.sh
