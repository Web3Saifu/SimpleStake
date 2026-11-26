import { QueryClient } from '@tanstack/react-query'
import { http } from 'viem'
import { foundry } from 'viem/chains'
import { createConfig } from 'wagmi'
import { injected } from 'wagmi/connectors'

export const anvil = { ...foundry, name: 'Local Anvil', rpcUrls: {
  default: { http: ['http://127.0.0.1:8545'] },
} } as const

export const walletConfig = createConfig({
  chains: [anvil],
  connectors: [injected({ target: 'metaMask' })],
  transports: { [anvil.id]: http(anvil.rpcUrls.default.http[0]) },
})

export const queryClient = new QueryClient()
