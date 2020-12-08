# our local base image
FROM ubuntu:latest

# labels
LABEL DESCRIPTION="Container to run the CI/CD pipelines"
LABEL MAINTAINERS="Jens Klimke <jens.klimke@rwth-aachen.de>"

# set arguments
ARG asciidoctor_version=2.0.12
ARG asciidoctor_confluence_version=0.0.2
ARG asciidoctor_pdf_version=1.5.3
ARG asciidoctor_diagram_version=2.0.5
ARG asciidoctor_epub3_version=1.5.0.alpha.19
ARG asciidoctor_mathematical_version=0.3.5
ARG asciidoctor_revealjs_version=4.0.1
ARG kramdown_asciidoc_version=1.0.1
ARG asciidoctor_bibtex_version=0.8.0

# set environment variables
ENV TZ=Europe/Berlin
ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
    ASCIIDOCTOR_CONFLUENCE_VERSION=${asciidoctor_confluence_version} \
    ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version} \
    ASCIIDOCTOR_DIAGRAM_VERSION=${asciidoctor_diagram_version} \
    ASCIIDOCTOR_EPUB3_VERSION=${asciidoctor_epub3_version} \
    ASCIIDOCTOR_MATHEMATICAL_VERSION=${asciidoctor_mathematical_version} \
    ASCIIDOCTOR_REVEALJS_VERSION=${asciidoctor_revealjs_version} \
    KRAMDOWN_ASCIIDOC_VERSION=${kramdown_asciidoc_version} \
    ASCIIDOCTOR_BIBTEX_VERSION=${asciidoctor_bibtex_version}

# set time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install packages
RUN apt-get update
RUN apt-get install -y g++ make cmake
RUN apt-get install -y wget gdebi
RUN apt-get install -y curl bats
RUN apt-get install -y python3 python3-pip
RUN apt-get install -y ruby ruby-dev
RUN apt-get install -y nodejs npm
RUN apt-get install -y default-jre

# install asciidoctor packages
RUN apt-get install -y bison flex libffi-dev libxml2-dev libgdk-pixbuf2.0-dev libcairo2-dev libpango1.0-dev fonts-lyx
RUN gem install --no-document \
    "asciidoctor:${ASCIIDOCTOR_VERSION}" \
    "asciidoctor-confluence:${ASCIIDOCTOR_CONFLUENCE_VERSION}" \
    "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
    "asciidoctor-epub3:${ASCIIDOCTOR_EPUB3_VERSION}" \
    "asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}" \
    "asciidoctor-revealjs:${ASCIIDOCTOR_REVEALJS_VERSION}" \
    "kramdown-asciidoc:${KRAMDOWN_ASCIIDOC_VERSION}" \
    "asciidoctor-bibtex:${ASCIIDOCTOR_BIBTEX_VERSION}" \
    "asciidoctor-mathematical:${ASCIIDOCTOR_MATHEMATICAL_VERSION}" \
    asciimath

# install python packages
RUN pip3 install requests pytest textract

# install prince
RUN cd /tmp && wget https://www.princexml.com/download/prince_13.5-1_ubuntu20.04_amd64.deb
RUN cd /tmp && gdebi -n prince_13.5-1_ubuntu20.04_amd64.deb

# install fonts
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer
RUN fc-cache

# start bash
CMD bash
