#!/bin/sh

#SBATCH --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --job-name=edited_RMG_ss
#SBATCH --error=error.slurm.%x.%a.log
#SBATCH --output=output.slurm.%x.%a.log
#SBATCH --cpus-per-task=8
#SBATCH --mem=20Gb 
#SBATCH --array=1-7
#SBATCH --partition=short

list_of_input_files=(intersection_1_760_412_123.inp intersection_1_760_412.inp intersection_1_760.inp intersection_30_377_91_33_15_357_1_760_16_34_97_38_245_124_104_718_412_561_3_94_123.inp intersection_30_91_33_15_1_760_34_245_124_104_718_412_561_3_94_123.inp  intersection_33_1_760_718_412_123.inp intersection_91_33_1_760_718_412_561_3_94_123.inp)


index=$SLURM_ARRAY_TASK_ID-1

folder_name="${list_of_input_files[$index]}"  

my_path="/work/westgroup/nora/Code/projects/Burgess_Comments/2_BTP_optimization/models/edited_RMG_with_BROH/copies/${folder_name}"

source activate cantera_env
python flame_speed_calc_range_10pts_parallel.py $my_path
