!# /usr/bin/env bash

if ! command -v stack &> /dev/null
then
  echo "Installing Stack."
  curl -sSL https://get.haskellstack.org/ | sh
fi

stack setup
# stack build cabal-install

stack install hlint Cabal ihaskell
stack build

