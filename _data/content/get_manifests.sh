#!/usr/bin/env bash

content_dir="${0%/*}"
cd $content_dir

echo "Updating manifest files..."

get_manifests () {

  myfile="$1.yaml"
  if [ ! -s "$myfile" ]; then
    wget -q "https://git.door43.org/$2/$1/raw/master/manifest.yaml" -O "$myfile"
  fi

  if [ `find . -mtime +1 -name "$myfile" | wc -l` -gt 1 ]; then
    wget -q "https://git.door43.org/$2/$1/raw/master/manifest.yaml" -O "$myfile"
  fi

  sed -i "s/conformsto/url: 'https:\/\/git.door43.org\/$2\/$1'\n  conformsto/" "$myfile"

  if [ ! -s "$myfile" ]; then
    rm "$myfile"
    echo "Could not retrieve manifest for $1"
  fi
}

get_manifests en_ust Door43-Catalog
get_manifests en_ult Door43-Catalog
get_manifests en_ulb Door43-Catalog
get_manifests en_ueb unfoldingWord
get_manifests en_udb Door43-Catalog
get_manifests en_tn Door43-Catalog
get_manifests en_tw Door43-Catalog
get_manifests en_tq Door43-Catalog
get_manifests en_ta Door43-Catalog
get_manifests ugnt unfoldingWord
get_manifests en_ugl unfoldingWord
get_manifests en_ugg unfoldingWord
get_manifests en_ugc unfoldingWord
get_manifests uhb unfoldingWord
get_manifests en_uhal unfoldingWord
get_manifests en_uhg unfoldingWord
get_manifests en_uag unfoldingWord
get_manifests en_ubn unfoldingWord
get_manifests en_ubc unfoldingWord
get_manifests en_ubm unfoldingWord
get_manifests en_obs unfoldingWord
get_manifests en_obs-tn unfoldingWord
get_manifests en_obs-tq unfoldingWord
