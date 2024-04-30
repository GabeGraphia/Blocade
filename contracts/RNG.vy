lockedTimestamp: public(HashMap[address, uint256])

event returnRandomNumber:
    number: uint256

#maps sender address to current block number
@external
def lock() -> bool:
    assert self.lockedTimestamp[msg.sender] == 0, "Number is already locked"
    self.lockedTimestamp[msg.sender] = block.number
    return True

#returns the block number that occured after 2 blocks 
#were mined from the original locked block number
@external
def unlock(numberRange: uint256) -> uint256:
    assert self.lockedTimestamp[msg.sender] > 0, "No number locked"
    assert self.lockedTimestamp[msg.sender] + 2 <= block.number, "Unlocking number too early"
    randomNumber: uint256 = convert(blockhash(self.lockedTimestamp[msg.sender] + 2), uint256) % numberRange
    self.lockedTimestamp[msg.sender] = 0
    assert self.lockedTimestamp[msg.sender] == 0, "Failed to unlock number"
    log returnRandomNumber(randomNumber)
    return randomNumber
