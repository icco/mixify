# Mixify

Turns a list of Soundcloud URLs into a crossfaded mix.

Songs must be .wavs so this helps

`youtube-dl [URL] -x --audio-format wav`

How to run it:

`sh crossfade_cat.sh 11 1.wav 2.wav auto auto`

Tame the final result by turning it into an mp3

`ffmpeg -i mix.wav -codec:a libmp3lame -qscale:a 2 output.mp3`
