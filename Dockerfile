# Use the nvidia/cuda:11.0.3-runtime-ubuntu20.04 image
FROM nvidia/cuda:11.0.3-runtime-ubuntu20.04

# Install JupyterLab and minimal packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        jupyter-core \
        jupyter-client \
        jupyterlab \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install custom kernel
RUN python3 -m pip install ipykernel
RUN python3 -m ipykernel install --name custom-kernel

# Install requirements.txt 
COPY requirements.txt /tmp/requirements.txt
RUN /usr/local/bin/python -m pip install --no-cache-dir -r /tmp/requirements.txt -q --no-deps --target=/usr/local/lib/python3.8/site-packages/ ipykernel

# Set working directory
WORKDIR /local
