FROM mambaorg/micromamba:1.4.2-bullseye

# We want all RUN commands to use Bash.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy over your environment file
COPY environment.yml /tmp/environment.yml

# Create the environment
RUN micromamba create -n hf39 -f /tmp/environment.yml --yes && \
    micromamba clean --all --yes

ARG WORKDIR=/usr/local/esoc_c_models
ENV WORKDIR=${WORKDIR}

RUN micromamba shell init -s bash -p /opt/conda

# If needed, ensure the file exists and append your activation line
RUN touch /home/mambauser/.bashrc
RUN echo 'micromamba activate hf39' >> /home/mambauser/.bashrc

USER root
RUN apt-get update -y
RUN apt install git -y
RUN apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    make \
    build-essential \
    zlib1g-dev \
    libpython3-dev \
    libssl-dev \
    libffi-dev \
    libsqlite3-dev \
    libgdal-dev

ARG CACHEBUST=1

RUN git clone https://github.com/springinnovate/ecoshard.git /usr/local/ecoshard && \
    cd /usr/local/ecoshard && \
    micromamba run -n hf39 pip install . && \
    git log -1 --format="%h on %ci" > /usr/local/ecoshard.gitversion

RUN git clone https://github.com/springinnovate/inspring.git /usr/local/inspring && \
    cd /usr/local/inspring && \
    micromamba run -n hf39 pip install . && \
    git log -1 --format="%h on %ci" > /usr/local/inspring.gitversion

# This shows the timedate of the ecoshard and inspring repos
RUN echo 'if [ -f "/usr/local/ecoshard.gitversion" ]; then' >> /home/mambauser/.bashrc && \
    echo '  echo "ecoshard: commit on $(cat /usr/local/ecoshard.gitversion)"' >> /home/mambauser/.bashrc && \
    echo 'fi' >> /home/mambauser/.bashrc && \
    echo 'if [ -f "/usr/local/inspring.gitversion" ]; then' >> /home/mambauser/.bashrc && \
    echo '  echo "inspring: commit on $(cat /usr/local/inspring.gitversion)"' >> /home/mambauser/.bashrc && \
    echo 'fi' >> /home/mambauser/.bashrc

USER mambauser
WORKDIR ${WORKDIR}
CMD ["/bin/bash"]
