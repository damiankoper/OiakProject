# Implementacja procedur obliczeń na liczbach zmiennoprzecinkowych za pomocą instrukcji stałoprzecinkowych.
Format `single` i `half` ze słowem 8 bitowym.

## 32bit
For the sake of simplicity this project is compiled using 32bit architecture.
To compile it using g++ on 64bit install `sudo apt-get install g++-multilib`

## Tests
**BDD style is appreciated.**
1. Install [this VsCode extension](https://marketplace.visualstudio.com/items?itemName=matepek.vscode-catch2-test-adapter)
2. Create tests according to [Catch2](https://github.com/catchorg/Catch2/blob/master/docs/tutorial.md#top) specification

## Watch
To watch file changes and recompile tests after change:
* Install `sudo apt-get install inotify-tools`
* Run `./watch.sh [target "watched files"]`
  * You can specify make target alongside with files to be watched enclosed with commas
