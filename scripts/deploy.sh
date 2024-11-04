#!/bin/bash

source .env
set -e

GREEN='\e[32m'
RESET='\e[0m'

# Declare all contracts
echo -e "$GREEN\n==> Declare HelloStarknet$RESET"
DECLARED_CLASSHASH=$(starkli declare --watch \
    --account $ACCOUNT_SRC \
    --rpc $RPC_URL \
    --keystore $KEYSTORE_SRC \
    --keystore-password $KEYSTORE_PASSWORD \
    ./target/dev/cairo_template_MyToken.contract_class.json)

echo -e "$GREEN\nDeclared Classhash: $DECLARED_CLASSHASH$RESET"

echo -e "$GREEN\n==> Deploy HelloStarknet$RESET"
CONTRACT_ADDRESS=$(starkli deploy --watch \
    --account $ACCOUNT_SRC \
    --rpc $RPC_URL \
    --keystore $KEYSTORE_SRC \
    --keystore-password $KEYSTORE_PASSWORD \
    $DECLARED_CLASSHASH 0x053c80dd051d0a515ba87dc8a3a32d56dc792e30d046ced89c6a537364e3435e)

echo -e "$GREEN$\nDeployed contract address: $CONTRACT_ADDRESS$RESET"
