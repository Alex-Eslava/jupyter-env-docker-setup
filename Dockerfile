FROM nvidia/cuda:11.0.3-runtime-ubuntu20.04

# Install necessary packages for Python development
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install JupyterLab and set up a custom kernel
RUN pip3 install jupyterlab \
    && python3 -m ipykernel install --user --name custom-kernel

# Set the working directory
WORKDIR /local/

# Copy the requirements file to the working directory and install packages
COPY requirements.txt .
RUN pip3 install -r requirements.txt
