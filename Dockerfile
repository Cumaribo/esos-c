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

RUN git clone https://github.com/springinnovate/swy_global.git ${WORKDIR}/swy_global
RUN git clone https://github.com/springinnovate/ndr_sdr_global.git ${WORKDIR}/ndr_sdr_global
RUN git clone https://github.com/springinnovate/downstream-beneficiaries.git ${WORKDIR}/downstream-beneficiaries
RUN git clone https://github.com/springinnovate/coastal_risk_reduction.git ${WORKDIR}/coastal_risk_reduction
RUN git clone https://github.com/springinnovate/people_protected_by_coastal_habitat.git ${WORKDIR}/people_protected_by_coastal_habitat
RUN git clone https://github.com/springinnovate/distance-to-hab-with-friction ${WORKDIR}/distance-to-hab-with-friction
RUN git clone https://github.com/springinnovate/pollination_sufficiency ${WORKDIR}/pollination_sufficiency

RUN git clone https://github.com/springinnovate/ecoshard.git /usr/local/ecoshard && \
    cd /usr/local/ecoshard && \
    micromamba run -n hf39 pip install .

RUN git clone https://github.com/springinnovate/inspring.git /usr/local/inspring && \
    cd /usr/local/inspring && \
    micromamba run -n hf39 pip install .

USER mambauser
WORKDIR ${WORKDIR}
CMD ["/bin/bash"]
