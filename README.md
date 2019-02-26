# CarPi

macOS/Linux based application for interfacing with automobiles through OBD2 protocol


## Installation

#### macOS

- Install Bundler

`gem install bundler`

- Install git submodules

`git submodule update --init --recursive`

- Install Gems

`bundle install`

#### Linux/Raspbian

Follow the steps above, but before installing Gems:

- Install `fxruby` dependancies

`sudo apt-get install libfox-1.6-dev`
`sudo apt-get install libxrandr-dev`

- Finally Install Gems

`bundle install`
