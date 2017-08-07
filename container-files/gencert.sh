#!/usr/bin/env sh

set -e

if [ -z "$OVERWRITE" ]; then
  RUNOVERWRITE=false
else
  case $OVERWRITE in
    true|yes)
      RUNOVERWRITE=true
      ;;
    false|no)
      RUNOVERWRITE=false
      ;;
    *)
      RUNOVERWRITE=false
      ;;
  esac
fi

if [ -z "$HOST" ]; then
  RUNHOSTNAME="server.domain.tld"
else
  RUNHOSTNAME=${HOST}
fi

if [ -z "$TYPE" ]; then
  SAVEKEY=true
  SAVECERT=true
  SAVEPEM=true
else
  case $TYPE in
    crt)
      SAVEKEY=true
      SAVECERT=true
      SAVEPEM=false
      ;;
    pem)
      SAVEKEY=false
      SAVECERT=false
      SAVEPEM=true
      ;;
    all)
      SAVEKEY=true
      SAVECERT=true
      SAVEPEM=true
      ;;
    *)
      SAVEKEY=true
      SAVECERT=true
      SAVEPEM=true
      ;;
  esac
fi


if [ "$RUNOVERWRITE" = false ]; then
  if [ "$SAVEKEY" = true ] && [ -e /ssl/${RUNHOSTNAME}.key ]; then
    echo "Exiting run: /ssl/${RUNHOSTNAME}.key alrealdy exists"
    exit 0
  fi

  if [ "$SAVECERT" = true ] && [ -e /ssl/${RUNHOSTNAME}.crt ]; then
    echo "Exiting run: /ssl/${RUNHOSTNAME}.crt already exists"
    exit 0
  fi

  if [ "$SAVEPEM" = true ] && [ -e /ssl/${RUNHOSTNAME}.pem ]; then
    echo "Exiting run: /ssl/${RUNHOSTNAME}.pem already exists"
    exit 0
  fi
fi

if [ ! -d "/ssl" ]; then
  mkdir /ssl
fi

cd /tmp

/usr/bin/openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes -subj "/CN=${RUNHOSTNAME}"

if [ "$SAVEKEY" = true ]; then
  echo "Saving private key to /ssl/${RUNHOSTNAME}.key"
  cp key.pem /ssl/${RUNHOSTNAME}.key
fi

if [ "$SAVECERT" = true ]; then
  echo "Saving public certificate to /ssl/${RUNHOSTNAME}.crt"
  cp cert.pem /ssl/${RUNHOSTNAME}.crt
fi

if [ "$SAVEPEM" = true ]; then
  echo "Saving combined pem file to /ssl/${RUNHOSTNAME}.pem"
  cat key.pem cert.pem > /ssl/${RUNHOSTNAME}.pem
fi
