# Usa un'immagine base micromamba
FROM mambaorg/micromamba::ubuntu22.04

# Installa Git dal canale conda-forge
RUN micromamba install -c conda-forge git -y

# Clona il repository di im4MEC da GitHub
RUN git clone https://github.com/AIRMEC/im4MEC.git /im4MEC

# Imposta la directory di lavoro
WORKDIR /im4MEC

# Crea l'ambiente Conda utilizzando environment.yml
RUN micromamba env create --prefix /opt/conda_env -f environment.yml && micromamba clean -a -y

# Configura la shell per attivare l'ambiente conda
SHELL ["micromamba", "run", "--prefix", "/opt/conda_env", "/bin/bash", "-c"]

# Avvia una shell interattiva
CMD ["/bin/bash"]

