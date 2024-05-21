#!/bin/sh

#SBATCH --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --job-name=140_removed
#SBATCH --error=error.slurm.%x.%a.log
#SBATCH --output=output.slurm.%x.%a.log
#SBATCH --cpus-per-task=8
#SBATCH --mem=20Gb 
#SBATCH --array=1
#SBATCH --partition=short

list_of_input_files=(copy_species_140_removed.cti)

index=$SLURM_ARRAY_TASK_ID-1

folder_name="${list_of_input_files[$index]}"  

my_path="/work/westgroup/nora/Code/projects/Burgess_Comments/2_BTP_optimization/models/RMG_with_BROH_specific_species_removed/copies/${folder_name}"


source activate cantera_env
python flame_speed_calc_range_1_pt_parallel.py $my_path
