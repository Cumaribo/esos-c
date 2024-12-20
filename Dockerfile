# Container ESOS-C model runs
FROM ubuntu:jammy

RUN apt-get update -qq && \
    apt-get install -y \
    emacs \
    libspatialindex-dev \
    python3-pip \
    postgresql-client \
    openssl \
    curl \
    git \
    gdal-bin \
    python3-gdal

ARG WORKDIR=/usr/local/esoc_c_models
ENV WORKDIR=${WORKDIR}

RUN git clone https://github.com/springinnovate/swy_global.git ${WORKDIR}/swy_global
RUN git clone https://github.com/springinnovate/ndr_sdr_global.git ${WORKDIR}/ndr_sdr_global
RUN git clone https://github.com/springinnovate/downstream-beneficiaries.git ${WORKDIR}/downstream-beneficiaries
RUN git clone https://github.com/springinnovate/coastal_risk_reduction.git ${WORKDIR}/coastal_risk_reduction
RUN git clone https://github.com/springinnovate/people_protected_by_coastal_habitat.git ${WORKDIR}/people_protected_by_coastal_habitat
RUN git clone https://github.com/springinnovate/distance-to-hab-with-friction ${WORKDIR}/distance-to-hab-with-friction
RUN git clone https://github.com/springinnovate/pollination_sufficiency ${WORKDIR}/pollination_sufficiency

RUN pip3 install cython

RUN git clone https://github.com/springinnovate/ecoshard.git /usr/local/ecoshard && \
    cd /usr/local/ecoshard && \
    pip3 install .

RUN git clone https://github.com/springinnovate/inspring.git /usr/local/inspring && \
    cd /usr/local/inspring && \
    pip3 install .

RUN pip3 install \
    geopandas \
    shapely \
    pyproj \
    psutil \
    scipy \
    requests \
    numexpr

# Create the data directory
RUN mkdir -p ${WORKDIR}/data

WORKDIR ${WORKDIR}
CMD ["bash"]
