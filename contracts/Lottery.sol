//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase {
    uint120 public entryFee = 20 * (10**18); //20 dollars
    address payable[] participants;
    string[] private timeStamps;
    string[] private names;
    mapping(address => bool) joined;
    AggregatorV3Interface internal priceFeed;
    enum State {
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }
    State public lottery_state;
    uint256 public randomness;
    uint256 public fee;
    bytes32 public keyhash;

    constructor(
        address priceFeedAddress,
        address _vrfCoordinator,
        address _link,
        uint256 _fee,
        bytes32 _keyhash
    ) public VRFConsumerBase(_vrfCoordinator, _link) {
        priceFeed = AggregatorV3Interface(priceFeedAddress);
        lottery_state = State.CLOSED;
        fee = _fee;
        keyhash = _keyhash;
    }

    function getEntryFee() public view returns (uint256) {
        int256 price = getLatestPrice(); //result is in 8 decimal places
        uint256 correctPrice = uint256(price) * (10**10); // converted to 18 decimal places
        uint256 fee = (entryFee * (10**18)) / correctPrice;
        return fee;
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    function getParticipants()
        public
        view
        returns (string[] memory, string[] memory)
    {
        return (names, timeStamps);
    }

    function checkLotteryJoined() public view returns (bool) {
        return joined[msg.sender];
    }

    function checkLotteryIsOpen() public view returns (bool) {
        if (lottery_state == State.OPEN) {
            return true;
        } else {
            return false;
        }
    }

    function enterLottery(string memory timeStamp, string memory name)
        public
        payable
    {
        require(
            lottery_state == State.OPEN,
            "Currently, we are not accepting entries"
        );
        require(
            msg.value == getEntryFee(),
            "Pay the exact entry fee to join lottery"
        );
        participants.push(payable(msg.sender));
        timeStamps.push(timeStamp);
        names.push(name);
        joined[msg.sender] = true;
    }

    function startLottery() public {
        lottery_state = State.OPEN;
    }

    function endLottery() public {
        lottery_state = State.CALCULATING_WINNER;
        bytes32 requestId = requestRandomness(keyhash, fee);
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
        internal
        override
    {
        require(
            lottery_state == State.CALCULATING_WINNER,
            "You aren't there yet!"
        );
        require(_randomness > 0, "random-not-found");
        uint256 indexOfWinner = _randomness % participants.length;
        address payable recentWinner = participants[indexOfWinner];
        recentWinner.transfer(address(this).balance);
        // Reset
        for (uint256 i = 0; i < participants.length; i++) {
            joined[participants[i]] = false;
        }
        participants = new address payable[](0);
        timeStamps = new string[](0);
        names = new string[](0);
        lottery_state = State.CLOSED;
        randomness = _randomness;
    }
}
