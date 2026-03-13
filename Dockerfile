# Fetch base image
FROM debian:11-slim

RUN \
  apt-get update && \
  apt-get install -y \
  # ruby dependencies
    ruby \
    ruby-dev \
  # gem dependencies
    libglib2.0-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libgirepository1.0-dev \
    libgdk-pixbuf2.0-dev \
    libgtk-3-dev \
    libcanberra-gtk-module \
    libxml2-utils \
  # docker dependencies
    tini \
  # runtime dependencies
    openssh-client \
    dbus-x11 \
  # debug dependencies
    procps \
  && \
  rm -rf /var/lib/apt/lists/* && \
  find /var/log/ -type f -delete

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN \
  if [ -f /etc/dpkg/dpkg.cfg.d/docker ]; then \
    # if this file exists, we're likely in "debian:xxx-slim", and locales are thus being excluded so we need to remove that exclusion (since we need locales)
    grep -q '/usr/share/locale' /etc/dpkg/dpkg.cfg.d/docker; \
    sed -ri '/\/usr\/share\/locale/d' /etc/dpkg/dpkg.cfg.d/docker; \
    ! grep -q '/usr/share/locale' /etc/dpkg/dpkg.cfg.d/docker; \
  fi; \
  apt-get update && apt-get install -y locales && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
  rm -rf /var/lib/apt/lists/* && \
  find /var/log/ -type f -delete

RUN echo 'fr_FR.UTF-8 UTF-8' >> /etc/locale.gen && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

ENV SSH_TUNNEL_VERSION=1.0.0

# Install ssh-tunnel
COPY ssh-tunnel-${SSH_TUNNEL_VERSION}.gem /tmp/
RUN gem install /tmp/ssh-tunnel-${SSH_TUNNEL_VERSION}.gem && rm -f /tmp/ssh-tunnel-${SSH_TUNNEL_VERSION}.gem

ENTRYPOINT ["tini", "-w", "--", "ssh-tunnel"]
