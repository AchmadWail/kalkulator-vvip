import os
import json

base_path = r"c:\Users\MY ASUS\kalkulator_vvip\web_app"

files = {
    "index.html": """<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kalkulator VVIP</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/calculator.css">
    <link rel="stylesheet" href="css/history.css">
    <link rel="stylesheet" href="css/currency.css">
    <link rel="stylesheet" href="css/unit.css">
    <link rel="stylesheet" href="css/vault.css">
    <link rel="stylesheet" href="css/payment.css">
    <link rel="stylesheet" href="css/modal.css">
</head>
<body class="dark-theme">
    <div id="app">
        <!-- Navbar -->
        <nav class="navbar capsule-nav">
            <div class="nav-left">
                <button class="icon-btn" onclick="showInfo()"><img src="../assets/icons/icon_question.svg" alt="Info"></button>
            </div>
            <div class="nav-right capsule-group">
                <button class="icon-btn" onclick="navigateTo('#/history')"><img src="../assets/icons/icon_clock.svg" alt="History"></button>
                <button class="icon-btn" onclick="navigateTo('#/currency')"><img src="../assets/icons/icon_dollar.svg" alt="Currency"></button>
                <button class="icon-btn" onclick="navigateTo('#/unit')"><img src="../assets/icons/icon_ruler.svg" alt="Unit"></button>
            </div>
        </nav>

        <!-- Main Content -->
        <main id="main-content">
        </main>
    </div>

    <!-- Info Modal -->
    <div id="info-modal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeInfo()">&times;</span>
            <h2>Informasi VIP</h2>
            <p>Masukkan kode rahasia untuk mengakses Vault:</p>
            <ul>
                <li><strong>1+1=</strong> : Akses Vault Gratis (Lihat Saja)</li>
                <li><strong>99+99=</strong> : Akses Vault VIP (Akses Penuh)</li>
            </ul>
        </div>
    </div>

    <script src="js/app.js"></script>
    <script src="js/calculator/calculator.js"></script>
    <script src="js/calculator/secretDetector.js"></script>
    <script src="js/history/history.js"></script>
    <script src="js/currency/currencyConverter.js"></script>
    <script src="js/unit/unitConverter.js"></script>
    <script src="js/vault/vault.js"></script>
    <script src="js/payment/payment.js"></script>
</body>
</html>""",

    "pages/calculator.html": """
<div class="calculator-container">
    <div class="display">
        <div class="preview" id="preview-display"></div>
        <div class="result" id="main-display">0</div>
    </div>
    <div class="keypad">
        <button class="btn btn-gray" onclick="appendInput('AC')">AC</button>
        <button class="btn btn-gray" onclick="appendInput('⌫')">⌫</button>
        <button class="btn btn-gray" onclick="appendInput('%')">%</button>
        <button class="btn btn-orange" onclick="appendInput('÷')">÷</button>
        
        <button class="btn btn-dark" onclick="appendInput('7')">7</button>
        <button class="btn btn-dark" onclick="appendInput('8')">8</button>
        <button class="btn btn-dark" onclick="appendInput('9')">9</button>
        <button class="btn btn-orange" onclick="appendInput('×')">×</button>
        
        <button class="btn btn-dark" onclick="appendInput('4')">4</button>
        <button class="btn btn-dark" onclick="appendInput('5')">5</button>
        <button class="btn btn-dark" onclick="appendInput('6')">6</button>
        <button class="btn btn-orange" onclick="appendInput('-')">-</button>
        
        <button class="btn btn-dark" onclick="appendInput('1')">1</button>
        <button class="btn btn-dark" onclick="appendInput('2')">2</button>
        <button class="btn btn-dark" onclick="appendInput('3')">3</button>
        <button class="btn btn-orange" onclick="appendInput('+')">+</button>
        
        <button class="btn btn-dark btn-zero" onclick="appendInput('0')">0</button>
        <button class="btn btn-dark" onclick="appendInput('.')">.</button>
        <button class="btn btn-orange" onclick="appendInput('=')">=</button>
    </div>
</div>
""",

    "pages/history.html": """
<div class="page-container">
    <div class="header">
        <h2>Riwayat</h2>
        <button onclick="clearHistory()" class="btn-text" style="color: red;">Hapus Semua</button>
    </div>
    <div id="history-list"></div>
    <button onclick="navigateTo('#/')" class="btn-text mt-4">Kembali ke Kalkulator</button>
</div>
""",

    "pages/currency.html": """
<div class="page-container">
    <h2>Konverter Valuta</h2>
    <div class="converter-box mt-4">
        <input type="number" id="curr-input" value="1" oninput="convertCurrency()">
        <div class="row mt-4">
            <select id="curr-from" onchange="convertCurrency()"></select>
            <button class="icon-btn" onclick="swapCurrency()">⇄</button>
            <select id="curr-to" onchange="convertCurrency()"></select>
        </div>
        <div class="result-box mt-4">
            <span class="preview">Hasil:</span>
            <div id="curr-result" class="result">0</div>
        </div>
    </div>
    <button onclick="navigateTo('#/')" class="btn-text mt-4">Kembali</button>
</div>
""",

    "pages/unit.html": """
<div class="page-container">
    <h2>Konverter Satuan</h2>
    <div class="tabs mt-4">
        <button class="tab-btn active" onclick="setUnitCategory('Panjang')">Panjang</button>
        <button class="tab-btn" onclick="setUnitCategory('Berat')">Berat</button>
        <button class="tab-btn" onclick="setUnitCategory('Suhu')">Suhu</button>
    </div>
    <div class="converter-box mt-4">
        <input type="number" id="unit-input" value="1" oninput="convertUnit()">
        <div class="row mt-4">
            <select id="unit-from" onchange="convertUnit()"></select>
            <button class="icon-btn" onclick="swapUnit()">⇄</button>
            <select id="unit-to" onchange="convertUnit()"></select>
        </div>
        <div class="result-box mt-4">
            <span class="preview">Hasil:</span>
            <div id="unit-result" class="result">0</div>
        </div>
    </div>
    <button onclick="navigateTo('#/')" class="btn-text mt-4">Kembali</button>
</div>
""",

    "pages/vault.html": """
<div class="page-container">
    <h2 id="vault-title">Vault</h2>
    <div id="vault-folders" class="grid mt-4">
        <div class="folder-card" onclick="openFolder('Images')">
            <span class="icon">🖼️</span>
            <p>Gambar</p>
        </div>
        <div class="folder-card" onclick="openFolder('Videos')">
            <span class="icon">🎞️</span>
            <p>Video</p>
        </div>
        <div class="folder-card" onclick="openFolder('Documents')">
            <span class="icon">📄</span>
            <p>Dokumen</p>
        </div>
    </div>
    <button onclick="navigateTo('#/')" class="btn-text mt-4">Tutup Vault</button>
</div>
""",

    "pages/payment.html": """
<div class="page-container text-center">
    <h2>Premium Access</h2>
    <div class="payment-card mt-4">
        <h3>VIP Vault</h3>
        <p>Akses fitur tersembunyi tanpa batas.</p>
        <h1 class="mt-4 text-amber">Rp 15.000</h1>
        <button class="btn btn-blue mt-4 w-100" onclick="payWithDana()">Bayar dengan DANA</button>
    </div>
    <button onclick="navigateTo('#/')" class="btn-text mt-4">Batal</button>
</div>
""",

    "css/global.css": """* { box-sizing: border-box; margin: 0; padding: 0; }
body.dark-theme { background-color: #000; color: #fff; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; overflow: hidden; }
#app { width: 100%; max-width: 400px; height: 100%; display: flex; flex-direction: column; background-color: #000; position: relative; }
.page-container { padding: 20px; display: flex; flex-direction: column; height: 100%; overflow-y: auto; }
.mt-4 { margin-top: 20px; }
.text-center { text-align: center; }
.text-amber { color: #ff9f0a; }
.w-100 { width: 100%; }
.btn-text { background: none; border: none; color: #fff; cursor: pointer; font-size: 16px; padding: 10px; }
.btn-blue { background-color: #007aff; color: #fff; padding: 15px; border: none; border-radius: 12px; font-size: 18px; font-weight: bold; cursor: pointer; }
.row { display: flex; justify-content: space-between; align-items: center; gap: 10px; }
select, input { background: #333; color: #fff; border: 1px solid #444; padding: 10px; border-radius: 8px; font-size: 16px; width: 100%; outline: none; }
select { flex: 1; }
""",

    "css/navbar.css": """.navbar { display: flex; justify-content: space-between; padding: 20px; }
.icon-btn { background: none; border: none; cursor: pointer; padding: 10px; border-radius: 50%; transition: background 0.2s; color: #fff; font-size: 20px; display: flex; align-items: center; justify-content: center; }
.icon-btn:active { background: rgba(255, 255, 255, 0.2); }
.icon-btn img { width: 24px; height: 24px; filter: invert(1); }
.capsule-group { display: flex; background: rgba(255, 255, 255, 0.1); border-radius: 30px; padding: 2px 10px; }
.capsule-nav .icon-btn { margin: 0 5px; }""",

    "css/calculator.css": """.calculator-container { display: flex; flex-direction: column; flex: 1; justify-content: flex-end; padding: 20px; }
.display { text-align: right; margin-bottom: 20px; }
.preview { font-size: 24px; color: rgba(255, 255, 255, 0.6); min-height: 30px; }
.result { font-size: 64px; font-weight: 300; color: #fff; word-wrap: break-word; max-height: 150px; overflow: hidden; }
.keypad { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
.btn { border: none; border-radius: 50%; font-size: 32px; cursor: pointer; display: flex; justify-content: center; align-items: center; aspect-ratio: 1; transition: filter 0.2s; }
.btn:active { filter: brightness(1.3); }
.btn-dark { background-color: #333; color: #fff; }
.btn-gray { background-color: #a5a5a5; color: #000; }
.btn-orange { background-color: #ff9f0a; color: #fff; }
.btn-zero { grid-column: span 2; aspect-ratio: auto; border-radius: 40px; justify-content: flex-start; padding-left: 30px; }""",

    "css/history.css": """#history-list { flex: 1; overflow-y: auto; display: flex; flex-direction: column; gap: 10px; margin-top: 10px; }
.history-item { background: #1c1c1e; padding: 15px; border-radius: 12px; text-align: right; }
.history-expr { color: #888; font-size: 18px; }
.history-res { color: #fff; font-size: 24px; font-weight: bold; }""",

    "css/currency.css": """.converter-box { background: #1c1c1e; padding: 20px; border-radius: 16px; }""",
    
    "css/unit.css": """.tabs { display: flex; gap: 10px; overflow-x: auto; padding-bottom: 10px; }
.tab-btn { background: #333; color: #fff; border: none; padding: 8px 16px; border-radius: 20px; cursor: pointer; white-space: nowrap; }
.tab-btn.active { background: #ff9f0a; color: #000; font-weight: bold; }""",

    "css/vault.css": """.grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
.folder-card { background: #1c1c1e; border: 1px solid #333; border-radius: 16px; padding: 20px; text-align: center; cursor: pointer; transition: transform 0.2s; }
.folder-card:active { transform: scale(0.95); }
.folder-card .icon { font-size: 40px; display: block; margin-bottom: 10px; }""",

    "css/payment.css": """.payment-card { background: linear-gradient(145deg, #2c2c2e, #1c1c1e); border: 1px solid rgba(255, 159, 10, 0.3); border-radius: 20px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }""",

    "css/modal.css": """.modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.8); }
.modal-content { background-color: #1e1e1e; margin: 30% auto; padding: 30px; border-radius: 15px; width: 80%; max-width: 350px; color: white; border: 1px solid #333; }
.close-btn { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }""",

    "js/app.js": """const routes = {
    '#/': 'pages/calculator.html',
    '#/history': 'pages/history.html',
    '#/currency': 'pages/currency.html',
    '#/unit': 'pages/unit.html',
    '#/vault': 'pages/vault.html',
    '#/payment': 'pages/payment.html'
};

async function navigateTo(hash) {
    window.location.hash = hash;
}

async function loadRoute() {
    const hash = window.location.hash || '#/';
    const main = document.getElementById('main-content');
    const pageUrl = routes[hash] || routes['#/'];
    
    try {
        const res = await fetch(pageUrl);
        const html = await res.text();
        main.innerHTML = html;
        
        // Execute page specific scripts
        if (hash === '#/history') renderHistory();
        if (hash === '#/currency') initCurrency();
        if (hash === '#/unit') initUnit();
        if (hash === '#/vault') initVault();
    } catch(e) {
        main.innerHTML = '<h2>Error loading page</h2>';
    }
}

window.addEventListener('hashchange', loadRoute);
window.addEventListener('DOMContentLoaded', loadRoute);

function showInfo() { document.getElementById('info-modal').style.display = 'block'; }
function closeInfo() { document.getElementById('info-modal').style.display = 'none'; }
""",

    "js/calculator/calculator.js": """let expression = '';
let preview = '';

function appendInput(val) {
    const display = document.getElementById('main-display');
    const previewDisplay = document.getElementById('preview-display');
    if (!display) return;

    if (val === 'AC') {
        expression = ''; preview = '';
    } else if (val === '⌫') {
        expression = expression.slice(0, -1);
    } else if (val === '=') {
        checkSecretCode(expression);
        try {
            let evalExpr = expression.replace(/×/g, '*').replace(/÷/g, '/');
            let res = eval(evalExpr).toString();
            saveHistory(expression, res);
            expression = res;
            preview = '';
        } catch (e) {
            expression = 'Error';
        }
    } else {
        expression += val;
        try {
            let evalExpr = expression.replace(/×/g, '*').replace(/÷/g, '/');
            preview = eval(evalExpr).toString();
        } catch(e) { preview = ''; }
    }

    display.innerText = expression === '' ? '0' : expression;
    previewDisplay.innerText = preview;
}
""",

    "js/calculator/secretDetector.js": """function checkSecretCode(expr) {
    if (expr === '1+1') {
        navigateTo('#/vault');
    } else if (expr === '99+99') {
        const isVip = localStorage.getItem('vip_unlocked');
        if (isVip === 'true') {
            navigateTo('#/vault');
        } else {
            navigateTo('#/payment');
        }
    }
}""",

    "js/history/history.js": """function saveHistory(expr, res) {
    let hist = JSON.parse(localStorage.getItem('calc_history') || '[]');
    hist.unshift({expr, res});
    if(hist.length > 50) hist.pop();
    localStorage.setItem('calc_history', JSON.stringify(hist));
}

function renderHistory() {
    const list = document.getElementById('history-list');
    if(!list) return;
    let hist = JSON.parse(localStorage.getItem('calc_history') || '[]');
    if(hist.length === 0) {
        list.innerHTML = '<p class="text-center mt-4" style="color:#666">Belum ada riwayat.</p>';
        return;
    }
    list.innerHTML = hist.map(h => `
        <div class="history-item">
            <div class="history-expr">${h.expr}</div>
            <div class="history-res">= ${h.res}</div>
        </div>
    `).join('');
}

function clearHistory() {
    localStorage.removeItem('calc_history');
    renderHistory();
}""",

    "js/currency/currencyConverter.js": """let currencyRates = { USD: 1, IDR: 16000, EUR: 0.9, GBP: 0.8, JPY: 150 };
function initCurrency() {
    const fromSel = document.getElementById('curr-from');
    const toSel = document.getElementById('curr-to');
    if(!fromSel || !toSel) return;
    
    Object.keys(currencyRates).forEach(k => {
        fromSel.add(new Option(k, k));
        toSel.add(new Option(k, k));
    });
    fromSel.value = 'USD';
    toSel.value = 'IDR';
    convertCurrency();
}

function convertCurrency() {
    const from = document.getElementById('curr-from').value;
    const to = document.getElementById('curr-to').value;
    const val = parseFloat(document.getElementById('curr-input').value) || 0;
    
    const inUsd = val / currencyRates[from];
    const out = inUsd * currencyRates[to];
    
    document.getElementById('curr-result').innerText = out.toFixed(2);
}

function swapCurrency() {
    const from = document.getElementById('curr-from');
    const to = document.getElementById('curr-to');
    const temp = from.value;
    from.value = to.value;
    to.value = temp;
    convertCurrency();
}""",

    "js/unit/unitConverter.js": """const units = {
    'Panjang': { 'Meter': 1, 'Centimeter': 0.01, 'Kilometer': 1000 },
    'Berat': { 'Kilogram': 1, 'Gram': 0.001, 'Pound': 0.453592 },
    'Suhu': { 'Celsius': 'C', 'Fahrenheit': 'F' }
};
let curCategory = 'Panjang';

function initUnit() {
    setUnitCategory('Panjang');
}

function setUnitCategory(cat) {
    curCategory = cat;
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.className = 'tab-btn' + (btn.innerText === cat ? ' active' : '');
    });
    
    const fromSel = document.getElementById('unit-from');
    const toSel = document.getElementById('unit-to');
    fromSel.innerHTML = ''; toSel.innerHTML = '';
    
    Object.keys(units[cat]).forEach(u => {
        fromSel.add(new Option(u, u));
        toSel.add(new Option(u, u));
    });
    fromSel.selectedIndex = 0;
    toSel.selectedIndex = 1 < fromSel.options.length ? 1 : 0;
    convertUnit();
}

function convertUnit() {
    const from = document.getElementById('unit-from').value;
    const to = document.getElementById('unit-to').value;
    const val = parseFloat(document.getElementById('unit-input').value) || 0;
    
    let out = 0;
    if(curCategory === 'Suhu') {
        let c = from === 'Fahrenheit' ? (val - 32) * 5/9 : val;
        out = to === 'Fahrenheit' ? (c * 9/5) + 32 : c;
    } else {
        const inBase = val * units[curCategory][from];
        out = inBase / units[curCategory][to];
    }
    
    document.getElementById('unit-result').innerText = parseFloat(out.toFixed(4));
}

function swapUnit() {
    const from = document.getElementById('unit-from');
    const to = document.getElementById('unit-to');
    const temp = from.value;
    from.value = to.value;
    to.value = temp;
    convertUnit();
}""",

    "js/vault/vault.js": """function initVault() {
    const isVip = localStorage.getItem('vip_unlocked') === 'true';
    document.getElementById('vault-title').innerText = isVip ? 'Vault VIP' : 'Vault (Gratis)';
}
function openFolder(name) {
    alert('Folder ' + name + ' opened. (File upload needs backend/IDB)');
}""",

    "js/payment/payment.js": """function payWithDana() {
    localStorage.setItem('vip_unlocked', 'true');
    alert('Pembayaran Berhasil! Anda sekarang adalah VIP.');
    navigateTo('#/vault');
}"""
}

for filepath, content in files.items():
    full_path = os.path.join(base_path, filepath)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, "w", encoding="utf-8") as f:
        f.write(content.strip())

print("Complete web app files generated.")
