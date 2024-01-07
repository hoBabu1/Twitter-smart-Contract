//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
contract Twitter
{
    // Structure of a Tweet 
    struct Tweet {
        uint id ;
        // who tweeted
        address author ;
        //stores the message what he is tweeting 
        string content ;
        // Stores when tweet was created 
        uint createdAt;
    }
    // Structure of a mesage 
    struct Message {
        uint id ;
        string content ;
        address from ;
        address to;
        // Stores when message was sent  
        uint createdAt;
    }
    // StoreTweet Information
    mapping(uint=>Tweet) public tweets;
    // Storing id of twitter of a each address 
    mapping(address=>uint[]) public tweetsOf;
    // To store conversastion
    mapping(address => Message[]) public conversastion;
    // Its a nested mapping --> To give access who can control it 
    mapping(address => mapping(address=> bool)) public operations;
    // To store whom one is following 
    mapping(address => address[]) public following ;
    uint nextId;
    uint nextMessageId;
    function Tweeting(address _from , string memory _content) internal {
        require(msg.sender == _from || operations[msg.sender][_from] );
        tweets[nextId] = Tweet(nextId ,_from , _content , block.timestamp  );
        tweetsOf[_from].push(nextId);
        nextId=nextId+1;
    }
    function Messaging(string memory _content , address _from , address _to) internal 
    {
        require(msg.sender == _from || operations[msg.sender][_from] );
        conversastion[_from].push(Message(nextMessageId , _content , _from  , _to , block.timestamp));
        nextMessageId++;
    }
    // if a person is doing message on his own
    function _tweet(string memory _content ) public {
        Tweeting(msg.sender , _content );
    }
    // if other peron does message--> who is hanf=deling it 
    function _tweet(address from , string memory _content ) public {
        Tweeting(from , _content );
    }
     // if a person is doing message on his own
    function sendMessage(string memory _content  , address to) public 
    {
        Messaging(_content , msg.sender , to );
    }
     // if other peron does message--> who is hanf=deling it 
    function sendMessage(string memory _content  , address _to  , address _from) public 
    {
        Messaging(_content , _from , _to );
    }
    function _following(address toFollow) public {
        following[msg.sender].push(toFollow);
    }
    function allow(address operator) public 
    {
        operations[msg.sender][operator] = true ;
    }
     function disallow(address operator) public 
    {
        operations[msg.sender][operator] = false ;
    }
    // u cannot return mapping so storing all latest tweet in array and returning it 
    function getLatesttweets(uint count ) public view returns(Tweet[] memory)
    {
        require(count>0 && count <= nextId , "Count is not proper");
        Tweet[] memory _tweets = new Tweet[](count); // arrayLength = count ;
        uint j ;
        for(uint i = nextId-count ;i<nextId ; i++ )
        {
            // getting current tweet 
            Tweet storage curr = tweets[i];
            _tweets[j]=Tweet(curr.id,curr.author, curr.content , curr.createdAt);
            j=j+1;
        }
        return _tweets;
    }
    // function to get all the tweets by a user 
    function getAllTweets(address _from , uint count ) public view  returns(Tweet[] memory)
    {
        uint length = tweetsOf[_from].length;
         Tweet[] memory _tweets = new Tweet[](length);
        uint[] memory ids = tweetsOf[_from];
        require(count>0 && count <= length , "Count is not proper");
        uint j;
        for(uint i = length-count ; i<length ;i++)
        {
           Tweet memory curr = tweets[ids[i]];
            _tweets[j]=Tweet(curr.id,curr.author, curr.content , curr.createdAt);
            j=j+1;
        }
        return _tweets;
    }
}