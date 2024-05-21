import cantera as ct
from PIL import Image
from subprocess import run
import sys
from pathlib import Path
import matplotlib.pyplot as plt
import re 
import os
import numpy as np
import csv
import pandas as pd
import sys


##################### functions ############################################

def sensitivity(fraction):
    species_con =  {'CH4(3)': 0.5, 'O2(4)': 1, 'N2': 3.76, '2-BTP(1)': fraction}
    
    #make the gas, specify the TPX
    gas = ct.Solution(directory)
    gas.TPX = 298, ct.one_atm, species_con
    
    f = ct.FreeFlame(gas)
    
    ########## added in below
    tol_ss = [1.0e-13, 1.0e-9]  #abs and rel tolerances for steady state problem
    tol_ts = [1.0e-13, 1.0e-9] 
    
    
    f.flame.set_steady_tolerances(default=tol_ss)   #set tolerances
    f.flame.set_transient_tolerances(default=tol_ts)
        #flame.set_refine_criteria(ratio=3, slope=0.1, curve=0.1) 
    f.set_refine_criteria(ratio=5, slope=0.25, curve=0.27)
    f.max_time_step_count = 1000    
    f.solve()


    ########## save a flux diagram 
    diagram = ct.ReactionPathDiagram(f.gas,'H')
    diagram.show_details = True
    diagram.flow_type = 'NetFlow'
    diagram.scale=-1

    diagram.title = 'Reaction path diagram following H'
    diagram.label_threshold = 0.05

    dot_file = f'rxnpath_final_2_BTP.dot'
    img_file = f'rxnpath_final_2_BTP.png'
    img_path = Path.cwd().joinpath(img_file)

    diagram.write_dot(dot_file)
    #print(diagram.get_data())

    print("Wrote graphviz input file to '{0}'.".format(Path.cwd().joinpath(dot_file)))

    run('dot {0} -Tpng -o{1} -Gdpi=200'.format(dot_file, img_file).split())
    print("Wrote graphviz output file to '{0}'.".format(img_path))

    sens = f.get_flame_speed_reaction_sensitivities()
    
    return sens, gas


###################### get the model #######################################

directory = sys.argv[1]

file_name = directory.split('/')[-1]

BTPmole_list = list(np.linspace(0.0, 0.16268, 10))


###################loop that tracks how sensitivities of reactions changes as you increase volume fraction

for fraction in BTPmole_list: #skip the first because thats just fraction_1
    
    sens, gas = sensitivity(fraction)
    
    sensitivities={}
    for m in range(gas.n_reactions):
        sensitivities[m] = sens[m]

    sorted_sensitivities = dict(sorted(sensitivities.items(), key=lambda item: abs(item[1]), reverse=True)) #sort with highest magnitude first

    #save to Dataframe 
    data = {
        'cantera_index': [k for k,v in sorted_sensitivities.items()], #this is number of reaction in gas.reactions list
        'sensitivity': [v for k,v in sorted_sensitivities.items()], #sensitivity
        'cantera equation': [gas.reaction(k).equation for k,v in sorted_sensitivities.items()],
        'cantera products': [gas.reaction(k).products for k,v in sorted_sensitivities.items()],
        'cantera reactants': [gas.reaction(k).reactants for k,v in sorted_sensitivities.items()],
    }

    df = pd.DataFrame(data)
    df.to_csv(f'{file_name}_{fraction}_regular_sens_final_2btp.csv', index=False)

    