mod dev-dot "~/Documents/dev/github/mister-ken/dotfiles/dev-dot.just"

set shell := ["bash", "-c"]
set positional-arguments

default: all
all: version list prep deploy status test clean iforgot
clean-all: clean

# version stuff
[group('default')]
@version:
   echo ">> running $0"

[group('default')]
@prep:
   echo ">> running $0"

[group('default')]
@deploy:
   echo ">> running $0"

[group('default')]
@list:
   echo ">> running $0"
   just --list

[group('default')]
@status:
   echo ">> running $0"

[group('default')]
@test:
   echo ">> running $0"

[group('default')]
@clean:
   echo ">> running $0"

[group('default')]
@iforgot:
   echo ">> running $0"
   cat $DOTFILES/.iforgot