#!/usr/bin/env bash

# Written by Erik Bille 2019-02-07
# Script will set the computer namme to {YOUR_PREFIX}-{SERIAL_NR}-{User initials}

# If things break, we stop
set -euo pipefail

#Uppdate these variables to the relevant values in your deployment
jssUser=JSS_USER_NAME
jssPass=JSS_PASSWORD
jssHost=JSS_URL
prefix='YOUR_PREFIX'

# Get name components
serial=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
initials=$(/usr/bin/curl -H "Accept: text/xml" -sfku "${jssUser}:${jssPass}" "${jssHost}/JSSResource/computers/serialnumber/$serial/subset/location" | xmllint --format - 2>/dev/null | awk -F'>|<' '/<real_name>/{print $3}' | sed "s/[a-ö]-*[[:blank:]]*//g")

# Assembly of computer name
computerName=$prefix-$serial-$initials


# Set new ComputerName, LocalHostName, and HostName
scutil --set ComputerName "$computerName"
scutil --set LocalHostName "$computerName"
scutil --set HostName "$computerName"
