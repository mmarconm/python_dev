FROM ubuntu:20.04

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Generate locale C.UTF-8 for postgres and general locale data
# by Marcelo Marcon
ENV LANG C.UTF-8
ENV TZ=America/Cuiaba
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create the user odoo by Marcelo Marcon
ARG USERNAME=me
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create the user odoo by Marcelo Marcon
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -s /bin/bash -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    build-essential \
    curl \
    nodejs \
    npm

COPY ./requirements.txt /

RUN pip3 install -r /requirements.txt

COPY --chown=$USER_UID:$USER_UID ./configuration/entrypoint.sh /

# Install rtlcss (on Debian buster)
# RUN npm install -g rtlcss

EXPOSE 8000 3000 5432

ENTRYPOINT [ "/entrypoint.sh" ]

USER me

