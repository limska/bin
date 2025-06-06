#!/usr/bin/bash

# source /home/sava/TCAE-25.03v1/OpenFOAM-dev/etc/bashrc-release

# source /home/sava/venv/dev/bin/activate

CWD=$(pwd)

#pumps=(17837 18932 18945 18947 18948 18970 18971 19076 19077)
#pumps=(17837 18932 18945 18947 18970 18971)
#pumps=(17837 18932 18945 18947 18971)

# 18948 -> 19114
pumps_def=(17837 18932 18945 18947 19114 18970 18971 19077)

if [ $# -ge 1 ]; then
  pumps=("${@}")
else
  pumps=("${pumps_def[@]}")
fi
echo "pumps=${pumps[*]}"

runCentPump="/home/sava/repo/scripts/run/runCentPump.sh"

for p in "${pumps[@]}"; do
  echo "Running pump $p"
  echo $runCentPump $p --logfile
  $runCentPump $p --logfile
  echo
done

cd "$CWD" || exit
