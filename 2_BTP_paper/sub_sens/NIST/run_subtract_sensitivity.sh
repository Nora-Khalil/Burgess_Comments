#!/bin/bash
#SBATCH --job-name=NIST_sensitivity
#SBATCH --output=NIST_sensitivity.slurm.log
#SBATCH --error=NIST_error.slurm.log
#SBATCH --nodes=1
#SBATCH --partition=short
#SBATCH --mem=20Gb
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=8
#SBATCH --array=1



my_path="/work/westgroup/nora/Code/projects/Burgess_Comments/2_BTP_paper/models/NIST/2-BTP_kinetics_with_M.cti"

python subtract_sensitivity.py $my_path

