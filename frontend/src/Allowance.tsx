import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { BaseError, UserRejectedRequestError, formatUnits, maxUint256, parseUnits, type Address, type Hash } from 'viem'
import { useConnection, usePublicClient, useWriteContract } from 'wagmi'
import deployment from '../../deployments/31337.json'
import { verifiedStk } from './stk'
import { anvil } from './wallet'

const bob = '0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc'
const token = deployment.tokens.STK

export default function Allowance() {
  const { address, chainId, isConnected } = useConnection()
  if (!isConnected || !address || chainId !== anvil.id) return null
  return <ApprovalForm key={address} owner={address} />
}

function ApprovalForm({ owner }: { owner: Address }) {
  const client = usePublicClient({ chainId: anvil.id })!
  const writer = useWriteContract()
  const [input, setInput] = useState('')
  const [message, setMessage] = useState('')
  const [hash, setHash] = useState<Hash>()
  const [busy, setBusy] = useState(false)
  const [uncertain, setUncertain] = useState(false)

  async function read() {
    const contract = await verifiedStk(client, deployment.chainId, token)
    const current = await client.readContract({ ...contract, functionName: 'allowance', args: [owner, bob] })
    return { contract, current }
  }

  const allowance = useQuery({ queryKey: ['allowance', anvil.id, token.blockHash, token.address, owner, bob], queryFn: read, retry: false })
  const amount = /^\d{1,78}(\.\d{1,18})?$/.test(input) ? parseUnits(input, 18) : undefined
  const valid = amount !== undefined && amount < maxUint256
  const mustRevoke = !!allowance.data?.current && amount !== 0n

  async function confirm(tx: Hash) {
    try {
      const receipt = await client.waitForTransactionReceipt({ hash: tx })
      setUncertain(false)
      setMessage(receipt.status === 'success' ? 'Approval confirmed.' : 'Approval reverted.')
      await allowance.refetch()
    } catch {
      setUncertain(true)
      setMessage('Submitted. Receipt unavailable.')
    }
  }

  async function approve() {
    if (!valid || busy || uncertain) return
    setBusy(true)
    setHash(undefined)
    setMessage('Checking approval…')
    try {
      const { contract, current } = await read()
      if (current && amount !== 0n) {
        setMessage('Revoke the existing allowance first.')
        await allowance.refetch()
        return
      }
      const { request } = await client.simulateContract({ ...contract, account: owner, functionName: 'approve', args: [bob, amount] })
      setMessage('Confirm in your wallet.')
      const tx = await writer.mutateAsync({ ...request, chainId: anvil.id })
      setHash(tx)
      setMessage('Submitted. Waiting for confirmation…')
      await confirm(tx)
    } catch (error) {
      const rejected = error instanceof BaseError && error.walk(e => e instanceof UserRejectedRequestError) instanceof UserRejectedRequestError
      setMessage(rejected ? 'Request declined.' : 'Approval request failed. Check wallet and deployment.')
    } finally {
      setBusy(false)
    }
  }

  return <section className="entry allowance">
    <h2>STK allowance</h2>
    <p>Local test spender (Bob): <code>{bob}</code></p>
    <p>Approval lets Bob spend up to this amount from your wallet.</p>
    <p>{allowance.isError ? 'Allowance unavailable.' : allowance.data ? 'Current allowance: ' + formatUnits(allowance.data.current, 18) + ' STK' : 'Reading allowance…'}
      {' '}<button disabled={busy || allowance.isFetching} onClick={() => void allowance.refetch()}>Refresh allowance</button></p>
    <label htmlFor="approval">New allowance in STK (0 to revoke)</label>
    <div className="field"><input id="approval" value={input} inputMode="decimal" onChange={e => setInput(e.target.value)} /></div>
    {input && !valid && <p>Enter a finite token amount with up to 18 decimal places.</p>}
    {mustRevoke && <p>Enter 0 to revoke before setting another allowance.</p>}
    <button disabled={!valid || mustRevoke || !allowance.isSuccess || busy || uncertain} onClick={approve}>{amount === 0n ? 'Revoke allowance' : 'Approve allowance'}</button>
    <p role="status">{message} {hash && <code>{hash}</code>}</p>
    {uncertain && hash && <button disabled={busy} onClick={async () => { setBusy(true); try { await confirm(hash) } finally { setBusy(false) } }}>Check receipt</button>}
  </section>
}
