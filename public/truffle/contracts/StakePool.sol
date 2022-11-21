// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17 <0.9.0;

contract StakePool {
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
    // state variables
    address admin;
    PoolStatus pStatus = PoolStatus.OPEN;
    mapping(address => Staker) public stakers;

    // constructor() public {}

    event Deposit(
        address indexed _staker,
        uint256 _balance,
        uint256 _depositTimestamp,
        uint256 _apy,
        uint256 _apyTerm
    );

    event Withdraw(
        address indexed _staker,
        uint256 _balance,
        uint256 _depositTimestamp,
        uint256 _apy,
        uint256 _apyTerm,
        uint256 _reward
    );

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

    function getReward(uint256 timestamp)
        public
        pure
        returns (uint256 reward)
    {}

    // stake1, 3, 9 tháng
    // stake1 là 3%, stake3 là 10%, stake 9 là 50% nh
    function deposit(
        uint256 depositTimestamp,
        uint256 apy,
        uint256 apyTerm
    ) public payable {
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

    //  function setUser(uint _idUser) public {
    //     users[_idUser]._user_id = 0;
    //     users[_idUser]._name = 0x7465737400000000000000000000000000000000000000000000000000000000;
    //     users[_idUser]._address = 0x5B38Da6a701c568545dCfcB03FcB870000000000000000000000000000000000;
    //     users[_idUser]._birth_day = 0xf711600000000000000000000000000000000000000000000000000000000000;
    // }

    function setPoolStatus(uint256 _status) public {
        // require(msg.sender == admin, "You are not admin");
        if (_status == uint256(PoolStatus.LOCK)) {
            pStatus = PoolStatus.LOCK;
        } else if (_status == uint256(PoolStatus.OPEN)) {
            pStatus = PoolStatus.OPEN;
        }
    }

    function getPoolInfo()
        public
        view
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
}
