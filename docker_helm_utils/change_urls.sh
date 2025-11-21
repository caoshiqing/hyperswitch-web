#!/bin/sh
echo "Starting build modifications..."
if [ -n "$envSdkUrl" ]; then
  # Replace URLs with version path: /web/0.127.0/v1 -> /web/v1
  # Match pattern: https://beta.hyperswitch.io/web/VERSION/v1 where VERSION is any version string
  # This removes the version number from the path since files are actually at /web/v1/
  sed -i -e "s|https://beta\.hyperswitch\.io/web/[^/]*/v1|${envSdkUrl}/web/v1|g" app.js HyperLoader.js
  # Fallback: replace URLs without version number or different patterns
  sed -i -e "s|https://beta\.hyperswitch\.io/web|${envSdkUrl}/web|g" app.js HyperLoader.js
fi
if [ -n "$envBackendUrl" ]; then
  sed -i -e "s|https://beta.hyperswitch.io/api|${envBackendUrl}|g" app.js HyperLoader.js
fi
if [ -n "$envLogsUrl" ]; then
  sed -i -e "s|https://sandbox.hyperswitch.io/logs/sdk|${envLogsUrl}|g" app.js HyperLoader.js
fi
echo "Build modifications completed."
exec "$@"
