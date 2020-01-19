pragma solidity ^0.5.0;

interface IBank{
    function deposit() external payable returns(bool);
    function withdraw(uint _amount) external payable returns(bool);
    function checkBalance() external view returns(uint);
    function closeAccount() external payable returns(bool);
}

contract PIAICBank is IBank{
    
    mapping(address => uint) balances;
    address[] addresses;
    address payable owner;
    
    constructor() payable public{
        require(msg.value >= 5 ether, "Minimum capital requirement is 5 ether");
        owner = msg.sender;
    }
    
    event depositComplete(address, uint);
    event withdrawCompleted(address, uint);
    
    modifier onlyOwner(){
        require(msg.sender == owner, "You do not have permission to perform this operation");
        _;
    }
    
    function deposit() external payable returns(bool){
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        addresses.push(msg.sender);
        emit depositComplete(msg.sender, msg.value);
        return true;
    }
    
    function withdraw(uint _amount) external payable returns(bool){
        uint amount = _amount * 1000000000000000000;
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        address(msg.sender).transfer(amount);
        emit withdrawCompleted(msg.sender, amount);
        return true;
    }
    
    function checkBalance() external view returns(uint){
        return balances[msg.sender];
    }
    
    function closeAccount() external payable returns(bool){
        
    }
    
    function showTotalBankFund() public view onlyOwner() returns(uint){
        //require(msg.sender == owner);
        return address(this).balance;
    }
    
    function showTotalActiveAccounts() public view onlyOwner() returns(uint){
        //require(msg.sender == owner);
        return addresses.length;
    }
    
    function closeBank() public payable onlyOwner(){
        selfdestruct(owner);
    }
}