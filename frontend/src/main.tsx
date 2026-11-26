import { createRoot } from 'react-dom/client'
import App from './App'
import { WagmiProvider } from 'wagmi'
import { QueryClientProvider } from '@tanstack/react-query'
import { queryClient, walletConfig } from './wallet'
import './styles.css'

createRoot(document.getElementById('root')!).render(
  <WagmiProvider config={walletConfig}>
    <QueryClientProvider client={queryClient}><App /></QueryClientProvider>
  </WagmiProvider>,
)
