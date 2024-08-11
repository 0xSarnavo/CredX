// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract Base_DataConsumerV3 {

    address public owner;
    mapping (string => address) public datafeedContracts;

    constructor() {
        owner = msg.sender;
    }

    function addDatafeed(string[] memory _tokenName, address[] memory _tokenaddress) external {
        require(msg.sender == owner,"");
        require(_tokenaddress.length == _tokenName.length," ");
        for(uint i =0; i < _tokenName.length; i++ ){
            datafeedContracts[_tokenName[i]] = _tokenaddress[i];
        }
    }

    function getChainlinkDataFeedLatestAnswer(string memory _tokenDatafeed) external view returns (int) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface (datafeedContracts[_tokenDatafeed]);
        (,int answer,,,) = dataFeed.latestRoundData();
        return answer;
    }
}
//BTC:  0x0FB99723Aee6f420beAD13e6bBB79b7E6F034298
//ETH:  0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1
//USDC: 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165
//USDT: 0x3ec8593F930EA45ea58c968260e6e9FF53FC934f
//DAI:  0xD1092a65338d049DB68D7Be6bD89d17a0929945e