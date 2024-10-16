# Usa un'immagine base micromamba
FROM mambaorg/micromamba:1.5.8-lunar

# Installa utilità di base
#RUN apt-get update && \
#    apt-get install -y wget git bzip2 && \
#    rm -rf /var/lib/apt/lists/*

# Installa Miniconda
#ENV PATH="/opt/conda/bin:$PATH"
#RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
#    bash miniconda.sh -b -p /opt/conda && \
#    rm miniconda.sh && \
#   conda update -y conda

# Clona il repository di im4MEC da GitHub
RUN git clone https://github.com/AIRMEC/im4MEC.git /im4MEC

# Imposta la directory di lavoro
WORKDIR /im4MEC

# Copia il file environment.yml (se già presente nel repository, puoi omettere questo passaggio)
# Se environment.yml è già presente nel repository GitHub, rimuovi la riga sottostante.
# COPY environment.yml /im4MEC/environment.yml

# Crea l'ambiente Conda utilizzando il file environment.yml
RUN micromamba env create --prefix /opt/conda_env -f environment.yml && micromamba clean -a -y

# Configura la shell per attivare l'ambiente conda
SHELL ["micromamba", "run", "--prefix", "/opt/conda_env", "/bin/bash", "-c"]

# Comando di default per eseguire uno script del repository, ad esempio main.py
CMD ["python", "main.py"]
