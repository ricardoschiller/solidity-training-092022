// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ReadWrite {

    struct UserData {
        string ID;
        string Name;
        string Email;
        uint16 BirthYear; //2^16-1 = 65535
        uint8 BirthMonth; //2^8-1 = 255
        uint8 BirthDay; //2^8-1 = 255
        bool IsActive;
    }

    //here instead of using an array we are using a mapping (equal do a key-value pair, value can be another mapping)
    //this way is much faster to find elements, though we can't iterate through all of them
    mapping(string => UserData) public users;

    function read(string memory id) external view returns (UserData memory) {
        return users[id];
    }

    function add(string memory id, string memory name, string memory email, uint16 birthYear, uint8 birthMonth, uint8 birthDay, bool isActive) external {
        UserData memory data;
        data.ID = id;
        data.Name = name;
        data.Email = email;
        data.BirthYear = birthYear;
        data.BirthMonth = birthMonth;
        data.BirthDay = birthDay;
        data.IsActive = isActive;
        users[id] = data;
    }

    function update(string memory id, string memory name, string memory email, uint16 birthYear, uint8 birthMonth, uint8 birthDay, bool isActive) external {
        UserData storage storagePointer;
        
        storagePointer = users[id];
        storagePointer.Name = name;
        storagePointer.Email = email;
        storagePointer.BirthYear = birthYear;
        storagePointer.BirthMonth = birthMonth;
        storagePointer.BirthDay = birthDay;
        storagePointer.IsActive = isActive;
        
    }
}