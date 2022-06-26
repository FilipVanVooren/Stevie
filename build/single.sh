#!/usr/bin/env bash

banks="stevie_b0 stevie_b1 stevie_b2 stevie_b3 stevie_b4 stevie_b5 stevie_b6 stevie_b7"
stevie="bin/stevie.bin"

bash assemble.sh $1
if [ "$?" -eq "0" ]; then
    bash concat.sh "$stevie" $banks
else
    echo "**error** Error during assembly process. Terminated."
fi
echo "Done"
