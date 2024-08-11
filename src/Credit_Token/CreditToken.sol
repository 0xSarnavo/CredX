// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./ERC20.sol";

contract CreditScore is ERC20 {
    
    address owner;
    mapping (address => bool) allowedContracts;
    address[] allowedContractsList;

    constructor() ERC20('Credit Score', 'CREDIT', 18) {
        owner = msg.sender;
    }


    function giveMintAccess(address[] memory _contracts) external {
        require(msg.sender == owner, "NOT_OWNER");
        for (uint256 i = 0; i < _contracts.length; i++) {
            allowedContracts[_contracts[i]] = true;
            allowedContractsList.push(_contracts[i]);
        }
    }

    function revokeMintAccess(address[] memory _contracts) external {
        require(msg.sender == owner, "NOT_OWNER");
        for (uint256 i = 0; i < _contracts.length; i++) {
            allowedContracts[_contracts[i]] = false;
            for (uint256 j = 0; j < allowedContractsList.length; j++) {
                if (allowedContractsList[j] == _contracts[i]) {
                    allowedContractsList[j] = allowedContractsList[allowedContractsList.length - 1];
                    allowedContractsList.pop();
                    break;
                }
            }
        }
    }


    function mint(address _to, uint256 _amount) external override {
        require(allowedContracts[_to], "Contract not allowed");
        _mint(_to, _amount * 10 ** 18);
    }

    function burn(address _to, uint256 _amount) external override {
        require(allowedContracts[_to], "Contract not allowed");
        _burn(_to, _amount * 10 ** 18);
    }

}