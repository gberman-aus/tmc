FROM ubuntu:22.04

RUN mkdir -p /home/gberman/github/tmc

ENV DEBIAN_FRONTEND=noninteractive

# Install Python and R
RUN apt-get update && apt-get install -y --no-install-recommends \
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
COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt

# Install RENV and R requirements
ENV RENV_VERSION 0.16.0
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /home/gberman/github/tmc
COPY renv.lock renv.lock
RUN mkdir -p renv
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.dcf renv/settings.dcf

RUN R -e "renv::restore()"

# COPY configuration /home/gberman/github/tmc/configuration/
# COPY projects /home/gberman/github/tmc/projects/
# COPY src /home/gberman/github/tmc/src
# COPY main.sh /home/gberman/github/tmc

# CMD ["bash", "main.sh"]
