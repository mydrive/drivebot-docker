
building and running locally, bump the version tag e.g.

```
docker build --rm -t mydrive/drivebot:1.3 .

docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" --name drivebot mydrive/drivebot:1.3
```

When you're happy, push to the registry

```
docker push mydrive/drivebot:1.3
```

Deploying:

Edit the tag in the terraform file, to upgrade the version in the ECS task
definition
