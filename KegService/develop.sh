#!/bin/sh

KEG_ADMIN="test" supervisor -e 'coffee' -w './,data/,api/,' resource.coffee
