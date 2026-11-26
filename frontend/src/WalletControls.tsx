import { useConnect, useConnection, useConnectors, useDisconnect, useSwitchChain } from 'wagmi'
import { anvil } from './wallet'

export default function WalletControls() {
  const connection = useConnection()
  const connectors = useConnectors()
  const connect = useConnect()
  const disconnect = useDisconnect()
  const switchChain = useSwitchChain()
  const metaMask = connectors.find(c => c.id === 'io.metamask') ?? connectors.find(c => c.id === 'metaMask')
  const connected = connection.isConnected && !!connection.address
  const onAnvil = connection.chainId === anvil.id
  const error = connected ? switchChain.error ?? disconnect.error : connect.error
  const missing = error?.name === 'ProviderNotFoundError'
  const rejected = error?.name === 'UserRejectedRequestError'

  return (
    <section className="wallet" aria-label="Wallet connection">
      {connected ? <>
        <span title={connection.address}>{connection.address?.slice(0, 6)}…{connection.address?.slice(-4)}</span>
        <span>{onAnvil ? 'Local Anvil' : `Wrong network (chain ${connection.chainId})`}</span>
        {!onAnvil && <button disabled={switchChain.isPending} onClick={() => switchChain.mutate({ chainId: anvil.id })}>Switch to Anvil</button>}
        <button disabled={disconnect.isPending} onClick={() => {
          connect.reset()
          switchChain.reset()
          disconnect.mutate({})
        }}>Disconnect</button>
      </> : <button disabled={!metaMask || connect.isPending || connection.isReconnecting}
        onClick={() => metaMask && connect.mutate({ connector: metaMask })}>
        {connect.isPending ? 'Connecting…' : 'Connect MetaMask'}
      </button>}
      {error && <span role="status">{missing ? 'Enable MetaMask in this browser and try again.'
        : rejected ? 'Request declined in MetaMask.' : 'Wallet request failed. Check MetaMask and try again.'}</span>}
    </section>
  )
}
