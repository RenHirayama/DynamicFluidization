#!/bin/bash

output=$1
energy=$2
evmin=$3
evmax=$4

threshold=0.5
max_3mom=6

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

bash create_hybrid_configs.sh HYBRID_PATH/${output} ${energy} "DynFlu" -t ${threshold} -m ${max_3mom}
sed  -e "s|OUTPUT_PATH|${output}|g" -e "s/ENERGY/${energy}/g" \
     -e "s/THRESHOLD/${threshold}/g" -e "s/MAX_3MOM/${max_3mom}/g" \
     -e "s/EVMIN/${evmin}/" -e "s/EVMAX/${evmax}/" \
     submit_template.sh > job_run_"${output}"_"${energy}"_DynFlu"${threshold}"_${evmin}-${evmax}.sh
