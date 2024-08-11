// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract TokenVault {
    address public owner;
    IERC20 public acceptedToken;

    event Deposit(address indexed from, uint256 amount);
    event Withdraw(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyAcceptedToken() {
        require(msg.sender == address(acceptedToken), "Only the accepted token can call this function");
        _;
    }

    constructor(address _tokenAddress) {
        require(_tokenAddress != address(0), "Invalid token address");
        acceptedToken = IERC20(_tokenAddress);
        owner = msg.sender;
    }

    // Function to deposit tokens
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(acceptedToken.transfer(address(this), amount), "Transfer failed");
        emit Deposit(msg.sender, amount);
    }

    // Function to withdraw all tokens
    function withdrawAll() external onlyOwner {
        uint256 balance = acceptedToken.balanceOf(address(this));
        require(balance > 0, "No funds to withdraw");
        require(acceptedToken.transfer(owner, balance), "Withdraw failed");
        emit Withdraw(balance);
    }

    // Prevent any direct transfers to the contract
    receive() external payable {
        revert("Direct transfers are not allowed");
    }

    // Prevent ERC20 tokens other than the accepted one from being transferred to the contract
    function onERC20Received(address from, uint256 amount) external onlyAcceptedToken {
        emit Deposit(from, amount);
    }
}