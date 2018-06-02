pragma solidity ^0.4.0;

interface ERC20 {
    function totalSupply() public constant returns (uint _totalSupply);
    function balanceOf(address _owner) public constant returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from , address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public constant returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
contract ModTestToken is ERC20
{
    string public symbol;
    string public name;
    uint8 public decimals = 18;

    uint256 public  __totalSupply;
    mapping (address => uint) private __balanceOf;
    mapping (address => mapping (address => uint)) private __allowances;
    
    //this is just to get the address of owner for testing purpose..
    //function getAddress() public returns (address)
    //{
    //    return msg.sender;
    //}

    function ModTestToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public
    {
        __totalSupply = initialSupply;
        __balanceOf[msg.sender] = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
    }

    function totalSupply() public constant returns (uint _totalSupply)
    {
        _totalSupply = __totalSupply;
    }

    function balanceOf(address _owner) public constant returns (uint balance)
    {
        balance =  __balanceOf[_owner];
        return balance;
    }

    function transfer(address _to, uint _value) public returns (bool success)
    {
        //first check if self has balance to transfer
        if ( (_value > 0) && (_value <= balanceOf(msg.sender)) ) 
        {
            __balanceOf[msg.sender] -= _value;
            __balanceOf[_to] += _value;            
            Transfer(msg.sender, _to, _value);            
            return true;
        }
        return false;
    }
    
    //Remember, to call this from an external account, have some ETHERS in them. Else nothing happens
    function transferFrom(address _from , address _to, uint _value) public returns (bool success)
    {
        if (__allowances[_from][msg.sender] > 0 &&
            _value > 0 &&
            __allowances[_from][msg.sender] >= _value)
            {
                __balanceOf[_from] -= _value;
                __balanceOf[_to] += _value;
                __allowances[_from][msg.sender] -= _value;
                Transfer(_from, _to, _value);
                return true;
            }
        return false;
    }
    function approve(address _spender, uint _value) public returns (bool success)
    {
        __allowances[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public constant returns (uint remaining)
    {
        return __allowances[_owner][_spender];
    }
}
