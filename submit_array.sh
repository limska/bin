#!/bin/bash
#SBATCH --nodes=1
#SBATCH --job-name="Evogaurd"
#SBATCH --comment="--only.preproc.geo --logfile --skip.casezip"
#SBATCH --tasks-per-node=8
#SBATCH --ntasks=1
#SBATCH --array=0-6
#SBATCH --time=01:00:00

# Define your list of varying arguments in a Bash array
ARGS=("24698" "24697" "24696" "24695" "24201" "24091" "24085")

# Get the specific argument for this task index
CURRENT_ARG=${ARGS[$SLURM_ARRAY_TASK_ID]}
JOBPATH=/home/sava/data/pump/prod_${CURRENT_ARG}
OUTPUT=${JOBPATH}/slurm-output.out

rm -rf ${JOBPATH}

# Execute using srun
srun --ntasks=1 --exclusive -J "evoguard-prod_${CURRENT_ARG}" -o $OUTPUT /home/sava/repo/runner/scripts/run.py centri_pump --cb local --cbi tcae=int cfmesh=int --system prod ${CURRENT_ARG} --sim.mesh_proc_count 8 --sim.run_proc_count 8 --only.preproc.geo --logfile --skip.casezip


if grep -q "Processing finished" "$OUTPUT"; then
    echo "Validation passed: Found success token."
    exit 0
else
    echo "ERROR: 'Processing finished' not found in log!" >&2
    exit 1
fi

wait
