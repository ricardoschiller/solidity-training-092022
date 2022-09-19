// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


//these interfaces follow the specification from Uniswap https://docs.uniswap.org/protocol/V2/reference/smart-contracts/router-02
interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

interface IUniswapV2Pair {
    function token0() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);
}


library Pool {

function hasPoolBeenCreated(
        address router,
        address tokenAddress
    ) internal view returns (bool) {
        return
            IUniswapV2Factory((IUniswapV2Router02(router)).factory()).getPair(
                tokenAddress,
                (IUniswapV2Router02(router)).WETH()
            ) != address(0x0);
    }

    function createPool(
        address router,
        address tokenAddress
    ) internal returns (address) {
        return
            IUniswapV2Factory((IUniswapV2Router02(router)).factory())
                .createPair(tokenAddress, (IUniswapV2Router02(router)).WETH());
    }


    function addLiquidityETH(
        address tokenAddress,
        address lpTokensReceiver,
        address router,
        uint256 tokenAmount,
        uint256 ethAmount,
        uint256 deadline
    ) internal {
        
        IUniswapV2Router02(router).addLiquidityETH { value: ethAmount }(
            tokenAddress,
            tokenAmount,
            0,
            0,
            lpTokensReceiver,
            deadline
        );
    }

    function swapEthForTokens(
        uint256 ethAmount,
        address receiver,
        address originAddress,
        address destinationAddress,
        address router,
        uint256 deadline
    ) internal {
        address[] memory path = new address[](2);
        path[0] = originAddress;
        path[1] = destinationAddress;

        IUniswapV2Router02(router).swapExactETHForTokens{value: ethAmount}(
            0,
            path,
            receiver,
            deadline
        );
    }

    function getPoolReserves(address tokenAddress, address pair)
        internal
        view
        returns (uint256 tokenAmount, uint256 otherTokenAmount)
    {
        IUniswapV2Pair uniswapPair = IUniswapV2Pair(pair);
        (uint256 reserveIn, uint256 reserveOut, ) = uniswapPair.getReserves();

        if (uniswapPair.token0() == tokenAddress) {
            tokenAmount = reserveIn;
            otherTokenAmount = reserveOut;
        } else {
            tokenAmount = reserveOut;
            otherTokenAmount = reserveIn;
        }

        return (tokenAmount, otherTokenAmount);
    }

}