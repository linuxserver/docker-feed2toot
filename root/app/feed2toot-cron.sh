#!/usr/bin/with-contenv bash
# shellcheck shell=bash

s6-setuidgid abc python3 /lsiopy/bin/feed2toot -l "${FEED_LIMIT:-5}" -c /config/feed2toot.ini
