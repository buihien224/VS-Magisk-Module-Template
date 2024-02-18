initial_dir=$(pwd)

base() {

    if [[ $1 == "c" ]] ; then
      link=$(ls)
    else
      link=$(cat debloat.txt)
    fi
    
    for file in $link; do
      for dir in system system_ext product vendor odm mi_ext; do
        result=$(find /$dir -type f -name $file)
        if [[ $result ]] ; then
         echo "- $title $file : $result"
         if [[ $dir == "system" ]] ; then 
           dest="$MODPATH$(dirname $result)"
         else 
           dest="$MODPATH/system$(dirname $result)"
         fi
         [[ ! -d $dest ]] && mkdir -p $dest
         if [[ $1 == "c" ]] ; then
           cp $file $dest
         else
           touch $dest/$file
         fi
         break
        fi
      done
    done
    
    
}

copym() {
   echo 
   echo "########## COPYM ##########"
   cd "$MODPATH/autod"
   rm "place"
   base c

}

debloat() {
   echo 
   echo "########## DEBLOAT ##########"
   base d
}


ccache() {
    echo 
    echo "########## CCACHE ##########"
    cd $initial_dir
    rm -rf "$MODPATH/autod"
    rm -rf /data/resource-cache/*
    rm -rf /data/system/package_cache/*
    rm -rf /cache/*
    rm -rf /data/dalvik-cache/*
}
#main script

cd $MODPATH
unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2
debloat
copym
ccache
set_perm_recursive "$MODPATH" 0 0 0755 0644