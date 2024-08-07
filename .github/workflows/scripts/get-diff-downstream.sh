#!/bin/bash -e

_WORK_DIR=$1

function get_downstream() {
  items=$1
  for item in $items; do
    case "$item" in
      antlr4 ) dss=shakujo ;;
      shakujo ) dss=mizugaki ;;
      takatori ) dss="yugawara tatetama" ;;
      yugawara ) dss=mizugaki ;;
      mizugaki ) dss=jogasaki ;;
      limestone ) dss=shirakami ;;
      yakushima ) dss=shirakami ;;
      shirakami ) dss=sharksfin ;;
      sharksfin ) dss=tateyama ;;
      tateyama ) dss=jogasaki ;;
      jogasaki ) dss=ogawayama ;;
      ogawayama ) dss=tateyama-bootstrap ;;
      tateyama-bootstrap ) dss="" ;;
      tsubakuro ) dss=tanzawa ;;
      tanzawa ) dss="" ;;
      * ) continue
    esac

    echo "@$item@"
    if [ "$dss" != "" ]; then
      get_downstream "$dss"
    fi
  done
}

if [ "${GITHUB_REF_NAME}" == "master" ]; then
  _DIFF_TARGET="HEAD~"
else
  _DIFF_TARGET="origin/master"
fi

cd "$_WORK_DIR"
_DIFF_FILES=$(git diff --name-only ${_DIFF_TARGET})

get_downstream "$_DIFF_FILES" > ./work.txt
_DS=$(awk '!a[$0]++' ./work.txt)
rm ./work.txt
echo $_DS
