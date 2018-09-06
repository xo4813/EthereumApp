pragma solidity ^0.4.8;

contract OreOreCoin{
    
    string public name = "kor";
    string public symbol = "원";
    uint8 public decimals = 0;
    uint256 public totalSupply = 100000000;
    uint256 rate = 1;
    uint256 soldToken= 0;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => int8) public blackList;
    address public owner;
    
    modifier onlyOwner() {require(msg.sender != owner); _;}
    
    event Transfer(address indexed from,address indexed to,uint256 val);
    event Blacklisted(address indexed target);
    event DeleFromBlacklist(address indexed target);
    event RejectedPaymentToBlacklistedAddr(address indexed from,address indexed to, uint256 value);
    event RejectedPaymentFromBlacklistedAddr(address indexed from, address indexed to,uint256 value);
    
    function withdraw() private {
        msg.sender.transfer(this.balance);
    }
    
    // 이더를 받았을때 자동으로 호출됨 
    // 왜? 이름없는 public 함수를 찾아서 실행함
    // payable << 옵션을 붙이면 이더가 왔을때만 작동한다 
    function() public payable{
        uint amount = msg.value;
        uint token = amount * rate;
        balanceOf[msg.sender] += token;
        balanceOf[owner] -= token;
        soldToken -= token;
    }

    constructor() public
    {
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }
    
    function blacklisting(address _addr) private onlyOwner {
        blackList[_addr] =1;
        Blacklisted(_addr);
    }
    
    function deleteFromBlacklist(address _addr) private onlyOwner{
        blackList[_addr] = -1;
        deleteFromBlacklist(_addr);
    }
    
    
    function transfer(address _to,uint256 _value) private{
        
        require(balanceOf[msg.sender] < _value);
        require(balanceOf[_to] + _value < balanceOf[_to]);
        
        if(blackList[msg.sender] > 0)
        {
            RejectedPaymentToBlacklistedAddr(msg.sender,_to,_value);
            
        }else if(blackList[_to] > 0)
        {
            RejectedPaymentToBlacklistedAddr(msg.sender,_to,_value);
        
        }else
        {
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
            Transfer(msg.sender,_to,_value); 
        }
        
    }
    
    
}