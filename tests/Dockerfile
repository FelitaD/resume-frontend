# multi-stage Docker build with testing node_modules and Cypress binary
# discarded before serving in production
# https://glebbahmutov.com/blog/making-small-docker-image/

# testing image - we really want to cache AS MUCH AS POSSIBLE
# so we build like this
#   - copy package files
#   - run "npm ci"
#   - copy spec files
# this way Cypress and node_modules are cached as long as package files stay same
# Docker build looks at the file checksums during each "COPY ..." command
# and if the copied files were the same, the image layer is cached and not recomputed
# https://docs.docker.com/v17.09/engine/userguide/eng-image/dockerfile_best-practices/#build-cache
# every other command like "RUN npm ci" is cached by default unless the command itself has been changed
FROM cypress/base
RUN npm install -g npm@6

# dependencies will be installed only if the package files change
COPY package.json .
COPY package-lock.json .

RUN npm install

# by setting CI environment variable we switch the Cypress install messages
# to small "started / finished" and avoid 1000s of lines of progress messages
# https://github.com/cypress-io/cypress/issues/1243
# ENV CI=1
# RUN ls -la
# RUN npm ci

# tests will rerun if the "cypress" folder, "cypress.json" file or "public" folder
# has any changes
# copy tests
COPY cypress cypress
COPY cypress.config.js .

#
# ALWAYS run e2e Cypress tests
#

# to avoid Docker thinking it is the same command and skipping tests
# have a dummy command here
# see discussion in https://github.com/moby/moby/issues/1996
# find variable that changes. For example on Zeit.co Now GitHub deploys the HOSTNAME changes
# RUN env
ARG HOSTNAME=1
# if you run "docker build . --build-arg HOSTNAME=foo"
# it will bust this cache and it will rerun all commands from here

RUN npm test
