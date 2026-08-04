#!/bin/sh

vbrew() {
  package=$1
  version=$2

  brew list --formula | grep "^${package}" | xargs -r brew unlink 2>/dev/null
  brew link --force --overwrite "${package}@${version}"
}