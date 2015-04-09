# ##############################################################################
# Treat command line args
# ##############################################################################
if [ -z "$1" ]; then
  echo "I need a root file to start from."
  return 1
else
  ROOTFILE=$1
  echo "Use root file: $ROOTFILE"
  fi

if [ -n "$2" ]; then
  echo "Got include path specification: $2"
  INC="$2"
else
  INC="./:./src/:./src/tests/"
  echo "Got no include path specification, use: $INC"
fi

#INC_ARR=$(echo $INC | tr ":" "\n")
IFS=":" read -a INC_ARR <<< $INC


# ##############################################################################
# Define some functions
# ##############################################################################
function is_not_in {
  eval list=\${$1[@]}
  for i in $list; do
    if [ $i = $2 ]; then
      return 1;
      fi
    done
  return 0
}

function not_empty {
  IFS=":" read -a a_ts < $1
  return $(test ${#a_ts[@]} -gt 0)
}

function find_path {
  fn=$1
  for pre in ${INC_ARR[@]}; do
    path="$pre/$fn"
    if [ -f $path ]; then
      echo $path
      return 0
      fi
    done
  return 1
}

function search_incs {
  fn=$1
  path=$(find_path $fn)
  if [ $? -eq 0 ]; then
    cat $path | grep "#include" | grep -v "<" | grep -v ^// | sed -e 's/#include "//;s/"//g'
  else
    echo ""
    fi
}


# ##############################################################################
# main
# ##############################################################################
dir="/tmp/include-spider/"
if [ -d $dir ]; then :
else
  mkdir $dir
  fi

fn_ts="/tmp/include-spider/tmp_to_search.txt"
fn_s="/tmp/include-spider/tmp_searched.txt"
echo -ne "$ROOTFILE:" > $fn_ts
echo -ne "" > $fn_s

while $(not_empty $fn_ts); do
  IFS=":" read -a a_ts < $fn_ts
  IFS=":" read -a a_s  < $fn_s
  next=${a_ts[0]}
  echo -ne "" > $fn_ts; for i in ${a_ts[@]:1}; do echo -ne "$i:" >> $fn_ts; done
#  echo "current target: $next"
#  echo "still listed: $(cat $fn_ts)"
  if $(is_not_in a_s $next); then
#    echo "search result: $(search_incs $next)"
    for i in $(search_incs $next); do
      echo -ne "$i:" >> $fn_ts
      done
    echo -ne "$next:" >> $fn_s
    fi
#  echo ""
done
echo -ne "\n" >> $fn_s

result=$(cat $fn_s | tr ":" "\n")
echo -e "\n$ROOTFILE directly or indirectly depends on:\n\n${result[@]}"

