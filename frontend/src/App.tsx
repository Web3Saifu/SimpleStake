import { useState } from 'react'
import WalletControls from './WalletControls'
import WalletBalance from './WalletBalance'
import Allowance from './Allowance'

function AmountPreview({ amount }: { amount: string }) {
  return (
    <aside className="preview" aria-labelledby="preview-title">
      <div className="token-symbol" aria-hidden="true">S</div>
      <h2 id="preview-title">Draft preview</h2>
      <output htmlFor="amount">{amount || '0'} <small>STK</small></output>
    </aside>
  )
}

export default function App() {
  const [amount, setAmount] = useState('')
  const valid = /^\d*(?:\.\d{0,18})?$/.test(amount) && amount !== '.'

  return (
    <>
      <header><span className="brand-mark" aria-hidden="true">S</span>SimpleStake<WalletControls /></header>
      <main>
        <h1>Stake draft</h1>
        <p className="intro">Enter an amount to preview your stake.</p>
        <WalletBalance />
        <Allowance />
        <div className="workspace">
          <section className="entry">
            <label htmlFor="amount">Stake amount</label>
            <div className="field">
              <input id="amount" inputMode="decimal" placeholder="0.0" autoComplete="off"
                value={amount} onChange={event => setAmount(event.target.value)}
                aria-invalid={!valid} aria-describedby="amount-help" />
              <span>STK</span>
            </div>
            <p id="amount-help">{valid ? 'This draft stays in your browser.' : 'Enter a decimal amount with up to 18 decimal places.'}</p>
            <button type="button" disabled={!amount} onClick={() => setAmount('')}>Clear amount</button>
          </section>
          <AmountPreview amount={valid ? amount : '—'} />
        </div>
      </main>
    </>
  )
}
