import { useQuery } from '@tanstack/react-query'
import { useConnection, usePublicClient } from 'wagmi'
import deployment from '../../deployments/31337.json'
import { readStkBalance } from './stk'
import { anvil } from './wallet'

export default function WalletBalance() {
  const { address, chainId, isConnected } = useConnection()
  const client = usePublicClient({ chainId: anvil.id })
  const token = deployment.tokens.STK
  const result = useQuery({
    queryKey: ['stk-balance', chainId, token.address, token.transactionHash, token.blockHash, address],
    enabled: isConnected && !!address && chainId === anvil.id && !!client,
    queryFn: () => readStkBalance(client!, address!, deployment.chainId, token),
    retry: false,
  })

  let content
  if (!isConnected || !address) content = 'Connect your wallet to see your balance.'
  else if (chainId !== anvil.id) content = 'Switch to Local Anvil to see your balance.'
  else if (result.isError) content = <>Balance unavailable. Check Anvil and the STK deployment. <button onClick={() => void result.refetch()}>Retry</button></>
  else if (result.data === undefined) content = 'Reading balance…'
  else content = <>{result.data} STK <button disabled={result.isFetching} onClick={() => void result.refetch()}>Refresh</button></>

  return <section aria-label="Wallet balance"><h2>Wallet balance</h2><p role="status">{content}</p></section>
}
