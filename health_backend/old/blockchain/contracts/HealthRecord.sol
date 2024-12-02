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

    function addRecord(string memory data) public {
        recordCount++;
        records[recordCount] = Record(recordCount, msg.sender, data);
    }

    function getRecord(uint id) public view returns (Record memory) {
        // Check if the record exists
        require(id > 0 && id <= recordCount, "Record does not exist");
        return records[id];
    }
}
