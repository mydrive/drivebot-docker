# MyDrive's Hubot

## Building and running locally

### Prerequisites

When running locally, i.e. not on an EC2 instance, the container requires you
pass in AWS MFA credentials. The method described here requires the credentials
to be in your ENV and not to be older than one hour, otherwise they would have
expired. The credentials are only required on starting the container.

One method to get the credentials into your ENV is to use the MyDrive AWS MFA
script: https://github.com/mydrive/mydrive-aws-mfa#quiet

### Steps

1. Build the docker image and tag it, bumping the version tag:

```
docker build -t drivebot:<tag-version> .
```

2. Build the docker image tagged as latest:

```
docker build -t drivebot .
```

3. Run the docker container, passing in the AWS credentials:

```
docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
                -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
                -e "AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}" \
                -e "AWS_SECURITY_TOKEN=${AWS_SESSION_TOKEN}" \
                -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
                -e "AWS_REGION=${AWS_REGION}" \
                --name drivebot drivebot
```

4. When you're happy, push the image to the ECR repository.


## Deploying

Edit the tag in the terraform file, to upgrade the version in the ECS task
definition.
