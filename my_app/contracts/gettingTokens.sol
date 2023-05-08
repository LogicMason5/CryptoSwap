// This contract helps users to import tokens into their metamask accounts.
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract DevToken is ERC20{
    constructor() ERC20("DevToken", "DVT"){
        _mint(msg.sender,1000*10**18);
    }
}