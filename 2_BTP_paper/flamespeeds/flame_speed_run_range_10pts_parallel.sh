#!/bin/sh

#SBATCH --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --job-name=HO2_switch
#SBATCH --error=error.slurm.%x.%a.log
#SBATCH --output=output.slurm.%x.%a.log
#SBATCH --cpus-per-task=8
#SBATCH --mem=20Gb 
#SBATCH --array=1
#SBATCH --partition=short


my_path="/work/westgroup/nora/Code/projects/Burgess_Comments/2_BTP_paper/final_RMG_model_with_HO2_rxns_switched.cti"


python flame_speed_calc_range_10pts_parallel.py $my_path
