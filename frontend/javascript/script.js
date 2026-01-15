const API_URL = (window.API_URL || 'https://p3rgl40yd7.execute-api.us-east-1.amazonaws.com')
  .replace(/\/$/, '');
const form = document.getElementById("transaction-form");
const list = document.getElementById("list");
const balanceEl = document.getElementById("balance");

let balance = 0;

async function loadTransactions() {
  try {
    const response = await fetch(`${API_URL}/transactions`);
    if (!response.ok) throw new Error('Failed to load transactions');
    const transactions = await response.json();
    renderTransactions(transactions);
  } catch (error) {
    console.error('Error loading transactions:', error);
  }
}

function renderTransactions(transactions) {
  list.innerHTML = '';
  balance = 0;

  transactions.forEach(tx => {
    const item = document.createElement("div");
    item.classList.add("item", tx.type);
    item.dataset.sk = tx.sk; 

    const sign = tx.type === "income" ? "+" : "-";
    const value = tx.type === "income" ? tx.amount : -tx.amount;

    item.innerHTML = `
      <div>
        <strong>${tx.description}</strong>
        <div class="category">${tx.category || 'Other'}</div>
      </div>
      <div class="right">
        <span class="amount ${tx.type}">${sign} $${tx.amount}</span>
        <button class="delete">×</button>
      </div>
    `;

    const deleteBtn = item.querySelector(".delete");
    deleteBtn.addEventListener("click", async () => {
      try {
        const encodedSk = encodeURIComponent(tx.sk);

        const response = await fetch(
          `${API_URL}/transactions/${encodedSk}`,
          { method: 'DELETE' }
        );

        if (!response.ok) throw new Error('Failed to delete');
        loadTransactions();
      } catch (error) {
        console.error('Error deleting transaction:', error);
      }
    });


    list.appendChild(item);
    balance += value;
  });

  balanceEl.textContent = `$${balance}`;
}

async function handleSubmit(e) {
  e.preventDefault();

  const description = document.getElementById("description").value;
  const amount = Number(document.getElementById("amount").value);
  const category = document.getElementById("category").value;
  const type = document.getElementById("type").value;

  const transaction = { description, amount, category, type };

  try {
    const response = await fetch(`${API_URL}/transactions`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(transaction)
    });
    if (!response.ok) throw new Error('Failed to create transaction');
    loadTransactions();
  } catch (error) {
    console.error('Error creating transaction:', error);
  }

  form.reset();
}

form.addEventListener("submit", handleSubmit);

window.addEventListener('load', loadTransactions);