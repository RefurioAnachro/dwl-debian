#!/bin/sh

export XDG_RUNTIME_DIR=/tmp

seatd &
src/dwl/dwl
wait
