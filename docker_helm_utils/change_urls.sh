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
  sed -i -e "s|\(<script[^>]*app\.js[^>]*\)integrity=\"sha384-[a-zA-Z0-9+/=]*\"|\1integrity=\"sha384-${NEW_HASH}\"|g" *.html
fi

# 重新计算并更新 HyperLoader.js 的 integrity 值
if [ -f "HyperLoader.js" ]; then
  LOADER_HASH=$(openssl dgst -sha384 -binary HyperLoader.js | openssl base64 -A)
  # 更新包含 HyperLoader.js 的行中的 integrity
  sed -i -e "s|\(<script[^>]*HyperLoader\.js[^>]*\)integrity=\"sha384-[a-zA-Z0-9+/=]*\"|\1integrity=\"sha384-${LOADER_HASH}\"|g" *.html
fi

echo "Build modifications completed."
exec "$@"