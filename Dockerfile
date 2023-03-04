# Use the nvidia/cuda:11.0.3-runtime-ubuntu20.04 image
FROM nvidia/cuda:11.0.3-runtime-ubuntu20.04

# Set working directory
WORKDIR /local

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        locales && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set locale to UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

# Install Miniconda3
RUN curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh && \
    /bin/bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    /opt/conda/bin/conda clean -afy

# Create a new conda environment with only necessary packages
ARG ENV_NAME=chocolata
RUN /opt/conda/bin/conda create -y --name $ENV_NAME \
    python=3.8 \
    ipython \
    jupyterlab \
    nb_conda_kernels \
    matplotlib \
    pandas \
    && /opt/conda/bin/conda clean -afy && \
    echo "conda activate $ENV_NAME" >> ~/.bashrc

# Add requirements.txt and install packages in the custom environment
COPY requirements.txt /tmp/requirements.txt
RUN /opt/conda/bin/conda run -n $ENV_NAME pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Expose port for JupyterLab
EXPOSE 8900

# Set command to run JupyterLab
CMD ["/opt/conda/bin/conda", "run", "-n", "$ENV_NAME", "jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--port=8900"]