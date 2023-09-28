#!/bin/bash
#
# The url to the websocket is defined in the wsUrl variable in App.vue. Originally it gets the websocket 
# port from /api/config and uses that to define wsUrl. 
#
# This variable is only used in one place, and only once.
#
# Instead of having to maintain a whole fork of Owntone, or a patch, we just re-define the variable with sed.
#
# Before the variable is used, this will redefine it to be "http[s]://$url/ws" instead, discarding the orignal value. 
set -e

sed -i "/const socket = new/ i \ \ \ \ \ \ wsUrl = protocol + window.location.hostname + '/ws'" owntone-server/web-src/src/App.vue

# Show the change.
echo "Redefined wsUrl in App.vue:"
grep --color=always "wsUrl.*/ws" owntone-server/web-src/src/App.vue

