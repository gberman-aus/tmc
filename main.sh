# Main script for pre-processing and training stm models.

echo "Setting up directories"

python3 src/Python/init.py

echo "Getting dataset"

python3 src/Python/code_extractor.py

# echo "Cleaning and preparing the data"

# Rscript src/R/corpus_cleaning.R

# echo "Training the model. Will take some time."

# Rscript src/R/model_training.R

# echo "Shutting down."