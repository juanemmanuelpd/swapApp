// License 
// SPDX-License-Identifier: MIT

// Solidity compiler version
pragma solidity 0.8.24;

// Libraries
import "forge-std/Test.sol";
import "../src/swapApp.sol";

// Contract
contract swapAppTest is Test{

    swapApp app;

    // Variables
    address uniswapV2SwapRouterAddress = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24;
    address user = 0x21Ec864f18543Aa335F0E9Ba2CB0AD0F1892f5aE; // Address with USDT in Arbitrum Mainnet
    address tokenUSDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831; // USDC address in Arbitrum Mainnet
    address tokenDAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI address in Arbitrum Mainnet

    // Set Up
    function setUp() public{
        app = new swapApp(uniswapV2SwapRouterAddress);
    }

    // Testing functions

    function testHasBeenDeployedCorrectly() public view {
        assert(app.V2Router02Address() == uniswapV2SwapRouterAddress);
    }

    function testSwapTokensCorrectly() public {
        vm.startPrank(user);
        uint256 amountIn = 5 * 1e6;
        uint256 amountOutMin = 1 * 1e18;
        IERC20(tokenUSDC).approve(address(app), amountIn);
        uint256 deadline = 1750495124 + 100000000000;
        address[] memory path = new address[](2);
        path[0] = tokenUSDC; 
        path[1] = tokenDAI;
        uint256 usdcBalanceBefore = IERC20(tokenUSDC).balanceOf(user);
        uint256 daiBalanceBefore = IERC20(tokenDAI).balanceOf(user);
        app.swapTokens(amountIn, amountOutMin, path, deadline);
        uint256 usdcBalanceAfter = IERC20(tokenUSDC).balanceOf(user);
        uint256 daiBalanceAfter = IERC20(tokenDAI).balanceOf(user);
        assert(usdcBalanceAfter == usdcBalanceBefore - amountIn);
        assert(daiBalanceAfter > daiBalanceBefore);
        vm.stopPrank();
    }

}