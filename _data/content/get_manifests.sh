#!/usr/bin/env bash

content_dir="${0%/*}"
cd $content_dir

echo "Updating manifest files..."

get_manifests () {

  myfile="$1.yaml"
  if [ ! -s "$myfile" ]; then
    wget -q https://git.door43.org/Door43/$1/raw/master/manifest.yaml -O "$myfile"
  fi

  if [ `find . -mtime +1 -name "$myfile" | wc -l` -gt 1 ]; then
    wget -q https://git.door43.org/Door43/$1/raw/master/manifest.yaml -O "$myfile"
  fi

  sed -i "s/conformsto/url: 'https:\/\/git.door43.org\/Door43\/$1'\n  conformsto/" "$myfile"

  if [ ! -s "$myfile" ]; then
    rm "$myfile"
    echo "Could not retrieve manifest for $1"
  fi
}

get_manifests en_ulb
get_manifests en_udb
get_manifests en_tn
get_manifests en_tw
get_manifests en_tq
get_manifests en_ta
get_manifests ugnt
get_manifests en_ugl
get_manifests en_ugg
get_manifests en_ugc
get_manifests uhb
get_manifests en_uhal
get_manifests en_uhg
get_manifests en_uag
get_manifests en_ubn
get_manifests en_ubc
get_manifests en_ubm
get_manifests en_obs
get_manifests en_obs-tn
get_manifests en_obs-tq
