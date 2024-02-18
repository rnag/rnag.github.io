---
excerpt: "Learn how to obviate the need to rebuild a Docker image every time an local file in the host's current directory changes, with the power of Bind mounts!"
title: "How to Mount Current Working Directory To Your Docker Container"
date: "2024-02-09 11:12:54 -0500"
categories:
  - tech-tips
tags:
  - docker
  - mac
  - linux
  - expressjs
  - nodejs
dev_to:
  id: 1756904
  tags:  # up to 4, compatible with https://dev.to/tags
  - docker
  - mac
  - express
  - node
---

{% include tech-tips-head-notice.html %}

My team has been building out a new web app in _Express.js_, and for local deployment and testing we use `nodemon`, `babel`, and Docker.

One of the burning questions we wanted to find an answer to - apart from the ultimate question of all life, the universe, and everything - is how can we mount our local (current) directory to the running Docker container, so that `nodemon` can listen for local file changes when we develop, and automatically reload or restart the (containerized) web server as needed.

Towards that end, I hastily Googled online for "Can Docker mount local drive and listen for file changes", and even kicked this same prompt to my work-approved AI assistant (\*wink\* ChatGPT alternative?). Anyway, the responses from the AI prompt are recorded separately below.

By the way, this article is inspired by some other articles on that I found on the web while researching if such a thing is possible - e.g. mounting a local folder to a Docker container - including the following article on Medium, which does a good job of condensing the main points:

> [**How To Mount Your Current Working Directory To Your Docker Container In Windows**](https://medium.com/@kale.miller96/how-to-mount-your-current-working-directory-to-your-docker-container-in-windows-74e47fa104d7)

As I and my team are developing on an (Apple Silicon-based) Mac, we don't care too much about the `docker run` command being compatible between Mac and Windows overmuch.

However, I certainly agree that Docker is super handy for anyone wanting to write software in a Linux environment while still running a Mac (or Windows) computer.

## Theory

Our `Dockerfile` - we use the same one for development and production - looks something like this:

```bash
# Start from the Node.js image for AMD64 architecture
FROM --platform=linux/amd64 node:latest

# Set the working directory for your Node.js app
WORKDIR /usr/app

ARG PORT
ARG NODE_ENV

ENV PORT=$PORT
ENV NODE_ENV=$NODE_ENV

# Some installation steps
...

# Copy your Node.js application files and the startup script
COPY . .
COPY start.sh .

# Make the startup script executable
RUN chmod +x ./start.sh

# Install Node.js dependencies
RUN npm install --include=dev

# Expose the port your app runs on
EXPOSE $PORT
EXPOSE 80

# Command to run the startup script
CMD ["./start.sh"]
```

We have a custom `start.sh` script we use to start our web server. This basically calls `npm run start &` within it - e.g. our **npm** script `start`.

The above `Dockerfile` basically expects arguments to be passed in during the Docker `build` step.

This allows us to pass in environment variables (and Bash script values) such as the `PORT` for the web server, and `NODE_ENV` for the web app - such as `dev` or `production` .

```bash
docker build \
  --build-arg PORT=${PORT} \
  --build-arg NODE_ENV=${NODE_ENV} \
  --tag ${TAG} \
  .
```

To the question of mounting a local folder to a Docker container, obviously we only want to enable this behavior when running in development mode.

That is, we only want to mount a local directory to the container into the location at `/usr/app` - the `WORKDIR` from the Docker instructions above - when we are in development mode, and we _don't_ want to mount anything when we are building a production Docker image, to later ship to [Amazon ECR](https://www.freecodecamp.org/news/build-and-push-docker-images-to-aws-ecr/) for example.

This is a great use case for the potential solution, which will be discussed below. Now that we have the theory in place of what we want to achieve:

- We would rather not update `Dockerfile` to mount a volume or a local folder.

- Not necessary (or desirable) to mount local folder to a volume when running `docker build` to create an image from a `Dockerfile` . This is because need to create separate `docker build` commands for development and non-development, which is harder to management.

- Ideal solution will be to update only `docker run` command. Which we only run locally anyway. We do not need to execute `docker run` for production, as generally for production we just push the final image directly to ECR via a shell command.

## Goal

Now that theory is knocked out of the way, we understand that we prefer to update `docker run` command syntax, rather than touch `docker build` or `Dockerfile` itself.

Also, it is important here to go over the problem statement once more.

The goal that we are trying to solve is **how to obviate the need to rebuild the Docker image every time an HTML, JS, EJS, CSS, or similar file in the current local directory changes.**

The host's current directory is the same that we are copying over to `/usr/app` on the Docker container, as specified in the above `Dockerfile` .

This can be a simple change because of renaming your project, or changing any of the code for the project itself. This is not ideal.

There is a way to mount a local folder as a volume on a Docker container. This will solve it for us, when we are running `nodemon` on the Docker container to listen for file changes on the `/usr/app` location on the container side. We can instead trick Docker to listen for local file changes instead - let us see how this is possible.

## Online Results

When searching online for the prompt "Can Docker mount local drive and listen for file changes" - as this would be incredibly helpful for local development - I found the below articles to be helpful.

Also, note that the first result is from the official Docker documentation itself. This was helpful for me to determine if Docker can mount local drive and listen for file changes.

- [https://docs.docker.com/storage/bind-mounts/](https://docs.docker.com/storage/bind-mounts/)

- [https://medium.com/@kale.miller96/how-to-mount-your-current-working-directory-to-your-docker-container-in-windows-74e47fa104d7](https://medium.com/@kale.miller96/how-to-mount-your-current-working-directory-to-your-docker-container-in-windows-74e47fa104d7)

- [https://stackoverflow.com/q/23439126/10237506](https://stackoverflow.com/q/23439126/10237506)

In short, this appears to be a question of `--volume` vs. `-- mount` with a `type:bind`. The [Docker docs](https://docs.docker.com/storage/bind-mounts/#differences-between--v-and---mount-behavior) (_see first link above)_ mention that using `--volume` is the old style, and there is one important difference in behavior. Hence, using `--mount` explicitly going forward seems to be the safer (and more future-proof) approach.

However, note that either approach (`--volume` or `--mount`) should work for our use case.

## Ask an AI Assistant

When I kicked the same prompt (more or less) to an AI assistant, this is what it replied with - rest of its response truncated for abbreviation sake.

---

Yes, Docker mount local drive to listen for file changes should certainly be possible.

### Mounting a Host Directory in a Docker Container:

- You can use the `-v` flag with the `docker run` command to mount a local directory into a container. For example:

```bash
docker run -v /path/to/host/directory:/path/in/container my_image
```

- Replace `/path/to/host/directory` with the actual path to your local directory and `/path/in/container` with the desired path inside the container.

- This approach ensures that any updates made in the host directory are reflected within the container.

---

Wow, that wasn't too bad. It got us more than halfway there. Honestly, if we want to use the legacy `--volume` option, we can just go with the AI suggestion. But to future-proof it, we can make a small tweak and use `--mount` instead, as we'll see below.

## The Trick

I've found the best, future-proof method is to use the `--mount type=bind` flag when running the `docker run` command. With this command, you can attach the local directory to your docker container at runtime instead of during the build process.

The `--mount type=bind` command takes a single parameter formatted like so:

> _`src=<host directory>,dst=<target directory>`_

If we want to _**exclude**_ any sub-folders in our `<host directory>` when mounting the local folder to the Docker container, we need to pass `--mount type=volume` with the full path to that sub-folder, and exclude the `src` argument, as follows:

> _`dst=<host directory to not mount>`_

## Example

It's easier to understand the trick when put into practice.

Putting it all together, here I've created a scenario where I would like to:

- Mount my current working directory (`/Users/rnag/Git-Projects/Work/my_project`) into the `alpine:latest` image at the `/usr/app` location in the container.

- Make the `run` command compatible for Apple-silicon-based Mac's, with `--platform linux/amd64` .

- Exclude (skip) copying over the `node_modules` sub-folder in my current working directory, when mounting my current working directory `.` to the `/usr/app` location in the container.

We would do that as so:

> _`docker run -it --platform linux/amd64 --mount type=bind,src=.,dst=/usr/app --mount type=volume,dst=/usr/app/node_modules alpine:latest`_

Or, prettified a bit more, for all you neat freaks (like me):

```bash
docker run \
  -it \
  --platform linux/amd64 \
  --mount type=bind,src=.,dst=/usr/app \
  --mount type=volume,dst=/usr/app/node_modules \
  alpine:latest
```

This should start up your container and attach your working directory. Now any changes you make locally (i.e. in your Mac or Windows machine) will be reflected in your Docker container!

In short, this will solve it for us, when we are running `nodemon` or similar on the Docker container to listen for file changes on the `/usr/app` location on the container side. We have successfully tricked Docker to listen for local file changes instead - what a win!
