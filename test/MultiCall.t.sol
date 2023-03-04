// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "../src/MultiCall.sol";

contract MultiCallTest is DSTest {
  MultiCall multicall;

  function setUp() public {
    multicall = new MultiCall();
  }

  function testTryAggregate() public {
    MommyContract mommy = new MommyContract();
    MultiCall.Call[] memory calls = new MultiCall.Call[](2);
    calls[0] = MultiCall.Call({
      target: address(mommy),
      callData: abi.encodeWithSignature("isItMama()")
    });
    calls[1] = MultiCall.Call({
      target: address(mommy),
      callData: abi.encodeWithSignature("isItDaddy()")
    });
    bytes[] memory results = multicall.tryAggregate(true, calls);

    assert(abi.decode(results[0], (bool)));
    assert(!abi.decode(results[1], (bool)));
  }
}

// mock contract with a single function that always returns false
contract MommyContract {
  function isItMama() public returns (bool) {
    return true;
  }

  function isItDaddy() public returns (bool) {
    return false;
  }
}
