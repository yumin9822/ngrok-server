#!/bin/bash
set -e

if [ "${CA_CERT}" == "**None**" ]; then
    echo "Please specify CA_CERT"
    exit 1
fi

echo -e "${CA_CERT}" > /ngrok/assets/client/tls/ngrokroot.crt

echo "=> Compiling ngrok binary files"
cd /ngrok
GOOS=linux GOARCH=386 make release-server release-client
GOOS=darwin GOARCH=386 make release-server release-client
GOOS=freebsd GOARCH=386 make release-server release-client
GOOS=windows GOARCH=386 make release-server release-client
GOOS=linux GOARCH=amd64 make release-server release-client
GOOS=darwin GOARCH=amd64 make release-server release-client
GOOS=freebsd GOARCH=amd64 make release-server release-client
GOOS=windows GOARCH=amd64 make release-server release-client
GOOS=linux GOARCH=arm make release-server release-client
echo "=> Successfully built all platform binaries"
