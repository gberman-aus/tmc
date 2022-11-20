Bootstrap: docker
From: ubuntu:22.04
Stage: spython-base

%files
requirements.txt .
renv.lock renv.lock
.Rprofile .Rprofile
renv/activate.R renv/activate.R
renv/settings.dcf renv/settings.dcf
configuration /home/gberman/github/tmc/configuration/
projects /home/gberman/github/tmc/projects/
src /home/gberman/github/tmc/src
main.sh /home/gberman/github/tmc
%post

mkdir -p /home/gberman/github/tmc

DEBIAN_FRONTEND=noninteractive

# Install Python and R
apt-get update && apt-get install -y --no-install-recommends \
build-essential \
r-base \
r-base-dev \
python3.6 \
python3-pip \
python3-setuptools \
python3-dev \
libcurl4-openssl-dev \
libssl-dev \
libpoppler-cpp-dev \
libxml2-dev

# Install pip requirements
python3 -m pip install -r requirements.txt

# Install RENV and R requirements
RENV_VERSION=0.16.0
R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

mkdir -p /home/gberman/github/tmc
cd /home/gberman/github/tmc
mkdir -p renv

R -e "renv::restore()"


%environment
export DEBIAN_FRONTEND=noninteractive
export RENV_VERSION=0.16.0
%runscript
cd /home/gberman/github/tmc
exec /bin/bash bash main.sh "$@"
%startscript
cd /home/gberman/github/tmc
exec /bin/bash bash main.sh "$@"