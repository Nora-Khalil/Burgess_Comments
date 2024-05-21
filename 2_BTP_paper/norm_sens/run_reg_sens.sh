#!/bin/bash
#SBATCH --job-name=reg_sensitivity
#SBATCH --output=reg_sensitivity.slurm.%x.log
#SBATCH --error=reg_error_sensitivity.slurm.%x.log
#SBATCH --nodes=1
#SBATCH --partition=short
#SBATCH --mem=20Gb
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=8
#SBATCH --array=1


my_path="/work/westgroup/nora/Code/projects/Burgess_Comments/2_BTP_paper/final_RMG_model_with_HO2_rxns_switched.cti"

python regular_sensitivity.py $my_path