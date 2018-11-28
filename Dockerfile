FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  expect redis-server npm nodejs python-pip && \
  pip install awscli

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN npm install -g coffeescript
RUN npm install -g yo generator-hubot

# Create hubot user
RUN useradd -d /hubot -m -s /bin/bash -U hubot

# Log in as hubot user and change directory
USER  hubot
WORKDIR /hubot

# Install Hubot
RUN yo hubot --owner="MyDrive Systems <systems@mydrivesolutions.com>" --name="DriveBot" --description="Your plastic pal who's fun to be with" --defaults

# Some adapters / scripts
RUN npm install hubot-slack --save
RUN npm install hubot-pugme --save
RUN npm install hubot-standup-alarm --save
RUN npm install hubot-google-images --save
RUN npm install hubot-redis-brain --save
RUN npm install signalfx --save

# Activate some built-in scripts
ADD hubot/external-scripts.json /hubot/

# Add some custom scripts
ADD hubot/scripts/*.coffee /hubot/scripts/

# And go
CMD ["/bin/sh", "-c", "aws s3 cp --region eu-west-1 s3://mydrive-infrastructure/config/drivebot/env.sh .; . ./env.sh; bin/hubot --adapter slack"]
