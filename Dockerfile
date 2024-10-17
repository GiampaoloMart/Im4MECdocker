# Usa un'immagine base micromamba
FROM mambaorg/micromamba:ubuntu22.04

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

# Verifica l'esistenza del file environment.yml
RUN ls -l environment.yml || echo "environment.yml non trovato"

# Crea l'ambiente Conda utilizzando environment.yml
RUN micromamba env create -f environment.yml && \
    micromamba clean --all --yes

# Configura la shell per attivare l'ambiente conda
SHELL ["micromamba", "run", "-n", "base", "/bin/bash", "-c"]

# Avvia una shell interattiva
CMD ["/bin/bash"]
