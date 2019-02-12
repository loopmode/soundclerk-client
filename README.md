# create-react-app yarn workspace

This is a boilerplate project for a `create-react-app` application inside a `yarn` and `lerna` workspace.
There is a main `app` package that uses a webpack development server by means of the default CRA setup (via `react-scripts`).
Any additional packages can be transpiled and watched and they are available for import in the app.

## Local setup

-  install [Node.js](https://nodejs.org/en/download/)
-  install [yarn](https://yarnpkg.com/lang/en/docs/install/) (e.g. using `npm install --global yarn`)

Run `yarn` or `yarn install` in the project root to install the dependencies and create the package symlinks.

## Local scripts

**yarn start**

This starts both the `app` and `watch` scripts in parallel.

**yarn app**

This starts the development server for the `app` package.

**yarn watch**

This runs `yarn watch` in all packages that do have a `watch` script defined in their `package.json`.

**scripts/create-package.sh**

This creates a new package with some defaults, based on `scripts/templates/package`.
The package will automatically have a `build` script that transpiles `src/` to `lib/`, and a `watch` script that does the same but recompiles upon file change.

## Docker setup

- [install Docker](https://runnable.com/docker/getting-started/)

In this scenario, you don't need to have node/npm/yarn installed locally.
When using VS Code as editor, this is recommended as it has integrated auto-formatting and does not rely on the node_modules (eslint, prettier).

## Docker scripts

**scripts/docker-develop.sh**

This starts the development environment inside a Docker container. _Note: `yarn docker` is an alias for this script!_

**scripts/docker-start.sh**

This starts the production client using nginx inside a Docker container.

**docker-compose up**

Note that in order for `docker-compose up` to work, you must have used `scripts/docker-prepare.sh` to create the `.docker-packages` folder.
That's why it is recommended to use `scripts/docker-develop.sh` or `yarn docker` instead.
