#!/bin/bash

output=$1
energy=$2
threshold=$3
evmin=$4
evmax=$5

bash create_hybrid_configs.sh ${output} ${energy} "DynFlu" ${threshold}
sed  -e "s/OUTPUT/${output}/g" -e "s/ENERGY/${energy}/g" -e "s/THRESHOLD/${threshold}/g"  -e "s/EVMIN/${evmin}/" -e "s/EVMAX/${evmax}/" submit_template.sh > job_run"${output}${energy}"_DynFlu"${threshold}"_${evmin}-${evmax}.sh
