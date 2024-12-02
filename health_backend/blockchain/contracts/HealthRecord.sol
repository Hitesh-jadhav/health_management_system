// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthRecord {
    struct Record {
        uint id;
        address user;
        string data;
    }

    mapping(uint => Record) public records;
    uint public recordCount;

    // Declare the event
    event RecordAdded(uint indexed id, address indexed user, string data);

    function addRecord(string memory data) public returns (uint) {
        recordCount++;
        records[recordCount] = Record(recordCount, msg.sender, data);
        
        // Emit the event after adding the record
        emit RecordAdded(recordCount, msg.sender, data);
        return recordCount; // Return the new record ID
    }

    function getRecord(uint id) public view returns (Record memory) {
        require(id > 0 && id <= recordCount, "Record does not exist");
        return records[id];
    }
}
