// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

abstract contract Context {
    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender); // added payable
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

//an example of the base anatomy of most token contracts out there, which move billions of $
abstract contract ERC20 is Context {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;
  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply = 0;
  uint8 private _decimals = 18;
  string private _symbol;
  string private _name;

  event Transfer(
      address indexed from,
      address indexed to,
      uint256 value
  );

  event Approval(
      address indexed owner,
      address indexed spender,
      uint256 value
  );

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8) {
    return _decimals;
  }

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory) {
    return _name;
  }

  /**
   * @dev See {BEP20-totalSupply}.
   */
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev See {BEP20-balanceOf}.
   */
  function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
  }

  /**
   * @dev See {BEP20-transfer}.
   *
   * Requirements:
   *
   * - `recipient` cannot be the zero address.
   * - the caller must have a balance of at least `amount`.
   */
  function transfer(address recipient, uint256 amount) external returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  /**
   * @dev See {BEP20-allowance}.
   */
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev See {BEP20-approve}.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function approve(address spender, uint256 amount) external returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  /**
   * @dev See {BEP20-transferFrom}.
   *
   * Emits an {Approval} event indicating the updated allowance. This is not
   * required by the EIP. See the note at the beginning of {BEP20};
   *
   * Requirements:
   * - `sender` and `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   * - the caller must have allowance for `sender`'s tokens of at least
   * `amount`.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
    return true;
  }

  /**
   * @dev Atomically increases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  /**
   * @dev Atomically decreases the allowance granted to `spender` by the caller.
   *
   * This is an alternative to {approve} that can be used as a mitigation for
   * problems described in {BEP20-approve}.
   *
   * Emits an {Approval} event indicating the updated allowance.
   *
   * Requirements:
   *
   * - `spender` cannot be the zero address.
   * - `spender` must have allowance for the caller of at least
   * `subtractedValue`.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
    return true;
  }

  /**
   * @dev Moves tokens `amount` from `sender` to `recipient`.
   *
   * This is internal function is equivalent to {transfer}, and can be used to
   * e.g. implement automatic token fees, slashing mechanisms, etc.
   *
   * Emits a {Transfer} event.
   *
   * Requirements:
   *
   * - `sender` cannot be the zero address.
   * - `recipient` cannot be the zero address.
   * - `sender` must have a balance of at least `amount`.
   */
  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(recipient != address(0), "BEP20: transfer to the zero address");

    _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
   * the total supply.
   *
   * Emits a {Transfer} event with `from` set to the zero address.
   *
   * Requirements
   *
   * - `to` cannot be the zero address.
   */
  function _mint(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: mint to the zero address");

    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`, reducing the
   * total supply.
   *
   * Emits a {Transfer} event with `to` set to the zero address.
   *
   * Requirements
   *
   * - `account` cannot be the zero address.
   * - `account` must have at least `amount` tokens.
   */
  function _burn(address account, uint256 amount) internal {
    require(account != address(0), "BEP20: burn from the zero address");

    _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }

  /**
   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
   *
   * This is internal function is equivalent to `approve`, and can be used to
   * e.g. set automatic allowances for certain subsystems, etc.
   *
   * Emits an {Approval} event.
   *
   * Requirements:
   *
   * - `owner` cannot be the zero address.
   * - `spender` cannot be the zero address.
   */
  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  /**
   * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
   * from the caller's allowance.
   *
   * See {_burn} and {_approve}.
   */
  function _burnFrom(address account, uint256 amount) internal {
    _burn(account, amount);
    _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
  }
}

import "./libs/Pool.sol";
import "./libs/SafeMath.sol";

abstract contract PoolMgmt is ERC20 {
    using SafeMath for uint256;

    address public UNISWAP_ROUTER = address(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
    address public UNISWAP_PAIR;

    //the purpose of this function is to add liquidity to the UniswapV2 liquidity pool
    function addLiquidity(uint256 amountEth) internal {

        //check if there is a pool already
        if(!Pool.hasPoolBeenCreated(UNISWAP_ROUTER, address(this))) {
            //and create one if this is the first time
            //notice that we set the UNISWAP_PAIR address so we can use it as reference
            UNISWAP_PAIR = Pool.createPool(UNISWAP_ROUTER, address(this));
        }

        //we need to get the reserves in the pool, so we can calculate the correct ratios of ether to token to add to the pool
        (uint256 tokenAmount, uint256 etherAmount) = Pool.getPoolReserves(address(this), UNISWAP_PAIR);

        //if the etherAmount is 0, it means that nothing has been added to the pool yet, and this is the first time
        if(etherAmount == 0) {
            //since this is the first time, let's add tokens at the base ratio of 1 ETH to 100000 tokens
            uint256 tokensToMint = amountEth.mul(100000);

            //the contract self mints the tokens it needs
            _mint(address(this), tokensToMint);

            //it approves the uniswap_router address as a spender
            _approve(address(this), UNISWAP_ROUTER, tokensToMint);

            //and then it adds both eth and token to the pool, establishing the base exchange rate
            Pool.addLiquidityETH(address(this), address(0x0), UNISWAP_ROUTER, tokensToMint, amountEth, block.timestamp + 2 hours);
        }
        else {
            uint256 tokensToMint = amountEth.mul(tokenAmount).div(etherAmount);
            _mint(address(this), tokensToMint);

            _approve(address(this), UNISWAP_ROUTER, tokensToMint);
            Pool.addLiquidityETH(address(this), address(0x0), UNISWAP_ROUTER, tokensToMint, amountEth, block.timestamp + 2 hours);
        }
    }

}

abstract contract PaymentsHelper is PoolMgmt {
    bool isTransferLocked = false;
    modifier lock() {
        require(!isTransferLocked, "Reentrancy blocked");
        isTransferLocked = true;
        _;
        isTransferLocked = false;
    }
}



contract ERC20WithPool is PaymentsHelper {
    using SafeMath for uint256;

    uint256 public purchasePower = 100000;
    uint256 public amountSold = 0;

    //it should be 1e18 (1ETH / 1BNB etc). We use 1 thousandth of it for testing purposes
    uint256 public purchasePrice = 1e15;

    //Default implementations for receive and fallback
    receive() external payable { }
    fallback() external payable { }


    //this is an example of a token sale with pool interaction
    //to buy, the buyer has to provide exactly 1 native currency amount, i.e. 1 ETH, or 1 BNB, etc
    //Everytime there is a buy, purchase power is reduced by 10% from its previous value
    //half of the amount received is used to increase the pool liquidity
    //half is used to buy from the pool, thus raising the token price
    function buyToken() external payable lock {
        require(msg.value == purchasePrice, "Wrong ether amount sent");
        
        _mint(msg.sender, purchasePower);
        amountSold = amountSold.add(purchasePower);
        
        //deduct 10% from the purchase power
        purchasePower = purchasePower.sub(purchasePower.div(10));

        //50% to increase pool depth
        addLiquidity(msg.value.div(2));

        //50% to buy from the pool and burn the tokens
        //we transfer the receiving tokens to the zero dead address for simplification
        Pool.swapEthForTokens(msg.value.div(2), address(0x000000000000000000000000000000000000dEaD), IUniswapV2Router02(UNISWAP_ROUTER).WETH(), address(this), UNISWAP_ROUTER, block.timestamp + 2 hours);
    }

    
}