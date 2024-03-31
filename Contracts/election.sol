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
}