#!/bin/bash

hybrid_path=$1
smash_exe=$2
vhlle_exe=$3
sampler_exe=$4

configs_path="${hybrid_path}/configs"
mkdir -p ${configs_path}

sed "s|HYBRID_PATH|${hybrid_path}|g" "submit.sh" > "${hybrid_path}/submit.sh"
sed "s|HYBRID_PATH|${hybrid_path}|g" "submit_template.sh" > "${hybrid_path}/submit_template.sh"
sed -e "s|CONFIG_PATH|${configs_path}|g" -e "s|SMASH_EXECUTABLE|${smash_exe}|g" "configs/IC_DynFlu_template.yaml" > "${configs_path}/IC_DynFlu_template.yaml"
sed -e "s|CONFIG_PATH|${configs_path}|g" -e "s|VHLLE_EXECUTABLE|${vhlle_exe}|g" "configs/Hydro_DynFlu_template.yaml" > "${configs_path}/Hydro_DynFlu_template.yaml"
sed "s|SAMPLER_EXECUTABLE|${sampler_exe}|g" "configs/Sampler_DynFlu_template.yaml" > "${configs_path}/Sampler_DynFlu_template.yaml"
sed "s|SMASH_EXECUTABLE|${smash_exe}|g" "configs/Afterburner_DynFlu_template.yaml" > "${configs_path}/Afterburner_DynFlu_template.yaml"

cp configs/{smash_{initial_conditions,afterburner}_dynflu.yaml,{vhlle_hydro,hadron_sampler}_dynflu} ${configs_path}/
cp create_hybrid_configs.sh dynamic_fluidization_run.py ${hybrid_path}
