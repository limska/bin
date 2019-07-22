#!/bin/bash

make clean
make MODULES="coSimulationStarccm coSimulationStarccm2 coSimulationStarBasicOperations coSimulationAPI coSimulationRestart coSimulationAbaqus coSimulationVibratingPipe"
bin/startest -m coSimulationStarccm -configure
bin/startest -m coSimulationStarccm2 -append
bin/startest -m coSimulationAPI -append
bin/startest -m coSimulationStarBasicOperations -append
bin/startest -m coSimulationRestart -append
bin/startest -m coSimulationAbaqus -g licensed3rdparty -append
bin/startest -m coSimulationVibratingPipe -append
#bin/startest -m coSimulationStarccm -np 2 -append
#bin/startest -m coSimulationStarccm2 -np 2 -append
#bin/startest -m coSimulationAPI -np 2 -append
#bin/startest -m coSimulationVibratingPipe np 2 -append
bin/startest -runtests
