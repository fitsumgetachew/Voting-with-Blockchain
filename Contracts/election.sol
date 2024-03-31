// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Election {
    // Struct to represent a candidate
    struct Candidate {
        string name;
        string proposal;
        uint256 voteCount;
    }

    // Struct to represent a voter
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        bool hasDelegated;
        address delegate;
        uint256 vote;
    }
// State variables
    address public admin;
    bool public electionStarted;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;

    // Constructor to set the admin
    constructor() {
        admin = msg.sender;
    }

    // Modifier to restrict access to the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Function to add a new candidate
    function addCandidate(string memory _name, string memory _proposal) public onlyAdmin {
        require(!electionStarted, "Cannot add candidate after election has started");
        candidates.push(Candidate(_name, _proposal, 0));
    }

    // Function to add a new voter
    function addVoter(address _voter) public onlyAdmin {
        require(!voters[_voter].isRegistered, "Voter already registered");
        voters[_voter].isRegistered = true;
    }

    // Function to start the election
    function startElection() public onlyAdmin {
        require(!electionStarted, "Election already started");
        electionStarted = true;
    }
// Function to display candidate details
    function getCandidateDetails(uint256 _id) public view returns (string memory, string memory, uint256) {
        require(_id < candidates.length, "Invalid candidate ID");
        Candidate memory candidate = candidates[_id];
        return (candidate.name, candidate.proposal, candidate.voteCount);
    }

    // Function to show the winner of the election
    function getWinner() public view returns (string memory, uint256, uint256) {
        require(electionStarted, "Election has not started yet");
        require(candidates.length > 0, "No candidates registered");

        Candidate memory winner;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winner.voteCount) {
                winner = candidates[i];
            }
        }

        return (winner.name, winner.voteCount, candidates.length);
    }

    // Function to delegate voting rights
    function delegateVote(address _delegateAddress) public {
        require(electionStarted, "Election has not started yet");
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        require(!voters[msg.sender].hasDelegated, "Voter has already delegated their vote");
        require(_delegateAddress != msg.sender, "Cannot delegate vote to yourself");
        require(voters[_delegateAddress].isRegistered, "Delegate address is not registered");

        voters[msg.sender].hasDelegated = true;
        voters[msg.sender].delegate = _delegateAddress;
    }

    // Function to cast the vote
    function castVote(uint256 _candidateId) public {
        require(electionStarted, "Election has not started yet");
        require(!voters[msg.sender].hasVoted, "Voter has already voted");
        require(!voters[msg.sender].hasDelegated, "Voter has delegated their vote");

        require(_candidateId < candidates.length, "Invalid candidate ID");

        candidates[_candidateId].voteCount++;
        voters[msg.sender].vote = _candidateId;
        voters[msg.sender].hasVoted = true;
    }
}
