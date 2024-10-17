# Usa un'immagine base micromamba
FROM mambaorg/micromamba:ubuntu24.04

# Aggiungi il percorso di micromamba alla variabile PATH
ENV PATH /opt/conda/bin:$PATH

# Passa temporaneamente all'utente root
USER root

# Installa Git dal canale conda-forge
RUN micromamba install -c conda-forge git --yes

# Clona il repository di im4MEC da GitHub come root
RUN git clone https://github.com/AIRMEC/im4MEC.git /im4MEC

# Cambia i permessi della cartella
RUN chown -R $MAMBA_USER:$MAMBA_USER /im4MEC

# Torna all'utente non-root
USER $MAMBA_USER

# Imposta la directory di lavoro
WORKDIR /im4MEC

# Crea l'ambiente Conda utilizzando environment.yml
RUN micromamba env create -f environment.yml && \
    micromamba clean --all --yes

# Nome dell'ambiente (assumi che sia 'im4mec')
ENV ENV_NAME=im4mec

# Attiva l'ambiente
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# Configura la shell per attivare l'ambiente conda
SHELL ["micromamba", "run", "-n", "$ENV_NAME", "/bin/bash", "-c"]

# Imposta l'attivazione dell'ambiente per quando il container viene eseguito
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh", "micromamba", "run", "-n", "$ENV_NAME", "--"]

# Avvia una shell interattiva
CMD ["/bin/bash"]
