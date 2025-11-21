#!/bin/sh
echo "Starting build modifications..."
if [ -n "$envSdkUrl" ]; then
  sed -i -e "s|https://beta.hyperswitch.io/web|${envSdkUrl}/web|g" app.js HyperLoader.js
fi
if [ -n "$envBackendUrl" ]; then
  sed -i -e "s|https://beta.hyperswitch.io/api|${envBackendUrl}|g" app.js HyperLoader.js
fi
if [ -n "$envLogsUrl" ]; then
  sed -i -e "s|https://sandbox.hyperswitch.io/logs/sdk|${envLogsUrl}|g" app.js HyperLoader.js
fi

# 重新计算并更新 app.js 的 integrity 值
if [ -f "app.js" ]; then
  NEW_HASH=$(openssl dgst -sha384 -binary app.js | openssl base64 -A)
  # 只更新包含 app.js 的行中的 integrity
  sed -i -e "/app\.js/s/integrity=\"sha384-[^\"]*\"/integrity=\"sha384-${NEW_HASH}\"/g" *.html
fi

echo "Build modifications completed."
exec "$@"