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
}