#!/bin/sh

KEGUMS_ENV="local" KEGUMS_ADMIN="test" supervisor -e 'coffee' -w './,data/,api/,' resource.coffee
