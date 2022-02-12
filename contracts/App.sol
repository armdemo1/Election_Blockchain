//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import './Poll.sol';
import "hardhat/console.sol";

contract App {
  address adminAddress = 0xF23DfA69b55aAE4d01069461C3Ae3BF68611182F;
  struct PollStruct {
    string title;
    string description;
    string[] options;
    address pollAddr;
    Poll pollContract;
    bool isRunning;
    address[] voters;
    uint[] voteCounts;
    address creator;
  }

  Poll[] private pollsList;

  PollStruct[] private runningPollsData;

  mapping(address => PollStruct) addrToPoll;


  //////////////////////////////////////////////////////////////////////
  function createPoll(
    string memory _title, 
    string memory _description, 
    string[] memory _options
  ) public {
    
    Poll newPoll = new Poll();
    pollsList.push(newPoll);

    uint256[] memory voteCounts = new uint256[](_options.length);

    for (uint i = 0; i < _options.length; i++) {
      voteCounts[i] = 0;
    }

    PollStruct memory newPollStruct = PollStruct({
      title: _title,
      description: _description,
      options: _options,
      pollAddr: address(newPoll),
      pollContract: newPoll,
      isRunning: true,
      voters: new address[](0),
      voteCounts: voteCounts,
      creator: msg.sender
    });

    addrToPoll[address(newPoll)] = newPollStruct;

    runningPollsData.push(newPollStruct);
  }

  //////////////////////////////////////////////////////////////////////
  function resetPolls() public {
   if (msg.sender != adminAddress){
      console.log('user attempted to reset poll on their own.');
      console.log('user ==>', adminAddress);
      return;
   }
    delete runningPollsData;
  }


  //////////////////////////////////////////////////////////////////////
  function getRunningPolls() public view returns (PollStruct[] memory) {
    console.log('Retrieving all polls');

    return runningPollsData;
  }


  //////////////////////////////////////////////////////////////////////
  function closePoll(address pollAddr, address userAddr, uint pollIdx) public {
    PollStruct storage pollToClose = addrToPoll[pollAddr];

    if (userAddr != pollToClose.creator) {
      console.log('user attempted to close poll they do not own.');
      console.log('user ==>', userAddr);
      return;
    }

    pollToClose.isRunning = false;
    runningPollsData[pollIdx] = pollToClose;
  }


  //////////////////////////////////////////////////////////////////////
  function handleVote(address pollAddr, address userAddr, uint pollIdx, uint optIdx) public {
    PollStruct storage pollStruct = addrToPoll[pollAddr];

    if (!pollStruct.isRunning) {
      console.log('User attempted to vote on closed poll');
      console.log('user ==>', userAddr);
      return;
    }

    
    bool alreadyVoted = false;

    for (uint i = 0; i < pollStruct.voters.length; i++) {
      if (pollStruct.voters[i] == userAddr) {
        alreadyVoted = true;
      }
    }

    if (alreadyVoted) {
      console.log('User attempted to vote more than once');
      console.log('user ==>', userAddr);
      return;
    }

   
    pollStruct.voteCounts[optIdx] += 1;
    pollStruct.voters.push(userAddr);
    runningPollsData[pollIdx] = pollStruct;
  }
}
