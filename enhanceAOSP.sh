#!/bin/bash

android="LOCAL_PATH := \$(call my-dir)
include \$(CLEAR_VARS)

LOCAL_MODULE := LocalModuleName
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := \$(LOCAL_MODULE).apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)

LOCAL_CERTIFICATE := PRESIGNED

include \$(BUILD_PREBUILT)"

processApp () {
  while read data
    do
      name=${data%.*}
      mkdir $name
      mv $data $name
      touch "$name/Android.mk"
      echo "$android" >> $name/Android.mk
      sed -i "s/LocalModuleName/$name/g" $name/Android.mk
  done
}

case "$1" in
   "") 
      echo "Usage: $0 -<command>"
      echo '  gapps  integrate gapps'
      echo "  root   integrate gapps+superuser"
      exit 1
      ;;
   -gapps)
      mkdir gapps
      cd gapps
      
      #Gapp files
      wget http://goo.im/gapps/gapps-jb-20121011-signed.zip
      unzip gapps-jb-20121011-signed.zip system/*
      mv system/* .
      rm -rf system
      rm -rf addon.d
      rm -rf gapps-jb-20121011-signed.zip
      ;;
   -root)
      mkdir gapps
      cd gapps
      
      #Gapp files
      wget http://goo.im/gapps/gapps-jb-20121011-signed.zip
      unzip gapps-jb-20121011-signed.zip system/*
      mv system/* .
      rm -rf system
      rm -rf addon.d
      rm -rf gapps-jb-20121011-signed.zip
      
      #Root files
      wget http://chainsdd.github.com/Superuser/download/Superuser-3.0.7-efghi-signed.zip
      unzip Superuser-3.0.7-efghi-signed.zip system/app/*
      cp -r system/* .
      rm -rf system
      rm -rf Superuser-3.0.7-efghi-signed.zip
      
      #Old su must be "disabled"
      cd ..
      sed -i "s/LOCAL_MODULE:= su/LOCAL_MODULE:= old-su/g" system/extras/su/Android.mk
      cd gapps
      ;;
   *)
      echo "Usage: $0 <command>"
      echo '  gapps  integrate gapps'
      echo "  su     integrate gapps+superuser"
      exit 1
      ;;
esac

#The apps shall be integrated
cd app
ls | processApp
