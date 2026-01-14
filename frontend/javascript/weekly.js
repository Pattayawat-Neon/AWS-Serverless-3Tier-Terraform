const weekPicker = document.getElementById("weekPicker");
const list = document.getElementById("list");
const incomeEl = document.getElementById("income");
const expenseEl = document.getElementById("expense");
const balanceEl = document.getElementById("balance");

const mockData = [
  { description: "Salary", amount: 500, type: "income" },
  { description: "Food", amount: 120, type: "expense" },
  { description: "Transport", amount: 60, type: "expense" }
];

function render(data) {
  list.innerHTML = "";
  let income = 0;
  let expense = 0;

  data.forEach(t => {
    const item = document.createElement("div");
    item.className = "item";

    item.innerHTML = `
      <span>${t.description}</span>
      <span class="amount ${t.type}">
        ${t.type === "income" ? "+" : "-"}$${t.amount}
      </span>
    `;

    list.appendChild(item);

    if (t.type === "income") income += t.amount;
    else expense += t.amount;
  });

  incomeEl.textContent = `$${income}`;
  expenseEl.textContent = `$${expense}`;
  balanceEl.textContent = `$${income - expense}`;
}

weekPicker.addEventListener("change", () => {
  // later: fetch from backend by week
  render(mockData);
});

render(mockData);