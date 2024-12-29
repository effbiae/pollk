#!/bin/bash
url=shakti.com/edu/k.zip
g=git@github.com:effbiae/k.edu.git
curl="curl -s -S"
etag  (){ $curl -I $url |grep ETag |grep -o '".*"' >etag;}
new   (){ $curl -I $url --header If-None-Match:\ `cat etag`|head -1|grep 200;}
get   (){ $curl $url >k.zip;}
clone (){ git clone $g;}
rmed  (){ comm -23 <(cd k.edu; echo *|tr -s ' ' '\n'|sort) <(echo $(zipinfo -1 k.zip)|tr -s ' ' '\n'|sort);}
gitit (){ (rm=$(rmed); cd k.edu; git pull; git rm $rm; unzip -o ../k.zip; git add .; git commit -m "$(date -u)"; git push);}
bump  (){ git add etag; git commit -m "$(date -u)"; git push; }
if [ ! -e etag ]; then etag; clone; fi
if new; then set -x; get; gitit; etag; bump; fi
