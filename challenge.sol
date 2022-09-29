
//build a contract that is ERC20 based where
//trading has fixed 10% buy and sell taxes
    //the transferFrom method needs to see if the origin address or the destination address is the uniswap pool pair address
    //if so, it constitutes a buy or sell, respectively
    //buy taxes transfer tokens to the contract creator
    //sell taxes increase the pool liquidity, by selling half the tokens in exchange for the other pair, and filling the pool
//fresh tokens can be bought with the native currency (BNB)
    //the emission of tokens needs to be reduced in some way, to promote adoption
    //received BNB should be used to increase the liquidity pool
    //to buy from the pool
    //and to transfer to the contract owner