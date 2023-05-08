// This contract gets the real time prices of bitcoin and ethereum cryptocurrencies.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);


  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

//import "AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal btcpricefeed;
    AggregatorV3Interface internal ethpricefeed;

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */
    constructor() {
        btcpricefeed=AggregatorV3Interface(0xA39434A63A52E749F02807ae27335515BA4b07F7);
        ethpricefeed=AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
    }

    /**
     * Returns the latest price.
     */
    function getbtcLatestPrice() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = btcpricefeed.latestRoundData();
        return price;
    }
    function getethLatestPrice() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = ethpricefeed.latestRoundData();
        return price;
    }

}
