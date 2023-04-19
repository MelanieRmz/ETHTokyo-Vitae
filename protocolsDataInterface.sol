// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.10;

contract protocolsDataInterface 
{
    mapping(string => uint) public numberOfProtocolMembers;
    mapping(address => string) public memberOfProtocol;
    mapping(address => string) public candidateOfProtocol;
    mapping(string => bool) public protocolNameTaken;
    mapping(string => uint) public votesOfProtocolNeeded; 
    mapping(address => bool) public registeredOnProtocol;
    mapping(address => bool) public registeredAsCandidate;
    mapping(address => uint) public votesForCandidate;
    
    mapping(string => uint) public lensPofileSbtCollectPubliaction; 






    function registerProtocol(string memory paramProtocolName, uint paramVotesNeeded, uint paramActualProtocolMembers, address[] memory paramActualProtocolMembersArray) public 
    {
        require(protocolNameTaken[paramProtocolName] == false, "Protocol name already taken.");
        require(paramVotesNeeded >= 1, "Votes needed cannot be zero.");
        require(paramActualProtocolMembers == paramActualProtocolMembersArray.length, "Number of actual members mismatch.");

        for(uint i = 0;i < paramActualProtocolMembers;i++)
        {
            require(registeredOnProtocol[paramActualProtocolMembersArray[i]] == false, "Already on a Protocol.");

            registeredOnProtocol[paramActualProtocolMembersArray[i]] = true;
            memberOfProtocol[paramActualProtocolMembersArray[i]] = paramProtocolName;
        }

        numberOfProtocolMembers[paramProtocolName] = paramActualProtocolMembers;
    }

    function registerNewProtocolMember(address paramNewMember) public
    {
        require(registeredOnProtocol[msg.sender], "This address cant register a member because doesnt belong to a protocol.");
        require(registeredOnProtocol[paramNewMember] == false, "A member of a protocol cannot be registered as a candidate.");
        require(registeredAsCandidate[paramNewMember] == false, "The candidate is already on another protocol as a candidate.");
        
        candidateOfProtocol[paramNewMember] = memberOfProtocol[msg.sender];
        registeredAsCandidate[paramNewMember] = true;
    }

    function voteForCandidate(address paramCandidateAddress) public
    {
        require(registeredOnProtocol[msg.sender], "The address trying to vote isnt part of the protocol");
        require(keccak256(bytes(memberOfProtocol[msg.sender])) == keccak256(bytes(candidateOfProtocol[paramCandidateAddress])), "Just members of the protocol can accept a candidate.");

        votesForCandidate[paramCandidateAddress]++;
    }

    function turnToMember() external
    {
        require(registeredAsCandidate[msg.sender], "Youre not a candidate to any protocol.");

        if(votesForCandidate[msg.sender] >= votesOfProtocolNeeded[candidateOfProtocol[msg.sender]])
        {
            string memory protocol = candidateOfProtocol[msg.sender];

            votesForCandidate[msg.sender] = 0;
            registeredAsCandidate[msg.sender] = false;
            candidateOfProtocol[msg.sender] = " ";
            registeredOnProtocol[msg.sender] = true;
            memberOfProtocol[msg.sender] = protocol;
            numberOfProtocolMembers[memberOfProtocol[msg.sender]]++;
        }
        else
        {
            revert("Not enough votes yet.");
        }
    }

    function turnDownOffer() public
    {
        require(registeredOnProtocol[msg.sender] == false, "An actual member cannot turn down.");
        require(registeredAsCandidate[msg.sender] == true, "A nonCandidate cannot turn down.");

        candidateOfProtocol[msg.sender] = " ";
        registeredAsCandidate[msg.sender] = false;
        votesForCandidate[msg.sender] = 0; 
    }

}