# This script is called automatically by 01-package-clone-and-general-setup.sh

# make sure binaries folder acessible on path
export PATH="~/.local/bin:$PATH"

# install dependencies
cd /src/digital-land-python 
make init

# check digital-land CLI is available
digital-land --help

echo '-------- Dependencies step completed'
