#!/bin/bash

NETWORK=`networksetup -getairportnetwork en1`

if [[ "$NETWORK" =~ "You are not associated" ]]; then
  echo "Switching on wifi"
  sudo networksetup -createlocation IOFC
  sudo networksetup -switchtolocation IOFC
  sudo networksetup -createnetworkservice wifi en1
  sudo networksetup -setairportpower en1 on
  sudo networksetup -addpreferredwirelessnetworkatindex en1 IOFC 0 OPEN
else
  echo "You appear to be associated to a WIFI access point already"
  echo $NETWORK
fi


echo "Checking connectivity, please wait..."

ONLINE=0
while [ $ONLINE -lt 1 ]; do
  ping -c1 8.8.8.8 >/dev/null 2>&1
  if [[ "$?" == "0" ]]; then
    let ONLINE=1
  fi
  sleep 1
done

echo "Success, you are online"

echo "Downloading the mac-install-internal script..."
curl -s -o /tmp/mac-install-internal 'https://raw.githubusercontent.com/caux-iofc/scripts/master/mac-install-internal' || die "Couldn't download mac-install-internal"
chmod a+x /tmp/mac-install-internal
sudo bash /tmp/mac-install-internal


