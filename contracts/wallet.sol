// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
// pragma experimental ABIEncoderV2; 

contract Wallet {
    address[] public approvers;
    uint public quorum;
    struct Transfer {
        uint id;
        uint amount;
        address payable to;
        uint approvers;
        bool sent;
    }
    Transfer[] public transfers;
    mapping(address => bool[]) approvals;

    constructor(address[] memory _approvers, uint _quorum) {
        approvers = _approvers;
        quorum = _quorum;
    }

    function getApprovers() external view returns(address[] memory) {
        return approvers;
    }

    function getTransfers() external view returns(Transfer[] memory) {
        return transfers;
    }

    function createTransfer(uint amount, address payable to) external onlyApprover() {
        transfers.push(Transfer(
            transfers.length,
            amount,
            to,
            0,
            false
        ));
    }

    function approveTransfer(uint id) external onlyApprover() {
        //validate if already sent
        require(transfers[id].sent == false, "transfer has already been sent");
        
        //check if the sender does not approve, cannot approve twice
        //require(approvals[msg.sender][id] == false, "cannot approve transfer twice");

        //approvals[msg.sender][id] = true;
        transfers[id].approvers++;

        if(transfers[id].approvers >= quorum) {
            //enough approvers
            transfers[id].sent = true;
            address payable to = transfers[id].to;
            uint amount = transfers[id].amount;
            to.transfer(amount);
        }
    }

    //to receive ether
    //option1
    // function sendEther() external payable {

    // }

    //option2: receive ether using the native way in solidity 
    receive() external payable {}

    modifier onlyApprover() {
        bool allowed = false;
        for(uint i = 0; i < approvers.length; i++) {
            if(approvers[i] == msg.sender) {
                allowed = true;
                break;
            }
        }
        require(allowed == true, "only approver allowed");
        _;
    }
}