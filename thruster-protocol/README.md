# Thruster Protocol
All repos are compatible with both Forge Foundry and Eth-Brownie compilation. However, `thruster-cfmm` is not compatible with `forge test` due to Solidity compiler version being too low.

# Compile repositories
```bash
cd thruster-cfmm && forge build
cd ..
cd thruster-clmm && forge build
cd ..
cd thruster-treasure && forge build
```
or
```bash
cd thruster-cfmm && brownie compile
cd ..
cd thruster-clmm && brownie compile
cd ..
cd thruster-treasure && brownie compile
```

Two pull requests are opened titled `Diff to show the changes with the V2 contracts` and `Diff to show the changes with the V3 contracts`. These two PRs show the differences
between the Uniswap V2 Core + Periphery code, as well as the Uniswap V3 Core + Periphery code in accordance to the titles.
