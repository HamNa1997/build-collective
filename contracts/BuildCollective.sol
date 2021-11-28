pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
    bool entreprises;
  }

  struct Entreprise {
    string name;
    uint256 Entreprisebalance;
    string owner;
 
  }

  struct Bounty{
    string description;
    uint256 reward;
    string projectname;
  }

  struct Project {
    string name;
    uint256 projectBalance;
    string owner;
    string[] contributors;
   
   

  }
  struct Projectevent {
    string source;
    string message1;
    string message2;
    string message3;

  }

  

  Project[] public projects;
  string[] public usernamelist;
  Bounty[] public bountylist;

  function createProject(string memory name,string[] memory contributors) public returns (Project memory){
    
    projects.push(Project(name,0,users[msg.sender].username, contributors));
    events[name].push(Projectevent(users[msg.sender].username,"Project created","",""));
    myprojects[users[msg.sender].username].push(Project(name,0,users[msg.sender].username, contributors));
  }

  function returnProjects() public returns (Project[] memory ){
    return projects;
  }
  function returnmyProjects() public returns (Project[] memory ){
    return myprojects[users[msg.sender].username];

  }
  function returnUserlist() public view returns (string[] memory ){
    return usernamelist;
  }

  
  mapping(string => address) private addresses;
  mapping(address => User) private users;
  mapping(string => Entreprise) private entreprises;
  mapping(string => Bounty[]) private bounties;
  mapping(string => Project[]) private myprojects;
  mapping(string => Projectevent[]) private events;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event EntrepriseCreated(string name,User owner);

  function user(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }
  function entreprise(string memory owner) public view returns (Entreprise memory){
    return entreprises[owner];
  }

 

  function signupEntreprise(string memory username,string memory name) public returns (User memory, Entreprise memory){
    users[msg.sender] = User(username, 0, true, true);
    entreprises[username] = Entreprise(name,100,username);
    addresses[username]=msg.sender;
    usernamelist.push(username);
    emit EntrepriseCreated(name,users[msg.sender]);
  }
  function signUp(string memory username) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, 0, true, false);
    addresses[username]=msg.sender;
    usernamelist.push(username);
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  
  function addBounty(string memory projectname,string memory desc,uint256 reward) public{
    bounties[projectname].push(Bounty(desc,reward,projectname));
    bountylist.push(Bounty(desc,reward,projectname));
    events[projectname].push(Projectevent(users[msg.sender].username,"Bounty Added",desc,""));
   

    
  }
  function retunbounties(string memory projectname) public returns(Bounty[] memory){
    return(bounties[projectname]);
    
  }

  function retunevents(string memory projectname) public returns(Projectevent[] memory){
    return(events[projectname]);
    
  }

  
  

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }

  
}
