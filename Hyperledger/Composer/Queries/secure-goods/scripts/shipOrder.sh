#!/bin/bash

# Usage message
usage() {
  echo "Usage: $0 -o ORDER_ID [-ah]"
  echo "Where:"
  echo "-a ID_CARD  : the ID card to use for authentication (default: sell001@secure-goods)"
  echo "-o ORDER_ID : the Order ID to ship (REQUIRED)"
  echo "-h          : this message"
  echo ""
  echo "Example: $0 -a sell002@secure-goods -o ORD0000102"
}

# defaults
auth=ship001@secure-goods
#orderId=ORD0000100

# read the options
 
while getopts "a:o:h" opt; do
  case $opt in
    a)
      auth=$OPTARG
      ;;
    o)
      orderId=$OPTARG
      ;;
    h)
      usage
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done

# Dump out the options
echo "auth: $auth" >&2
echo "OrderId: $orderId" >&2

# Default: optimism
greenLight=YES

# Complain, then exit, if no order ID is specified
if [ -z $orderId ]; then
  echo "No Order ID specified, cannot continue!" >&2
  greenLight=NO
fi

# Do we have a green light?
if [ $greenLight = 'NO' ]; then
  # We do not
  echo "" >&2
  usage
  exit 1
fi

composer transaction submit --card ${auth} -d '{
"$class": "com.makotogo.learn.composer.securegoods.asset.ShipOrder",
"order": "resource:com.makotogo.learn.composer.securegoods.asset.Order#'${orderId}'"
}'