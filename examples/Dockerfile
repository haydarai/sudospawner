# example showing sudo config
# build from root with:
#    docker build -t jupyterhub-sudo -f examples/Dockerfile .
# run with:
#    docker run -it -p 8000:8000 --name jupyterhub-sudo jupyterhub-sudo
# visit http://127.0.0.1:9000 and login with username: io, password: io

FROM jupyterhub/jupyterhub:latest

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

RUN apt-get -y update \
    && apt-get -y install sudo vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# fix permissions on sudo executable (how did this get messed up?)
RUN chmod 4755 /usr/bin/sudo

RUN python3 -m pip install notebook jupyterhub-ldapauthenticator

# add the rhea user, who will run the server
# she needs to be in the shadow group in order to access the PAM service
# DONE: removed rhea's password
RUN groupadd jupyterhub
RUN useradd -m -G shadow,jupyterhub rhea

# Give rhea passwordless sudo access to run the sudospawner mediator on behalf of users:
ADD examples/sudoers /tmp/sudoers
RUN cat /tmp/sudoers >> /etc/sudoers
RUN rm /tmp/sudoers

# DONE: pull config files based on TEAM_NAME (TEAM_NAME > user config, data ingestion config) from a git repo
## To run: docker build -t jupyterhub-sudo -f examples/Dockerfile . --build-arg TEAM_NAME=SAMPLE_TEAM
# DONE: removed user passwords
# add some regular users
ARG TEAM_NAME
RUN git clone https://github.com/kuriakinzeng/ai-training-configs.git /tmp/ai-training-configs
RUN while IFS= read -r name; do useradd -m -G jupyterhub $name; done < /tmp/ai-training-configs/$TEAM_NAME/users
RUN rm -rf /tmp/ai-training-configs

# make home directories private
RUN chmod o-rwx /home/*

ADD . /srv/sudospawn
WORKDIR /srv/sudospawn
RUN python3 -m pip install .

# make the working dir owned by rhea, so she can create the state database
RUN chown rhea .
RUN chmod +x get_all_ports.sh

# TODO: when docker exec as any user, i shouldn't reach /srv/sudospawn. i should reach /home/<user>
USER rhea
ADD examples/jupyterhub_config.py ./jupyterhub_config.py

# TODO: create a jenkins script that specifies TEAM_NAME during deployment