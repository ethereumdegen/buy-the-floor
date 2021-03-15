pragma solidity ^0.5.0;


/**

Work in Progress

A decentralized exchange marketplace contract ERC721 tokens.

Need to:
1) allow deposit of ERC721 token with safeTransferFrom
2) allow for on-chain 'bids' and 'asks' orders (making) against any ERC20 [token type and amt]
3) allow for on-chain taking of said orders
*/

 
/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
 
 
 interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


/// @title ERC-721 Non-Fungible Token Standard
       /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
       ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
       interface ERC721 /* is ERC165 */ {
           /// @dev This emits when ownership of any NFT changes by any mechanism.
           ///  This event emits when NFTs are created (`from` == 0) and destroyed
           ///  (`to` == 0). Exception: during contract creation, any number of NFTs
           ///  may be created and assigned without emitting Transfer. At the time of
           ///  any transfer, the approved address for that NFT (if any) is reset to none.
           event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

           /// @dev This emits when the approved address for an NFT is changed or
           ///  reaffirmed. The zero address indicates there is no approved address.
           ///  When a Transfer event emits, this also indicates that the approved
           ///  address for that NFT (if any) is reset to none.
           event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

           /// @dev This emits when an operator is enabled or disabled for an owner.
           ///  The operator can manage all NFTs of the owner.
           event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

           /// @notice Count all NFTs assigned to an owner
           /// @dev NFTs assigned to the zero address are considered invalid, and this
           ///  function throws for queries about the zero address.
           /// @param _owner An address for whom to query the balance
           /// @return The number of NFTs owned by `_owner`, possibly zero
           function balanceOf(address _owner) external view returns (uint256);

           /// @notice Find the owner of an NFT
           /// @dev NFTs assigned to zero address are considered invalid, and queries
           ///  about them do throw.
           /// @param _tokenId The identifier for an NFT
           /// @return The address of the owner of the NFT
           function ownerOf(uint256 _tokenId) external view returns (address);

           /// @notice Transfers the ownership of an NFT from one address to another address
           /// @dev Throws unless `msg.sender` is the current owner, an authorized
           ///  operator, or the approved address for this NFT. Throws if `_from` is
           ///  not the current owner. Throws if `_to` is the zero address. Throws if
           ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
           ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
           ///  `onERC721Received` on `_to` and throws if the return value is not
           ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
           /// @param _from The current owner of the NFT
           /// @param _to The new owner
           /// @param _tokenId The NFT to transfer
           /// @param data Additional data with no specified format, sent in call to `_to`
           function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;

           /// @notice Transfers the ownership of an NFT from one address to another address
           /// @dev This works identically to the other function with an extra data parameter,
           ///  except this function just sets data to ""
           /// @param _from The current owner of the NFT
           /// @param _to The new owner
           /// @param _tokenId The NFT to transfer
           function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

           /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
           ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
           ///  THEY MAY BE PERMANENTLY LOST
           /// @dev Throws unless `msg.sender` is the current owner, an authorized
           ///  operator, or the approved address for this NFT. Throws if `_from` is
           ///  not the current owner. Throws if `_to` is the zero address. Throws if
           ///  `_tokenId` is not a valid NFT.
           /// @param _from The current owner of the NFT
           /// @param _to The new owner
           /// @param _tokenId The NFT to transfer
           function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

           /// @notice Set or reaffirm the approved address for an NFT
           /// @dev The zero address indicates there is no approved address.
           /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
           ///  operator of the current owner.
           /// @param _approved The new approved NFT controller
           /// @param _tokenId The NFT to approve
           function approve(address _approved, uint256 _tokenId) external payable;

           /// @notice Enable or disable approval for a third party ("operator") to manage
           ///  all of `msg.sender`'s assets.
           /// @dev Emits the ApprovalForAll event. The contract MUST allow
           ///  multiple operators per owner.
           /// @param _operator Address to add to the set of authorized operators.
           /// @param _approved True if the operator is approved, false to revoke approval
           function setApprovalForAll(address _operator, bool _approved) external;

           /// @notice Get the approved address for a single NFT
           /// @dev Throws if `_tokenId` is not a valid NFT
           /// @param _tokenId The NFT to find the approved address for
           /// @return The approved address for this NFT, or the zero address if there is none
           function getApproved(uint256 _tokenId) external view returns (address);

           /// @notice Query if an address is an authorized operator for another address
           /// @param _owner The address that owns the NFTs
           /// @param _operator The address that acts on behalf of the owner
           /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
           function isApprovedForAll(address _owner, address _operator) external view returns (bool);
       }

       interface ERC165 {
           /// @notice Query if a contract implements an interface
           /// @param interfaceID The interface identifier, as specified in ERC-165
           /// @dev Interface identification is specified in ERC-165. This function
           ///  uses less than 30,000 gas.
           /// @return `true` if the contract implements `interfaceID` and
           ///  `interfaceID` is not 0xffffffff, `false` otherwise
           function supportsInterface(bytes4 interfaceID) external view returns (bool);
       }

       interface ERC721TokenReceiver {
           /// @notice Handle the receipt of an NFT
           /// @dev The ERC721 smart contract calls this function on the
           /// recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
           /// of other than the magic value MUST result in the transaction being reverted.
           /// @notice The contract address is always the message sender.
           /// @param _operator The address which called `safeTransferFrom` function
           /// @param _from The address which previously owned the token
           /// @param _tokenId The NFT identifier which is being transferred
           /// @param _data Additional data with no specified format
           /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
           /// unless throwing
           function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
        }



contract OpenNFTExchange   {

 using SafeMath for uint;

  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
 
  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)

  event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
  event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
  event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
  event Deposit(address token, address user, uint amount, uint balance);
  event Withdraw(address token, address user, uint amount, uint balance);

   constructor() public {

  }

  //Do not allow ETH to enter
   function() external payable {
    revert();
  }


  function depositNFT() public returns (bool){
      
  }
  
  
  function withdrawNFT() public returns (bool){
      
  }
  
  //buyer places a bid on an NFT 
   function offerBid() public returns (bool){
      
  }
   function acceptBid() public returns (bool){
      
  }
  
  
   //seller offers an NFT for sale 
   function offerSale() public returns (bool){
      
  }
   function acceptSale() public returns (bool){
      
  }
  
  
  
  
}
