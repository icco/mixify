crossfade_dur=7
i=0

for file in *.wav
do

    i=$((i+1))

    if [ $i -eq 1 ]
    then
        cp $file mix.wav
    else
        crossfade_cat.sh $crossfade_dur mix.wav $file auto auto
    fi

done
