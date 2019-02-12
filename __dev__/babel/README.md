# \_\_dev\_\_/babel

This is the babel configuration for workspace packages other than `app`.

Note that the client app itself is **not** using this config, as it is a `create-react-app` project that manages its own babel config.

This config is for all the other packages and their `watch` scripts.

Use it in the `package.json` of any workspace package:

```
  ...
  "babel": {
    "extends": "@soundclerk/babel"
  },
  ...
```
