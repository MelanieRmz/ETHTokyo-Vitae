// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import {ICollectModule} from '../../../interfaces/ICollectModule.sol';
import {ModuleBase} from '../ModuleBase.sol';
import {FollowValidationModuleBase} from '../FollowValidationModuleBase.sol';


interface IProtocolsData 
{
    function turnToMember() external;
}


/**
 * @title FreeCollectModule
 * @author Lens Protocol
 *
 * @notice This is a simple Lens CollectModule implementation, inheriting from the ICollectModule interface.
 *
 * This module works by allowing all collects.
 */
contract sbtCollectModule is FollowValidationModuleBase, ICollectModule 
{
    address public protocolDataContractInterfaceAddress;

    constructor(address hub, address paramProtocolsDataAddress) ModuleBase(hub) 
    {
        protocolDataContractInterfaceAddress = paramProtocolsDataAddress; 
    }

    /**
     * @dev There is nothing needed at initialization.
     */
    function initializePublicationCollectModule(uint256 profileId, uint256 pubId, bytes calldata data ) external override onlyHub returns (bytes memory) 
    {
        //NOTHING TO DO ON INITIALIZATION.///
        return data;
    }

    /**
     * @dev Processes a collect by:
     *  1. Ensuring the collector is a follower, if needed
     */
    function processCollect(uint256 referrerProfileId, address collector, uint256 profileId, uint256 pubId, bytes calldata data) external override 
    {
        IProtocolsData(protocolDataContractInterfaceAddress).turnToMember();
    }
}