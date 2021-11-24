// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.9;

import "../staking/IApplication.sol";
import "../staking/TokenStaking.sol";
import "../token/T.sol";

/// @title StableYield+ Inflation Mechanism
/// @notice TODO (arj)
contract StableYield {

    uint256 SECONDS_PER_DAY = 24 * 60 * 60;

    T public immutable token;
    TokenStaking public immutable staking;

    mapping (uint256 => uint96) dailyIssuance;

    constructor(T _token, TokenStaking _staking) {
        token = _token;
        staking = _staking;
    }

    function distributeDailyIssuance()
        public
    {
        uint16 today = getCurrentDay();
        require(
            dailyIssuance[today] == 0,
            "Rewards already distributed today"
        );

        uint256 nApplications = staking.getApplicationsLength();
        uint96 todaysIssuance = 0;
        for(uint256 i=0; i<nApplications; i++){
            IApplication application = IApplication(staking.applications(i));
            uint96 applicationIssuance = dailyIssuanceForApplication(application);
            todaysIssuance += applicationIssuance;
            token.transferFrom(foo, application, applicationIssuance);
            application.distributeRewards(applicationIssuance);
        }
        dailyIssuance[today] = todaysIssuance;
    }

    /// @notice Calculate the daily issuance figure for an application, based
    ///         on the total supply and the number of tokens authorized to the
    ///         application in question.
    /// @param application Address of the application
    function dailyIssuanceForApplication(IApplication application)
        public
        view
        returns (uint96)
    {
        uint256 totalSupply = token.totalSupply();
        uint96 authorizedTokens = application.totalAuthorized();
        // TODO
        return uint96(totalSupply + authorizedTokens);
    }

    /// @notice Index of current day, assuming days last exactly 86,400 seconds
    function getCurrentDay() public view returns (uint16) {
        return uint16(block.timestamp / SECONDS_PER_DAY);
    }
}
