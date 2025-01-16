#!/bin/bash
#SBATCH --job-name=dfTHRESHOLD_ENERGYrunEVMIN-EVMAX
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --output=gen_run_%j.out
#SBATCH --error=gen_run_%j.err
#SBATCH --partition=long
#SBATCH --time=2-15:29:00
#SBATCH --mail-type=ALL
#SBATCH --mem=30GB

export SLURM_WORKING_DIR=HYBRID_PATH
export CON_hybrid=/lustre/hyihp/AG-Elfner/smash-vhlle-hybrid-framework.sif

SOURCE=${SLURM_WORKING_DIR}

cd ${SOURCE}
SYS_DIR=${SOURCE}/"OUTPUT"
EN_DIR="${SYS_DIR}/DynFluTHRESHOLD/ENERGY"
CONFIG_DIR=${EN_DIR}"/configs"
SUFFIX="DynFluTHRESHOLD_ENERGY"

singularity exec ${CON_hybrid} python3 ${SOURCE}/dynamic_fluidization_run.py --ic ${CONFIG_DIR}/IC_${SUFFIX}.yaml --hydro ${CONFIG_DIR}/Hydro_${SUFFIX}.yaml --sampler ${CONFIG_DIR}/Sampler_${SUFFIX}.yaml --afterburner ${CONFIG_DIR}/Afterburner_${SUFFIX}.yaml --ids {EVMIN..EVMAX} -s ${SOURCE} -o ${EN_DIR} 

# wait for the smash processes to finish
wait
