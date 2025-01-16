#!/usr/bin/env python3

#===================================================
#
#    Copyright (c) 2024
#      SMASH Hybrid Team
#
#    GNU General Public License (GPLv3 or later)
#
#===================================================

import argparse
import sys
import subprocess as subp

parser = argparse.ArgumentParser(description='Run hybrid handler for dynamic fluidization.')
parser.add_argument('--config_ic', '--ic', required=True,
                    help='Configuration IC file.')
parser.add_argument('--config_hydro_template', '--hydro', required=True,
                    help='Configuration template for the Hydro.')
parser.add_argument('--config_sampler_template', '--sampler', required=True,
                    help='Configuration template for the Sampler.')
parser.add_argument('--config_afterburner_template', '--afterburner', required=True,
                    help='Configuration template for the Afterburner.')
parser.add_argument('--run_IDs', '--ids', nargs='+', required=True,
                    help='List of run IDs.')
parser.add_argument('--output_directory', '-o', default="./data/",
                    help='Directory to save output data.')
parser.add_argument('--source', '-s', default="./",
                    help='Directory where the handler executable is located.')
parser.add_argument('-f', '--force', action='store_true',
                    help='Force removal of previous run data.')
parser.add_argument('--skip_ic', action='store_true',
                    help="Skip IC runs.")
parser.add_argument('--skip_hydro', action='store_true',
                    help="Skip Hydro runs.")
parser.add_argument('--skip_sampler', action='store_true',
                    help="Skip Sampler runs.")
parser.add_argument('--skip_afterburner', action='store_true',
                    help="Skip Afterburner runs.")
args = parser.parse_args()

modules = [("IC", args.config_ic, args.skip_ic),
        ("Hydro", args.config_hydro_template, args.skip_hydro),
        ("Sampler", args.config_sampler_template, args.skip_sampler),
        ("Afterburner", args.config_afterburner_template, args.skip_afterburner)]

if args.force:
    for run_id in args.run_IDs:
        for module,_,_ in modules:
            subp.Popen(
                ["rm", module+"/" + str(run_id) + "/*"],
                cwd=args.output_directory
            )

def replace_id_in_config_template(template, run_id):
    config = template.replace(".yaml", f"_{run_id}_temp.yaml")
    subp.Popen(f"sed s/%Run_ID/{run_id}/g {template} > {config}", shell=True)
    return config

def run_hybrid_handler(config_template, run_ids, source=args.source, output_directory=args.output_directory, **kwargs):
    runs = {}
    for run_id in run_ids:
        config = config_template
        if kwargs.get('replace_config', False):
            config = replace_id_in_config_template(config_template, run_id)

        runs[run_id] = subp.Popen(
            ["./Hybrid-handler", "do",
             "-c", config,
             "-o", output_directory,
             "--id", run_id],
            cwd=source, stdout=subp.PIPE, stderr=subp.PIPE
        )
        config = config_template
    
    exit_codes = [run.wait() for run in runs.values()]
    
    if 'logfile' in kwargs:
        with open(kwargs['logfile'], "wb") as logfile:
            for run in runs.values():
                logfile.write(run.stdout.read())
                logfile.write(run.stderr.read())
    
    return runs

for module,config,skip in modules:
    if not skip:
        print(f"Running {module} for run IDs {args.run_IDs} in {args.output_directory}")
        logfile = f"{args.output_directory}/{module}_{''.join(args.run_IDs)}_log.txt"
        replace=False if module=="IC" else True
        runs = run_hybrid_handler(config, args.run_IDs, replace_config=replace, logfile=logfile)
        print(runs)

for module,config,skip in modules:
    if module=="IC":
        continue
    if not skip:
        for run_id in args.run_IDs:
            config = replace_id_in_config_template(config, run_id)
            subp.run(['rm', config])
