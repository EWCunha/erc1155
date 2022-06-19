// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract ERC1155 {
    // Mapping from TokenID to account balances (tokenID => account address => balance)
    mapping(uint256 => mapping(address => uint256)) internal balances;
    // Mapping from account to operator approvals (owner address => operator address => is approved or not?)
    mapping(address => mapping(address => bool)) private operatorApprovals;

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );
    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _amount
    );
    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );

    // Gets the balance of an account's tokens
    function balanceOf(address _account, uint256 _id)
        public
        view
        returns (uint256)
    {
        require(_account != address(0), "Address is zero");
        return balances[_id][_account];
    }

    // Gets the balance of multiple accounts' tokens
    function balanceOfBatch(address[] memory _accounts, uint256[] memory _ids)
        public
        view
        returns (uint256[] memory)
    {
        require(
            _accounts.length == _ids.length,
            "Accounts and ids are not the same length"
        );
        uint256[] memory batchBalances = new uint256[](_accounts.length);

        for (uint256 i = 0; i < _accounts.length; i++) {
            batchBalances[i] = balanceOf(_accounts[i], _ids[i]);
        }

        return batchBalances;
    }

    // Checks if an address is an operator for another address
    function isApprovedForAll(address _account, address _operator)
        public
        view
        returns (bool)
    {
        return operatorApprovals[_account][_operator];
    }

    // Enables or disables an operator to manage all of msg.sender's assets
    function setApprovalForAll(address _operator, bool _approved) public {
        operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    //
    function transfer(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount
    ) private {
        uint256 fromBalance = balances[_id][_from];
        require(fromBalance >= _amount, "Insufficient balance,");
        balances[_id][_from] = fromBalance - _amount;
        balances[_id][_to] += _amount;
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount //, bytes memory data
    ) public virtual {
        require(
            _from == msg.sender || isApprovedForAll(_from, msg.sender),
            "Msg.sender is not the owner or approved for transfer"
        );
        require(_to != address(0), "Address is zero");
        transfer(_from, _to, _id, _amount);
        emit TransferSingle(msg.sender, _from, _to, _id, _amount);
        require(checkOnERC1155Received(), "Receiver is not implemented");
    }

    function checkOnERC1155Received() private pure returns (bool) {
        // Oversimplified version
        return true;
    }

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts // bytes memory _data
    ) public {
        require(
            _from == msg.sender || isApprovedForAll(_from, msg.sender),
            "Msg.sender is not the owner or approved for transfer"
        );
        require(_to != address(0), "Address is zero");
        require(
            _ids.length == _amounts.length,
            "Ids and amounts are not the same"
        );
        for (uint256 i = 0; i < _ids.length; i++) {
            uint256 id = _ids[i];
            uint256 amount = _amounts[i];

            transfer(_from, _to, id, amount);
        }

        emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
        require(checkOnBatchERC1155Received(), "Receiver is not implemented");
    }

    function checkOnBatchERC1155Received() private pure returns (bool) {
        // Oversimplified version
        return true;
    }

    // ERC165 compliant
    // Tell everyone that we support the ERC1155 functions
    // interfaceId == 0xd9b67a26
    function supportsInterface(bytes4 _interfaceId)
        public
        pure
        virtual
        returns (bool)
    {
        return _interfaceId == 0xd9b67a26;
    }
}
