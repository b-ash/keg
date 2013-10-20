#!/bin/sh

supervisor -e 'coffee' -w './,data/,api/,' resource.coffee
