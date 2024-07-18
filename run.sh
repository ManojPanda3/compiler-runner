#!/bin/bash

FILE_TO_WATCH=""
AUTOFIX=false

while getopts ":af:" opt; do
  case $opt in
    a | af)
      AUTOFIX=true
      ;;
    f)
      FILE_TO_WATCH=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "$FILE_TO_WATCH" ]; then
  echo "Error: No file specified. Use -f or --file to specify the file."
  exit 1
fi

compile_and_run() {
  clang-format -i "$FILE_TO_WATCH"
  clear
  echo "Compiling..."
  COMPILATION_START=$(date +%s.%N)
  if ! g++ -o "${FILE_TO_WATCH%.cpp}.o" "$FILE_TO_WATCH"; then
    INITIAL_HASH=$(md5sum "$FILE_TO_WATCH" | cut -d' ' -f1)
    if $AUTOFIX; then
      clang-tidy -fix-errors "$FILE_TO_WATCH" 2>&1 &
    fi
    return 0;
  fi
  COMPILATION_END=$(date +%s.%N)
  COMPILATION_TIME=$(echo "scale=3; ($COMPILATION_END - $COMPILATION_START) / 1" | bc -l)
  echo "Compilation time: ${COMPILATION_TIME}s"
  echo ""
  echo "Running..."
  RUNNING_START=$(date +%s.%N)
  ./"${FILE_TO_WATCH%.cpp}.o"
  RUNNING_END=$(date +%s.%N)
  RUNNING_TIME=$(echo "scale=3; ($RUNNING_END - $RUNNING_START) / 1" | bc -l)
  echo "Running time: ${RUNNING_TIME}s"
  read -r INITIAL_HASH _ < <(md5sum "$FILE_TO_WATCH")
  INITIAL_HASH=$(md5sum "$FILE_TO_WATCH" | cut -d' ' -f1)
}

trap 'exit 0' SIGINT SIGTERM

INITIAL_HASH="";

while true; do
  CURRENT_HASH=$(md5sum "$FILE_TO_WATCH" | cut -d' ' -f1)
  if [ "$INITIAL_HASH" != "$CURRENT_HASH" ]; then
    compile_and_run
  fi
  sleep 0.33s
done 
exit
