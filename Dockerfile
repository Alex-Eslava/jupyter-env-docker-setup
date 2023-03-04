FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl wget bzip2

# Install Miniconda
RUN curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /opt/conda -b && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/opt/conda/bin:${PATH}"

# Create and activate a new Conda environment
RUN conda create --name chocolata python=3.8 && \
    conda activate chocolata

# Install Python dependencies from requirements.txt
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Set up the kernel for JupyterLab
RUN python -m ipykernel install --user --name chocolata --display-name "chocolata"

# Expose JupyterLab port
EXPOSE 8900

# Set up the command to start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8900", "--no-browser", "--allow-root"]
