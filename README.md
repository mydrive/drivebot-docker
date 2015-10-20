
building and running locally, bump the version tag e.g.

```
docker build --rm -t mydrive/drivebot:1.3 .

docker run --rm -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" --name drivebot mydrive/drivebot:1.3
```

When you're happy, push to docker hub

```
docker push mydrive/drivebot:1.3
```
