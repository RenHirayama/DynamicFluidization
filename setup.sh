#!/bin/bash

hybrid_path=$1
smash_exe=$2
vhlle_exe=$3
sampler_exe=$4

configs_path="${hybrid_path}/configs"
mkdir -p ${configs_path}

sed "s|HYBRID_PATH|${hybrid_path}|g" "submit_template.sh" > "${hybrid_path}/submit_template.sh"
sed -e "s|CONFIG_PATH|${configs_path}|g" -e "s|SMASH_EXECUTABLE|${smash_exe}|g" "configs/IC_DynFlu_template.yaml" > "${configs_path}/IC_DynFlu_template.yaml"
sed "s|VHLLE_EXECUTABLE|${vhlle_exe}|g" "configs/Hydro_DynFlu_template.yaml" > "${configs_path}/Hydro_DynFlu_template.yaml"
sed "s|SAMPLER_EXECUTABLE|${sampler_exe}|g" "configs/Sampler_DynFlu_template.yaml" > "${configs_path}/Sampler_DynFlu_template.yaml"
sed "s|SMASH_EXECUTABLE|${smash_exe}|g" "configs/Afterburner_DynFlu_template.yaml" > "${configs_path}/Afterburner_DynFlu_template.yaml"

cp configs/smash_initial_conditions_dynflu.yaml ${configs_path}/
cp submit.sh create_hybrid_configs.sh dynamic_fluidization_run.py ${hybrid_path}
