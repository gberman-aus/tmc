# tmc: TopicModelContainers

This repository is my work in progress in developing a wrapper for the stm R package, than enables easy estimation of stm topic models within a Docker container, which can be run (almost) anywhere.

File structure:

```
.
├── configuration          <- configuration files for editing the training plan
├── documents
├── notebooks
├── projects               <- the working directory where new projects will be created
│   └── Project Name       <- set by user in corpus_config.yml
│         └── inputs
│         └── outputs
├── renv
├── src
│   └── Python
│   └── R
│   └── sql

```
