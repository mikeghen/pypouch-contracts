# PyPouch

**PyPouch is a smart contract for simplified Aave yield accounting, enabling seamless PYUSD savings management.**

## Overview

PyPouch is an on-chain smart contract designed to facilitate the management of PYUSD savings by interfacing directly with Aave. Users can seamlessly deposit and withdraw PYUSD while earning yield. The contract automates yield accounting by checkpointing balances during each user transaction (deposit, withdraw, send, receive), emitting events to log interest accrued between transactions.

## Deployment Addresses

### Mainnet Ethereum

| Contract          | Address                                    |
|-------------------|-------------------------------------------|
| PyPouchFactory    | [0x9e42737Bc5FCEE35bcCe8B8F277F266C01a20817](https://etherscan.io/address/0x9e42737Bc5FCEE35bcCe8B8F277F266C01a20817) |
| PyPouch Implementation | [0xd3a3e049402D3e241d1fef3eD1D62d35E7656c4e](https://etherscan.io/address/0xd3a3e049402D3e241d1fef3eD1D62d35E7656c4e) |
| PyPouch Instance  | [0xfe16A93Eb7b5731B15E1d660f07e498BA12d84D7](https://etherscan.io/address/0xfe16A93Eb7b5731B15E1d660f07e498BA12d84D7) |


## Features

- **Deposit and Withdraw**: Easily deposit PYUSD into Aave and withdraw it when needed.
- **Event-Driven Yield Accounting**: Automatically tracks and logs interest earned between transactions.
- **Send and Receive**: Transfer PYUSD to other users directly or via QR code.
- **Transparent Yield Tracking**: All yield calculations are done on-chain and can be easily verified.

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html)
- [Node.js](https://nodejs.org/) (for running scripts)

### Installation

1. Clone the repository:
   ```shell
   git clone https://github.com/yourusername/pypouch.git
   cd pypouch
   ```

2. Install dependencies:
   ```shell
   forge install
   ```

### Build

Compile the smart contracts:

```shell
forge build
```

### Test

Run the test suite:

```shell
forge test
```

### Deploy

Deploy the PyPouch contract to a network:

```shell
forge script script/DeployPyPouch.s.sol:DeployPyPouchScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

## Documentation

For more detailed information about PyPouch, please refer to our [whitepaper](Whitepaper.pdf).

## Contributing

We welcome contributions to PyPouch! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

This project is licensed under the [MIT License](LICENSE).