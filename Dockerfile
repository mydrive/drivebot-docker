FROM ubuntu:16.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  expect redis-server npm nodejs python-pip && \
  pip install awscli

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g coffee-script
RUN npm install -g yo@1.8.5 generator-hubot

# Create hubot user
RUN useradd -d /hubot -m -s /bin/bash -U hubot

# Log in as hubot user and change directory
USER  hubot
WORKDIR /hubot

# Install hubot
RUN yo hubot --owner="MyDrive Systems <systems@mydrivesolutions.com>" --name="DriveBot" --description="Your plastic pal who's fun to be with" --defaults

# Some adapters / scripts
RUN npm install hubot-slack --save && npm install
RUN npm install hubot-pugme --save && npm install
RUN npm install hubot-standup-alarm --save && npm install
RUN npm install hubot-google-images --save && npm install
RUN npm install hubot-redis-brain --save && npm install
# RUN npm install hubot-auth --save && npm install
# RUN npm install hubot-google-translate --save && npm install
# RUN npm install hubot-auth --save && npm install
# RUN npm install hubot-github --save && npm install
# RUN npm install hubot-alias --save && npm install
# RUN npm install hubot-gocd --save && npm install
# RUN npm install hubot-youtube --save && npm install
# RUN npm install hubot-s3-brain --save && npm install

# Activate some built-in scripts
ADD hubot/hubot-scripts.json /hubot/
ADD hubot/external-scripts.json /hubot/

# Add some custom scripts
ADD hubot/scripts/*.coffee /hubot/scripts/

# And go
CMD ["/bin/sh", "-c", "aws s3 cp --region eu-west-1 s3://mydrive-infrastructure/config/drivebot/env.sh .; . ./env.sh; bin/hubot --adapter slack"]
