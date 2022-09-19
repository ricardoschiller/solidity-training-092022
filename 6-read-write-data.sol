// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ReadWrite {

    //we can organize data using structures
    struct UserData {
        string ID;
        string Name;
        string Email;
        uint16 BirthYear; //2^16-1 = 65535
        uint8 BirthMonth; //2^8-1 = 255
        uint8 BirthDay; //2^8-1 = 255
        bool IsActive;
    }

    //an array of data structures - notice it isn't initialized, and doesn't need to
    UserData[] public users;

    //notice the uint256
    function read(uint256 pos) external view returns (UserData memory) {
        require(pos >= 0 && pos < users.length, "Position out of bounds");
        return users[pos];
    }

    //notice the different variable types
    function add(string memory id, string memory name, string memory email, uint16 birthYear, uint8 birthMonth, uint8 birthDay, bool isActive) external {
        //notice the memory state access
        UserData memory data;
        data.ID = id;
        data.Name = name;
        data.Email = email;
        data.BirthYear = birthYear;
        data.BirthMonth = birthMonth;
        data.BirthDay = birthDay;
        data.IsActive = isActive;
        //here, memory data is pushed to storage
        users.push(data);
    }

    function update(string memory id, string memory name, string memory email, uint16 birthYear, uint8 birthMonth, uint8 birthDay, bool isActive) external {
        //a variable (pointer) that points to storage
        UserData storage storagePointer;
        
        for(uint i = 0; i < users.length; i++) {
            if(keccak256(abi.encodePacked(users[i].ID)) == keccak256(abi.encodePacked(id))) {
                storagePointer = users[i];
                storagePointer.Name = name;
                storagePointer.Email = email;
                storagePointer.BirthYear = birthYear;
                storagePointer.BirthMonth = birthMonth;
                storagePointer.BirthDay = birthDay;
                storagePointer.IsActive = isActive;
                break;
            }
        }
    }

    //here we are using the id to find the record
    function remove(string memory userID) external {
        for(uint i = 0; i < users.length; i++) {
            //ignore this part, this is just to compare strings :|
            if(keccak256(abi.encodePacked(users[i].ID)) == keccak256(abi.encodePacked(userID))) {
                //notice this weird code
                //if the element is the last one in the array, we pop it
                if(i == users.length - 1) {
                    users.pop();
                }
                //otherwise we overide it with the last element, and then pop the last element
                //this is because we can't remove elements from inside an array
                else {
                    users[i] = users[users.length - 1];
                    users.pop();
                }
            }
        }
    }
}