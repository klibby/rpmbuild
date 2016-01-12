FROM centos@sha256:bdcd8ba9549a820e9d5c43fa8b250745fe51e433b79eb1501a906960e67e2134
MAINTAINER Kendall Libby <klibby@mozilla.com>

# Add user and setup its workspace
RUN      useradd -d /home/build -u 1000 -s /bin/bash -m build
WORKDIR  /home/build

# Set variable normally configured at login, by the shells parent
# process, these are taken from GNU su manual
ENV      HOME          /home/build
ENV      SHELL         /bin/bash
ENV      USER          build
ENV      LOGNAME       build
ENV      HOSTNAME      rpmbuilder

# Install system dependencies in a single layer
ADD      system-setup.sh   /tmp/system-setup.sh
RUN      ["/tmp/system-setup.sh"]

# Set a default command useful for debugging
CMD      ["/bin/bash", "--login"]
