//This is a decentralized voting system smart contract.Hope you understand it!
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ballot{

    struct Proposal{
        bytes32 name;
        uint countVotes;
    }

    struct Voter{
        uint vote;
        uint weight;
        bool voted;
    }

    Proposal[] public proposals;

    mapping(address => Voter) voters;

    address chairPerson;

    constructor(bytes32[] memory proposalNames){

        chairPerson=msg.sender;

        voters[chairPerson].weight=1;

        for(uint i=0;i<proposalNames.length;i++){
            proposals.push(Proposal({
                name:proposalNames[i],
                countVotes:0
            }));
        }
    }

    //function to authenticate voter

    function giveRightToVote(address voter) public{
        require(msg.sender == chairPerson,
        "Only the ChairPerson can give accesss to vote"
        );

        require(!voters[voter].voted,
        "Hey you have already voted"
        );

        require(voters[voter].weight == 0);

        voters[voter].weight = 1;
    }

    //function to vote

    function vote(uint proposal) public{
        Voter storage sender = voters[msg.sender];

        require(sender.weight!=0,"The sender has no right to vote");
        require(!sender.voted,"The sender has already voted");

        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].countVotes += sender.weight;
    }

    //Function that shows the winning proposal by number

    function WinningProposal() public view returns(uint winningProposal_){
        uint winningProposalVoteCount=0;
        for(uint i=0; i<proposals.length; i++){
            if (proposals[i].countVotes > winningProposalVoteCount){
                winningProposalVoteCount=proposals[i].countVotes;
                winningProposal_=i;
            }
        }
        return winningProposal_;
    }

    //Function that shows the winning proposal by name

    function WinningProposalName() public view returns(bytes32 winningProposalName){
        winningProposalName = proposals[WinningProposal()].name;
        return winningProposalName;

    }
}