#!/bin/bash

# ##############################################################################
# Treat command line args
# ##############################################################################
if [ -z "$1" ]; then
    echo "\e[31mPlease specify a source-file from which to start as the first argument"'!'"\e[0m"
    exit 1
fi
rootFile=$1

if [ ! -z "$2" ]; then INC=":$2"; fi
INC=${rootFile%/*}$INC:.

#INC_ARR=$(echo $INC | tr ":" "\n")
IFS=":" read -a includePaths <<< "$INC"
echo -e "\e[37mInclude Paths (first will be searched first):"
for path in ${includePaths[@]}; do
    echo "    $path"
done
echo -e "\e[0m"

searchedPaths=()

# printAllIncludes <source-file> <level>
printAllIncludes() {
    local file level indent includes i path foundPath
    file=$1
    level=$2

    # print current file
    indent=$(($level * 4))
    printf "%.*s" $indent "                             "
    #if [ ! $indent -eq 0 ]; then
    #    printf "+ ";
    #fi
    printf "%s" "$file"

    # search for file in paths to determine if already found and we can stop parsing it
    local found=0
    for path in ${searchedPaths[@]}; do
        if [ "$path" == "$file" ]; then
            printf " -> already loaded"
            return 1
        fi
    done

    # http://stackoverflow.com/questions/19771965/split-bash-string-by-newline-characters
    IFS=$'\n' read -rd '' -a includes <<<"$(sed -nE 's/^[^/]*#[ \t]*include[ \t]*"([^"]*)".*/\1/p;' "$file")"
    searchedPaths+=( "$file" )

    # parse dependencies recursively
    for (( i=0; i<${#includes[@]}; i++ )); do
    {
        # try to find file in include paths
        foundPath=
        for path in ${file%/*} ${includePaths[@]}; do
            #echo -e "\e[36m path = $path \e[0m"
            if [ -f "$path/${includes[i]}" ]; then
                foundPath="$path/${includes[i]}"
                break
            fi
        done
        if [ ! -f "$foundPath" ]; then
            echo -e "\e[31mCouldn't find '${includes[i]}' in any of the given include paths. Skipping this.\e[0m"
            continue
        fi

        # not already parsed, so do it
        if [ $found -eq 0 ]; then
            printf "\n"
            printAllIncludes "$foundPath" $(($2+1))
        fi
    }
    done
}

printAllIncludes "$rootFile" 0
printf "\n"
