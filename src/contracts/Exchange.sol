pragma solidity ^0.5.0;

import "./Token.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

// TODO:
// [X] Set the fee account
// [ ]Deposit Ether
// [ ]Withdraw Ether
// [ ]Deposit Tokens
// [ ]Withdraw Tokens
// [ ]Check blances
// [ ]Make order
// [ ]Cancel order
// [ ]Fill order
// [ ]Charge Fees

contract Exchange {
	using SafeMath for uint;

	// Variables
	address public	feeAccount; // the account that receives exchange fees
	uint256 public feePercent; // the fee percentage
	address constant ETHER = address(0); // store Ether in tokens mapping with blank address
	mapping(address => mapping(address => uint256)) public tokens;

	// Events
	event Deposit(address token, address user, uint256 amount, uint256 balance);

	constructor (address _feeAccount, uint256 _feePercent) public {
		feeAccount = _feeAccount;
		feePercent = _feePercent;
	}

	function depositEther() payable public {
		tokens[ETHER][msg.sender] = tokens[_token][msg.sender].add(msg.value);
		emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
	}

	function depositToken(address _token, uint _amount) public {
		require(_token != ETHER);
		require(Token(_token).transferFrom(msg.sender, address(this), _amount));
		tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount);
		// Manage deposit - update balance
		emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);

	}

}

