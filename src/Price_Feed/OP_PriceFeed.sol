// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract OP_DataConsumerV3 {

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

//ETH:  0x61Ec26aA57019C486B10502285c5A3D4A4750AD7
//USDC: 0x6e44e50E3cc14DD16e01C590DC1d7020cb36eD4C
//USDT: 0xF83696ca1b8a266163bE252bE2B94702D4929392
//OP:   0x8907a105E562C9F3d7F2ed46539Ae36D87a15590
//EURC: 0x8907a105E562C9F3d7F2ed46539Ae36D87a15590
//DAI:  0x4beA21743541fE4509790F1606c37f2B2C312479