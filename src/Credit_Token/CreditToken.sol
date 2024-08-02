// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./ERC20.sol";

contract MyToken is ERC20 {
    
    address owner;
    mapping (address => bool) allowedContracts;
    address[] allowedContractsList;

    constructor() ERC20('Credit Score', 'CREDIT', 18) {
        owner = msg.sender;
    }

    function addContract(address _contract) external {
        require(msg.sender == owner, "NOT_OWNER");
        allowedContracts[_contract] = true;
        allowedContractsList.push(_contract);
    }

    function addContracts(address[] memory _contracts) external {
        require(msg.sender == owner, "NOT_OWNER");
        for (uint256 i = 0; i < _contracts.length; i++) {
            allowedContracts[_contracts[i]] = true;
            allowedContractsList.push(_contracts[i]);
        }
    }

    function mintTokens(address _to, uint256 _amount) external {
        require(allowedContracts[_to], "Contract not allowed");
        _mint(_to, _amount);
    }

}