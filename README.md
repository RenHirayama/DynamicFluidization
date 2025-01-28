# Dynamic Fluidization handler

These scripts are meant to be used alongside the smash-vhlle-hybrid, available in 
https://github.com/smash-transport/smash-vhlle-hybrid, with dynamic fluidization.
Currently it relies on the singularity container in AG-Elfner, if this is not used
or available, please adapt the submit_template.sh script accordingly.

This version currently relies on my branch RenHirayama/add-max-p-option-dynflu for SMASH.
# How to use
 - Make sure all requirements (SMASH, vHLLE, smash-hadron-sampler) are properly compiled
 - Download the Hybrid handler (above link)
 - In this folder, run

```
bash setup.sh [Hybrid path] [SMASH executable] [vHLLE executable] [Sampler executable]
```

This will create some files in the Hybrid folder, along with templates for the hybrid 
config files in the associated "configs" folder. In order to create jobs, run
```
bash submit.sh [output path] [beam energy] [ev_min] [ev_max] {optional keys}
```
where "ev_min" and "ev_max" correspond to the event labels. By default, the colliding
ions are Au+Au, but this can be changed in the smash_initial_conditions_dynflu.yaml file,
or by adding the appropriate Software_keys to the IC input.

The optional keys are:
- `-t` or `--threshold`: energy density threshold for fluidization. Default is 0.5 GeV/fm³.
- `-m` or `--max_3mom`: maximum momentum for a fluidizable particle. Default is 6 GeV.

These scripts can be adapted for a general usage of the hybrid, i.e. with constant tau
initialization, but for that the handler already does a good job.
