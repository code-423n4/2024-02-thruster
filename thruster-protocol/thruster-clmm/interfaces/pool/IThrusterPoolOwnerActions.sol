// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

/// @title Permissioned pool actions
/// @notice Contains pool methods that may only be called by the factory owner
interface IThrusterPoolOwnerActions {
    /// @notice Set the denominator of the protocol's % share of the fees
    /// @param feeProtocol0 new protocol fee for token0 of the pool
    /// @param feeProtocol1 new protocol fee for token1 of the pool
    function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;

    /// @notice Collect the protocol fee accrued to the pool
    /// @param recipient The address to which collected protocol fees should be sent
    /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
    /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
    /// @return amount0 The protocol fee collected in token0
    /// @return amount1 The protocol fee collected in token1
    function collectProtocol(address recipient, uint128 amount0Requested, uint128 amount1Requested)
        external
        returns (uint128 amount0, uint128 amount1);

    /// @notice Set the address of the Thruster CLMM gauge
    /// @param gauge The address of the Thruster CLMM gauge
    function setGauge(address gauge) external;

    /// @notice Claim Yield for native ETH, WETH, USDB, and gas
    /// @param recipient The address to which collected protocol fees should be sent
    /// @param _ethA The amount of ETH to claim
    /// @param _wethA The amount of WETH to claim
    /// @param _usdbA The amount of USDB to claim
    /// @return ethB The amount of ETH claimed
    /// @return wethB The amount of WETH claimed
    /// @return usdbB The amount of USDB claimed
    /// @return gas The amount of gas claimed
    function claimYieldAll(address recipient, uint256 _ethA, uint256 _wethA, uint256 _usdbA)
        external
        returns (uint256 ethB, uint256 wethB, uint256 usdbB, uint256 gas);
}
