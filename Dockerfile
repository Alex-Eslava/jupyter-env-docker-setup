# Use the nvidia/cuda:11.0.3-runtime-ubuntu20.04 image
FROM nvidia/cuda:11.0.3-runtime-ubuntu20.04

# Install Miniconda
ARG MINICONDA_VERSION=py38_4.10.3
RUN apt-get update && apt-get install -y curl && \
    curl -LO "https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" && \
    bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -b -p /opt/conda && \
    rm -f Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Create a new conda environment and activate it
ARG ENV_NAME=custom_env
RUN /opt/conda/bin/conda create -y --name $ENV_NAME python=3.8 && \
    echo "conda activate $ENV_NAME" >> ~/.bashrc

# Install JupyterLab and create a new custom kernel
RUN /opt/conda/bin/conda install -y jupyterlab ipykernel && \
    /opt/conda/bin/python -m ipykernel install --user --name $ENV_NAME --display-name "Chocolata"

# Install packages in the custom kernel from requirements.txt
COPY requirements.txt /tmp/requirements.txt
RUN /opt/conda/bin/conda run -n $ENV_NAME pip install -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt


WORKDIR /local

# Expose port 8900 for JupyterLab
EXPOSE 8900

# Start JupyterLab
CMD ["/opt/conda/bin/jupyter", "lab", "--ip=0.0.0.0", "--port=8900", "--no-browser"]
