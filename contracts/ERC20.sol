// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ERC20 {
    string public name;
    string public symbol;
    uint8 public immutable decimals;
    uint256 public immutable totalSupply;
    mapping(address => uint256) _balances;
    //spender =>(owner => no of token allowed)
    mapping(address => mapping(address => uint256)) _allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _Owner,
        address indexed _spender,
        uint256 _value
    );

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        totalSupply = _totalSupply;
        _balances[msg.sender] = _totalSupply;
    }

    function balanceOf(address _Owner) external view returns (uint256) {
        require(_Owner != address(0), "you cant use zero address");
        return _balances[_Owner];
    }

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(
            (_balances[msg.sender] >= _value) && (_balances[msg.sender] > 0),
            "Insufficient balance"
        );
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool) {
        require(_allowances[msg.sender][_from] >= _value, "!ALW");
        require(
            (_balances[msg.sender] >= _value) && (_balances[msg.sender] > 0),
            "Insufficient balance"
        );
        _balances[_from] -= _value;
        _balances[_to] += _value;
        _allowances[msg.sender][_from] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
        
    }

    function approve(address _spender, uint256 _value) external  returns (bool) {
        require(_balances[msg.sender] >= _value, "Insufficient balance");
        _allowances[_spender][msg.sender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) external view  returns (uint256) {
        return _allowances[_spender][_owner];
    }
}

