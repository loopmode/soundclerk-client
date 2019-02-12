# \_\_dev\_\_/vendors

This package contains dev dependencies that are used across the workspace, like `lerna` and `prettier`, and it duplicates a couple of dependencies from `react-scripts` so that they are installed in the top-level `node_modules` folder. That way, eslint and prettier work correctly when invoked from e.g. the IDE or editor like Sublime Text with SublimeLinter.
