// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract MultiCall {
  struct Call {
    address target;
    bytes callData;
  }

  function tryAggregate(
    bool requireSuccess,
    Call[] memory calls
  ) external returns (bytes[] memory results) {
    results = new bytes[](calls.length);

    for (uint256 i = 0; i < calls.length; i++) {
      (bool success, bytes memory result) = calls[i].target.call(
        calls[i].callData
      );

      if (requireSuccess) {
        require(success, "Multicall: call failed");
      }

      results[i] = result;
    }
  }
}
