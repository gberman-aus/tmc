# Main script for pre-processing and training stm models.


echo "Setting up directories"

export working_path=$PWD

python3 src/Python/init.py > log.csv

echo "Getting dataset"

python3 src/Python/code_extractor.py > log.csv

echo "Cleaning and preparing the data"

Rscript src/R/corpus_cleaning.R > log.csv

echo "Training the model. Will take some time."

Rscript src/R/model_training.R > log.csv

echo "Shutting down."