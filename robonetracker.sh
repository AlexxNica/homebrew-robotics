#!/bin/bash

# This script is intended to setup robonetracker in ~/source/robonetracker
# with dependencies on homebrew or linuxbrew depending on the OS being used
# @author Andrew Hundt <ATHundt@gmail.com>
#
# 
# One step setup command for robonetracker:
# bash <(curl -fsSL https://raw.githubusercontent.com/ahundt/homebrew-robotics/master/robonetracker.sh)

echo ""
echo "##############################################################################################"
echo "# Make sure you have access to https://github.com/ahundt/robonetracker                       #"
echo "# Also, know your github username and password, if you don't you'll have to finish manually! #"
echo "##############################################################################################"
echo ""


# stop on errors
set -e
set -u
set -x


# source: https://gist.github.com/phatblat/1713458
# Save script's current directory
DIR=$(pwd)


#
# Check if Homebrew is installed
#
which brew
if [[ $? != 0 ]] ; then
    
    case "$OSTYPE" in
      solaris*) echo "SOLARIS" ;;
      darwin*)  /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)" ;; 
      linux*) curl -fsSL https://raw.githubusercontent.com/ahundt/homebrew-robotics/master/linuxbrew-standalone.sh | bash /dev/stdin ;;
      bsd*)     echo "BSD" ;;
      *)        echo "unknown: $OSTYPE" ;;
    esac
    
else
    brew update
fi

#
# Check if Git is installed
#
which -s git || brew install git


cd $HOME

# lots of scientific libraries and developer tools
brew tap homebrew/science

brew install python
brew install cmake --with-docs
brew install doxygen flatbuffers
brew install boost --c++11

# brew install pcl --with-qt5 --with-openni2 --with-examples


case "$OSTYPE" in
  solaris*) echo "SOLARIS" ;;

  # Mac OSX TODO:

  # Enable --with cuda if you have an nvidia graphics card and cuda 7.0 or greater installed
  # install caskroom application manager
  # brew casks are only supported on mac, not linux
  
  # http://docs.nvidia.com/cuda/index.html
  #brew cask install cuda
  #brew cask install vrep
  darwin*)  brew install caskroom/cask/brew-cask ;; 
  linux*) ;;
  bsd*)     echo "BSD" ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

brew install opencv3 --c++11 --with-contrib # --with-cuda

# from https://github.com/ahundt/homebrew-robotics
# robotics related libraries
brew tap ahundt/robotics
brew install cmake-basis --devel -v
brew install --HEAD --build-from-source --HEAD cisstnetlib # --cc=clang 
brew install cisst --devel
brew install sawconstraintcontroller --HEAD
brew install azmq --HEAD

cd $DIR

# TODO: Check for robonetracker dir before cloning
git clone git@github.com:ahundt/robonetracker.git
cd robonetracker; mkdir build; cd build; cmake ..; make -j4