#!/bin/sh

#SBATCH --nodes=1
#SBATCH --time=6-00:00:00
#SBATCH --job-name=edited_RMG_fc
#SBATCH --error=error.slurm.%x.log
#SBATCH --output=output.slurm.%x.log
#SBATCH --cpus-per-task=8
#SBATCH --mem=20Gb 
#SBATCH --array=1-11
#SBATCH --partition=west

list_of_input_files=(rxn_1.cti rxn_13.cti rxn_30.cti rxn_33.cti rxn_357.cti rxn_374.cti rxn_38.cti rxn_58.cti rxn_685.cti rxn_746_NC.cti rxn_91.cti)

index=$SLURM_ARRAY_TASK_ID-1

folder_name="${list_of_input_files[$index]}"  

my_path="/work/westgroup/nora/Code/projects/Burgess_Comments/2_BTP_optimization/models/edited_RMG/${folder_name}"


source activate cantera_env
python flame_speed_calc_range_10pts_parallel.py $my_path
