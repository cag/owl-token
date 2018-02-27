pragma solidity ^0.4.18;


/// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
/// @author Stefan George - <stefan@gnosis.pm>
contract ProxyMaster {
    address masterCopy;

    /// @dev Constructor function sets address of master copy contract.
    /// @param _masterCopy Master copy address.
    function ProxyMaster(address _masterCopy)
        public
    {
        require(_masterCopy != 0);
        masterCopy = _masterCopy;
    }

    /// @dev Fallback function forwards all transactions and returns all received return data.
    function ()
        external
        payable
    {
        address _masterCopy = masterCopy;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let success := delegatecall(not(0), _masterCopy, 0, calldatasize(), 0, 0)
            let rds := returndatasize()
            returndatacopy(0, 0, rds)
            switch success
            case 0 { revert(0, rds) }
            default { return(0, rds) }
        }
    }
}

contract ProxiedMaster {
    address masterCopy;
}
