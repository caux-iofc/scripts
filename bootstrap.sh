#!/bin/bash

echo "Testing connectivity..."

ONLINE=0
ping -c1 8.8.8.8 >/dev/null 2>&1
if [[ "$?" == "0" ]]; then
  let ONLINE=1
fi

if [[ "$ONLINE" == "0" ]]; then
  echo "Not online, setting up wifi..."

  NETWORK=`networksetup -getairportnetwork en1`

  if [[ "$NETWORK" =~ "You are not associated" ]]; then
    echo "Switching on wifi"
    sudo networksetup -createlocation IOFC
    sudo networksetup -switchtolocation IOFC
    sudo networksetup -createnetworkservice wifi en1
    sudo networksetup -setairportpower en1 on
    # Just in case it's already there
    sudo networksetup -removepreferredwirelessnetwork en1 IOFC-Secure
    sudo networksetup -addpreferredwirelessnetworkatindex en1 IOFC 0 OPEN
  else
    echo "You appear to be associated to a WIFI access point already"
    echo $NETWORK
  fi

  echo "Checking connectivity, please wait..."

  while [ $ONLINE -lt 1 ]; do
    ping -c1 8.8.8.8 >/dev/null 2>&1
    if [[ "$?" == "0" ]]; then
      let ONLINE=1
    fi
    sleep 1
  done

fi
echo "Success, you are online"

echo "Downloading the mac-install-internal script..."
curl -s -o /tmp/mac-install-internal 'https://raw.githubusercontent.com/caux-iofc/scripts/master/mac-install-internal' || die "Couldn't download mac-install-internal"
chmod a+x /tmp/mac-install-internal
sudo bash /tmp/mac-install-internal


