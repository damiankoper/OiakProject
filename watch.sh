#!/bin/bash
{
    make all
} && {
    while inotifywait -r -e modify src tests/float; do 
        make all
    done
}

