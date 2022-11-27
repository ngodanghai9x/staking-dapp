// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17 <0.9.0;

import "./ScammerAdmin.sol";
import "./Bitcoin.sol";

// import "./IERC20.sol";

contract StakePool is ScammerAdmin {
    struct Staker {
        uint256 amount; // wei, total deposit
        uint256 depositTimestamp;
        uint256 apy; // percent
        uint256 apyTerm; // 30 90 270 days
    }
    enum PoolStatus {
        LOCK,
        OPEN
    }
    uint256 public constant DAY_TIMESTAMP = 60 * 60 * 24;
    // uint256 public constant DAY_TIMESTAMP = 1 days;

    // state variables
    PoolStatus pStatus = PoolStatus.OPEN;
    Bitcoin token;
    mapping(address => Staker) public stakers;

    modifier notLocked() {
        require(
            pStatus == PoolStatus.OPEN,
            "Pool is locked, pls contact admin"
        );
        _; // this _ is the code func will exec when the func impl this modifier
    }

    constructor(address tokenAddress) {
        super;
        token = Bitcoin(tokenAddress);
    }

    event Deposit(
        address indexed _staker,
        uint256 _amount,
        uint256 _depositTimestamp,
        uint256 _apy,
        uint256 _apyTerm
    );
    event Withdraw(
        address indexed _staker,
        uint256 _amount,
        uint256 _depositTimestamp,
        uint256 _apy,
        uint256 _apyTerm,
        uint256 _reward
    );

    function getReward(Staker memory staker, uint256 withdrawTimestamp)
        public
        pure
        returns (uint256)
    {
        unchecked {
            uint256 daysDiff = (withdrawTimestamp - staker.depositTimestamp) /
                DAY_TIMESTAMP;
            require(
                (withdrawTimestamp - staker.depositTimestamp) > DAY_TIMESTAMP,
                "Ban chua stake du toi thieu 1 ngay"
            );
            // require(daysDiff >= staker.apyTerm, "Chua den han rut tien");
            uint256 realApy = daysDiff >= staker.apyTerm ? staker.apy : 1;
            uint256 reward = staker.amount * (realApy / 100) * (daysDiff / 365);

            return reward;
        }
    }

    function getApy(uint256 apyTerm) public pure returns (uint256) {
        if (apyTerm == 30) {
            return 3;
        }
        if (apyTerm == 90) {
            return 10;
        }
        if (apyTerm == 270) {
            return 50;
        }
        // if (apyTerm >= 30 && apyTerm < 90) {
        //     return 3;
        // }
        // if (apyTerm >= 90 && apyTerm < 270) {
        //     return 10;
        // }
        // if (apyTerm >= 270) {
        //     return 50;
        // }
        return 0;
    }

    function deposit(
        uint256 amount,
        uint256 depositTimestamp,
        uint256 apyTerm
    ) public {
        uint256 apy = getApy(apyTerm);
        address owner = msg.sender;

        require(stakers[owner].amount == 0, "You already deposit");
        require(apy > 0, "Invalid apy, apyTerm");
        // token.approve(address(this), amount); must called before on FE
        token.transferFrom(owner, address(this), amount);
        // string memory _amount = uint2str(msg.amount);
        stakers[owner] = Staker(amount, depositTimestamp, apy, apyTerm);
        emit Deposit(owner, amount, depositTimestamp, apy, apyTerm);
    }

    function withdraw(uint256 withdrawTimestamp) public notLocked {
        address withdrawer = msg.sender;
        Staker memory staker = stakers[withdrawer];
        uint256 reward = getReward(staker, withdrawTimestamp);
        uint256 total = staker.amount + reward;
        // uint256 total = 10;
        uint256 coinbase = token.balanceOf(address(this));

        require(staker.amount > 0, "You've not deposit yet");
        require(
            withdrawTimestamp <= block.timestamp,
            "Invalid withdrawTimestamp"
        );
        require(coinbase >= total, "Coinbase is not enough to withdraw");

        // payable(withdrawer).transfer(total);
        // token.transferFrom(address(this), withdrawer, total);
        token.transfer(withdrawer, total);

        delete stakers[withdrawer];
        emit Withdraw(
            withdrawer,
            staker.amount,
            staker.depositTimestamp,
            staker.apy,
            staker.apyTerm,
            reward
        );
    }

    function adminWithdraw(uint256 value) public onlyAdmin {
        // payable(msg.sender).transfer(value);
        token.transfer(admin, value);
    }

    function setPoolStatus2(uint256 _status) public onlyAdmin {
        if (_status == uint256(PoolStatus.LOCK)) {
            pStatus = PoolStatus.LOCK;
        } else if (_status == uint256(PoolStatus.OPEN)) {
            pStatus = PoolStatus.OPEN;
        }
    }

    function setPoolStatus(PoolStatus _status) public onlyAdmin {
        pStatus = _status;
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
