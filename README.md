
building and running locally, bump the version tag e.g.

```
docker build --rm -t mydrive/drivebot:1.3 .

docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
                -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
                -e "AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}" \
                -e "AWS_SECURITY_TOKEN=${AWS_SECURITY_TOKEN}" \
                -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}" \
                -e "AWS_REGION=${AWS_REGION}" \
                --name drivebot mydrive/drivebot:1.3
```

*The above script assumes that AWS MFA credentials are in your ENV and are not older than one hour, so have not expired.*

When you're happy, push to the registry

```
docker push mydrive/drivebot:1.3
```

Deploying:

Edit the tag in the terraform file, to upgrade the version in the ECS task
definition
