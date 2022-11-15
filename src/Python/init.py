# This script sets up all directories for training. Directory structure is:
# projects
# └──project name
#       └──inputs
#              └──raw
#              └──intermediate
#              └──processed
#       └──outputs
#              └──models
#              └──visualizations

# Requirements
import yaml
import os

# make sure we are in the right directory
os.chdir('//home/gberman/github/tmc')

# load the configuration file
with open("configuration/corpus_config.yml") as config_settings:
    configs = yaml.load(config_settings, Loader=yaml.FullLoader)

print("Configuration file loaded.")

# create directories, as necessary
inputs_dir = ['raw', 'intermediate', 'processed']
outputs_dir = ['models', 'visualizations']

project_dir = configs['project_details']['name']
parent_dir = "projects"
root_dir = os.path.join(parent_dir, project_dir)

for i in range(0, len(inputs_dir)):
    dirName = str(root_dir) + '/inputs/' + str(inputs_dir[i])
    try: 
        os.makedirs(dirName)
        print("Directory ", dirName, " Created")
    except FileExistsError:
        print("Directory ", dirName, " already exists")
        
for i in range(0, len(outputs_dir)):
    dirName = str(root_dir) + '/outputs/' + str(outputs_dir[i])
    try: 
        os.makedirs(dirName)
        print("Directory ", dirName, " Created")
    except FileExistsError:
        print("Directory ", dirName, " already exists")

print("All directories created or already exist.")

