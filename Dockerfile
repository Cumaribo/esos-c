# Container for STAC API manager
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

ENV WORKDIR=${WORKDIR}

RUN git clone https://github.com/springinnovate/swy_global.git ${WORKDIR}/swy_global
RUN git clone https://github.com/springinnovate/ndr_sdr_global.git ${WORKDIR}/ndr_sdr_global
RUN git clone https://github.com/springinnovate/downstream-beneficiaries.git ${WORKDIR}/downstream-beneficiaries
RUN git clone https://github.com/springinnovate/coastal_risk_reduction.git ${WORKDIR}/coastal_risk_reduction
RUN git clone https://github.com/springinnovate/people_protected_by_coastal_habitat.git ${WORKDIR}/people_protected_by_coastal_habitat
RUN git clone https://github.com/springinnovate/distance-to-hab-with-friction ${WORKDIR}/distance-to-hab-with-friction
RUN git clone https://github.com/springinnovate/pollination_sufficiency ${WORKDIR}/pollination_sufficiency

RUN pip3 install \
    geopandas==0.13.2 \
    pandas==2.0.3 \
    shapely==2.0.1 \
    pyproj==3.6.0 \
    cython \
    psutil \
    numexpr

RUN git clone https://github.com/springinnovate/ecoshard.git /usr/local/ecoshard && \
    cd /usr/local/ecoshard && \
    pip3 install .

# Create the data directory
RUN mkdir -p ${WORKDIR}/data

WORKDIR ${WORKDIR}
CMD ["bash"]
