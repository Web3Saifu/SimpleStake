import { erc20Abi, formatUnits, isAddress, isAddressEqual, isHash, type Address, type PublicClient } from 'viem'

type TokenRecord = { address: string; transactionHash: string; blockHash: string }

export async function verifiedStk(client: PublicClient, chainId: number, token: TokenRecord) {
  if (chainId !== 31337 || await client.getChainId() !== chainId) {
    throw new Error('Check the local Anvil RPC network.')
  }
  const { address, transactionHash, blockHash } = token
  if (!isAddress(address) || !isHash(transactionHash) || !isHash(blockHash)) {
    throw new Error('Invalid STK deployment record.')
  }
  const [receipt, code] = await Promise.all([
    client.getTransactionReceipt({ hash: transactionHash }),
    client.getCode({ address }),
  ])
  if (receipt.status !== 'success' || !receipt.contractAddress || !isAddressEqual(receipt.contractAddress, address)
    || receipt.blockHash !== blockHash || !code || code === '0x') {
    throw new Error('STK deployment differs from the local record.')
  }
  const contract = { address, abi: erc20Abi } as const
  const [symbol, decimals] = await Promise.all([
    client.readContract({ ...contract, functionName: 'symbol' }),
    client.readContract({ ...contract, functionName: 'decimals' }),
  ])
  if (symbol !== 'STK' || decimals !== 18) throw new Error('Unexpected STK metadata.')
  return contract
}

export async function readStkBalance(client: PublicClient, account: Address, chainId: number, token: TokenRecord) {
  const contract = await verifiedStk(client, chainId, token)
  const balance = await client.readContract({ ...contract, functionName: 'balanceOf', args: [account] })
  return formatUnits(balance, 18)
}
