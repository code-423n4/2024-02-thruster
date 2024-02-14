# Thruster audit details
- Total Prize Pool: $34,500 in USDC
  - HM awards: $25,700 in USDC
  - Analysis awards: $1,400 in USDC
  - QA awards: $700 in USDC
  - Gas awards: $700 in USDC
  - Judge awards: $5,500 in USDC
  - Scout awards: $500 in USDC
 
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2024-02-thruster/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts February 16, 2024 20:00 UTC
- Ends February 23, 2024 20:00 UTC

## This is a Private audit

This audit repo and its Discord channel are accessible to **certified wardens only.** Participation in private audits is bound by:

1. Code4rena's [Certified Contributor Terms and Conditions](https://github.com/code-423n4/code423n4.com/blob/main/_data/pages/certified-contributor-terms-and-conditions.md)
2. C4's [Certified Contributor Code of Professional Conduct](https://code4rena.notion.site/Code-of-Professional-Conduct-657c7d80d34045f19eee510ae06fef55)

*All discussions regarding private audits should be considered private and confidential, unless otherwise indicated.*

Please review the following confidentiality requirements carefully, and if anything is unclear, ask questions in the private audit channel in the C4 Discord.

>>DRAG IN CLASSIFIED IMAGE HERE

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-02-thruster/blob/main/4naly3er-report.md).



_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

[ ⭐️ SPONSORS: Are there any known issues or risks deemed acceptable that shouldn't lead to a valid finding? If so, list them here. ]


# Overview

Thruster is a Uniswap V2 and V3 fork codebase with modifications to the code to match Blast specific features, and also provide implementation for support of a V3 gauge system to be implemneted in the future. The V3 gauge system is out of scope for this audit, but is included in the `ThrusterPool` codebase marked as `gauge`.

A changelog of the modifications can be found in the `ThrusterAudits_Changelog.pdf` file. Additionally, there are two open pull requests, one to show the diffs between the new code and the original V2 core + periphery code, and the other one to show the diffs between the new code and the original V3 core + periphery code.

Additionally, we include a single ThrusterTreasure.sol file that is used to perform a lottery draw like feature. This relies on using the Pyth Entropy product, which relies on off-chain components. The contract itself also relies on an admin to update the merkle proof for how many tickets a user is entitled to claim, as the number of tickets is also computed off chain. Off-chain components are out of scope for this audit, and problems that are caused by admin error are out of scope for the audit.

## Links

- **Documentation:** https://docs.thruster.finance
- **Website:** https://www.thruster.finance
- **Twitter:** https://www.x.com/thrusterfi
- **Discord:** https://www.discord.gg/invite/thrusterfi


# Scope

[ ⭐️ SPONSORS: add scoping and technical details here ]

- [ ] In the table format shown below, provide the name of each contract and:
  - [ ] source lines of code (excluding blank lines and comments) in each *For line of code counts, we recommend running prettier with a 100-character line length, and using [cloc](https://github.com/AlDanial/cloc).* 
  - [ ] external contracts called in each
  - [ ] libraries used in each

*List all files in scope in the table below (along with hyperlinks) -- and feel free to add notes here to emphasize areas of focus.*

| Contract | SLOC | Purpose | Libraries used |  
| ----------- | ----------- | ----------- | ----------- |
| [thruster-clmm/contracts/ThrusterPool.sol] | 601 | The core concentrated liquidity pool, a fork of UniswapV3Pool | OpenZeppelin
| [thruster-clmm/contracts/ThrusterPoolFactory.sol] | 75 | The core factory of the pool, a fork of UniswapV3Factory | OpenZeppelin
| [thruster-clmm/contracts/ThrusterPoolDeployer.sol] | 36 | The core pool deployer responsible for CREATE2 of ThrusterPools | OpenZeppelin
| [thruster-clmm/contracts/NonfungiblePositionManager.sol] | 87 | The periphery position manager for managing liquidity of ThrusterPools | OpenZeppelin
| [thruster-clmm/contracts/libraries/PoolAddress.sol] | 25 | Used for deterministic computation of deployed ThrusterPool contracts via Deployer | OpenZeppelin
| [thruster-clmm/contracts/base/PoolInitializer.sol] | 25 | Used for creating a pool through multicall in the NonfungiblePositionManager | OpenZeppelin
| [thruster-cfmm/contracts/ThrusterFactory.sol] | 86 | The core factory for creating constant function liquidity pools, a fork of UniswapV2Factory | OpenZeppelin
| [thruster-cfmm/contracts/ThrusterPair.sol] | 249 | The core liquidity pool itself, also functions as a fungible token, combines both UniswapV2Pair and UniswapV2ERC20 | OpenZeppelin
| [thruster-cfmm/contracts/ThrusterYield.sol] | 47 | A contract to opt the contract into Blast specific yield claiming and gas claiming | Blast
| [thruster-cfmm/contracts/ThrusterGas.sol] | 27 | A contract to opt the contract only into gas claiming for Blast | Blast
| [thruster-cfmm/libraries/ThrusterLibrary.sol] | 89 | A library contract that includes a function for determinsitic computation of pair addresses | None

## Out of scope

- All contracts under `thruster-cfmm/contracts/libraries/*` except for ThrusterLibrary.sol
- `thruster-cfmm/contracts/ThrusterGasRouter.sol` this is just `ThrusterGas.sol` with a different version for the router
- Router contracts are outside of scope, those had no changes made to them
- Any concentrated liquidity gauge code implementation that will be used by the ThrusterPool
- All contracts under `thruster-clmm/contracts/libraries/*` and `thruster-clmm/contracts/lens/*` and `thruster-clmm/contracts/base/*`, these contracts had no changes aside from name changes
- Any deployment errors are out of scope, e.g. incorrect constructor arguments. For example, we know that we need to use the `ThrusterPoolDeployer.sol` contract address instead of the `ThrusterPoolFactory.sol` contract address when initializing the `SwapRouter.sol`, `QuoterV2.sol` and `NonfungiblePositionManager.sol`.
- MEV attacks are out of scope for this audit.


# Additional Context

- All contracts that use gas should comply with the Blast gas claim logic.
- All contracts that are intended to hold any of the following assets (WETH, USDB, ETH) should comply with the Blast claimable yield logic. The automatic yield is an exception only for ThrusterTreasure.sol, as we will keep a small amount of ETH in the contract to pay for Pyth oracle entropy calls.
- The code follows the same core mechanisms as Uniswap V2 and V3, so constant function market maker and concentrated liquidity market maker.
- Code will be deployed on the Blast L2, which is an Optimisim Stack L2
- Privileged role is in charge enabling the fee on the protocol.
- Deployment of pools for both CFMM and CLMM is permissionless
- Claiming of Blast yield and gas is a permissioned role always
- Treasure lottery is structured as users have the option to enter all their existing tickets for the current round or accumulate tickets. There is no option to partially enter tickets or choose specific numbers. It will also be possible for there to be no winners of the lottery, as it is possible to submit ghost tickets via the merkle by the team.

## Attack ideas (Where to look for bugs)
- ThrusterPool contract for price manipulation
- NonfungiblePositionManager for improper access to liquidity positions
- ThrusterPair contract for price manipulation on trades

## Main invariants
- For ThrusterPair.sol the x * y = k invariant

## Scoping Details 
I confirm the information below

```
- If you have a public code repo, please share it here:  
- How many contracts are in scope?: 11 
- Total SLoC for these contracts?: ~1416 
- How many external imports are there?: 10+ (didn't really count)
- How many separate interfaces and struct definitions are there for the contracts within scope?: 10+ (didn't really count) 
- Does most of your code generally use composition or inheritance?: Inheritance   
- How many external calls?: 1 - Pyth Entropy   
- What is the overall line coverage percentage provided by your tests?: 0
- Is this an upgrade of an existing system?: True - Fork of Uniswap V2 and V3
- Check all that apply (e.g. timelock, NFT, AMM, ERC20, rollups, etc.): AMM 
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?: False   
- Please describe required context:   
- Does it use an oracle?: No 
- Describe any novel or unique curve logic or mathematical models your code uses: Uniswap V2 and V3 math 
- Is this either a fork of or an alternate implementation of another project?: Fork of Uniswap V2 and V3   
- Does it use a side-chain?:
- Describe any specific areas you would like addressed:
```

# Tests

It is hard to run tests, as there is Blast specific code. The way we have been testing is by running scripts on the Blast Sepolia Testnet directly.

*Note: Many wardens run Slither as a first pass for testing.  Please document any known errors with no workaround.* 

## Miscellaneous

Employees of Thruster and employees' family members are ineligible to participate in this audit.
