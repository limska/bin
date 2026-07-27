#!/usr/bin/env xonsh

#SBATCH --nodes=1
#SBATCH --job-name="Evogaurd"
#SBATCH --comment="--only.preproc.geo --logfile --skip.casezip"
#SBATCH --tasks-per-node=8
#SBATCH --ntasks=1
#SBATCH --array=0-6
#SBATCH --time=01:00:00
#SBATCH --exclusive

from pathlib import Path

# Define your list of varying arguments in a Bash array
cases = [ 24698, 24697, 24696, 24695, 24201, 24091, 24085 ]

# Get the specific argument for this task index
array_index = int($SLURM_ARRAY_TASK_ID)
print(f"{array_index=}")
current_arg = cases[array_index]
print(f"{current_arg=}")
job_path_name = f"prod_{current_arg}"
job_path = Path("/home") / "sava" / "data" / "pump" / job_path_name
output = job_path / "slurm-output.out"
runner_args = ["--only.preproc.geo",  "--logfile", "--skip.casezip"]

rm -rf @(job_path)

# Execute using srun
srun --ntasks=1 --exclusive -J @(f"evoguard-prod_{job_path_name}") -o @(output) /home/sava/repo/runner/scripts/run.py centri_pump --cb local --cbi tcae=int cfmesh=int --system prod @(current_arg) --sim.mesh_proc_count 8 --sim.run_proc_count 8 @(runner_args)

proc = ![grep -q "Processing finished" @(output)]
if proc.returncode == 0:
    print("Validation passed: Found success token.")
    sys.exit(0)
else:
    print("ERROR: 'Processing finished' not found in log!")
    sys.exit(1)

wait
