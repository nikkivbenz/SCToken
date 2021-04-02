pragma solidity >= 0.5.0;
//what version of solidity using

contract Token { //matches name of the file (convention)

    mapping(address => uint) public balances; //given an address ouputs balance

    //nested mapping for allowing other addresses to spend money (DEX's)
    mapping(address => mapping(address => uint)) public allowance; 

    //type, visability, (private variables aren't completely private), camelCase naming
    uint public totalSupply = 10000 * 10 ** 18;
    string public name = "Trial Token";
    string public symbol = "TTN";
    uint public decimals = 18;

    //create events when these things are done and called within the functions
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(){
        //send all coins to deployer
        balances[msg.sender] = totalSupply;
    }

    //these function names are required function of the BEP20 Guidelines

    function balanceOf(address owner) public view returns(uint){
        return balances[owner];
    }

    //not view only because modifies blockchain
    function transfer(address to, uint value) public returns(bool){
        //require lets test a logic function
        require(balanceOf(msg.sender) >= value, 'Balance too Low'); //2nd is the error print statement
        balances[to] += value; 
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true; 
    }

    //created for approved spenders 
    function transderFrom(address from, address to, uint value) public returns(bool){
        require(balanceOf(from) >= value, 'Balance too Low');

        //check if approved sender
        require(allowance[from][msg.sender] >= value, 'Allowance Too Low');
        balances[to] += value; 
        balances[from] -= value; 

        //puts the address of from not from allowed spender
        emit Transfer(from, to, value); 
        return true; //will return false at require if doesn't meet requirements
    }

    function approve(address spender, uint value) public returns(bool){
        //sets which is allowed to spend how much
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value); 
        return true; 
    }

}
