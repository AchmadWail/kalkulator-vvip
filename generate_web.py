import os

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
    <link rel="stylesheet" href="css/animations.css">
    <link rel="stylesheet" href="css/modal.css">
</head>
<body class="dark-theme">
    <div id="app">
        <!-- Navbar -->
        <nav class="navbar capsule-nav">
            <div class="nav-left">
                <button class="icon-btn" onclick="showInfo()"><img src="../assets/icons/icon_question.png" alt="Info"></button>
            </div>
            <div class="nav-right capsule-group">
                <button class="icon-btn" onclick="navigateTo('#/history')"><img src="../assets/icons/icon_clock.png" alt="History"></button>
                <button class="icon-btn" onclick="navigateTo('#/currency')"><img src="../assets/icons/icon_dollar.png" alt="Currency"></button>
                <button class="icon-btn" onclick="navigateTo('#/unit')"><img src="../assets/icons/icon_ruler.png" alt="Unit"></button>
            </div>
        </nav>

        <!-- Main Content -->
        <main id="main-content">
            <div class="calculator-container">
                <div class="display">
                    <div class="preview" id="preview-display"></div>
                    <div class="result" id="main-display">0</div>
                </div>
                <div class="keypad">
                    <!-- Row 1 -->
                    <button class="btn btn-gray" onclick="appendInput('AC')">AC</button>
                    <button class="btn btn-gray" onclick="appendInput('⌫')">⌫</button>
                    <button class="btn btn-gray" onclick="appendInput('%')">%</button>
                    <button class="btn btn-orange" onclick="appendInput('÷')">÷</button>
                    
                    <!-- Row 2 -->
                    <button class="btn btn-dark" onclick="appendInput('7')">7</button>
                    <button class="btn btn-dark" onclick="appendInput('8')">8</button>
                    <button class="btn btn-dark" onclick="appendInput('9')">9</button>
                    <button class="btn btn-orange" onclick="appendInput('×')">×</button>
                    
                    <!-- Row 3 -->
                    <button class="btn btn-dark" onclick="appendInput('4')">4</button>
                    <button class="btn btn-dark" onclick="appendInput('5')">5</button>
                    <button class="btn btn-dark" onclick="appendInput('6')">6</button>
                    <button class="btn btn-orange" onclick="appendInput('-')">-</button>
                    
                    <!-- Row 4 -->
                    <button class="btn btn-dark" onclick="appendInput('1')">1</button>
                    <button class="btn btn-dark" onclick="appendInput('2')">2</button>
                    <button class="btn btn-dark" onclick="appendInput('3')">3</button>
                    <button class="btn btn-orange" onclick="appendInput('+')">+</button>
                    
                    <!-- Row 5 -->
                    <button class="btn btn-dark btn-zero" onclick="appendInput('0')">0</button>
                    <button class="btn btn-dark" onclick="appendInput('.')">.</button>
                    <button class="btn btn-orange" onclick="appendInput('=')">=</button>
                </div>
            </div>
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
</body>
</html>""",
    "css/global.css": """* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}
body.dark-theme {
    background-color: #000;
    color: #fff;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    overflow: hidden;
}
#app {
    width: 100%;
    max-width: 400px;
    height: 100%;
    display: flex;
    flex-direction: column;
    background-color: #000;
}""",
    "css/navbar.css": """.navbar {
    display: flex;
    justify-content: space-between;
    padding: 20px;
}
.icon-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 10px;
    border-radius: 50%;
    transition: background 0.2s;
}
.icon-btn:active {
    background: rgba(255, 255, 255, 0.2);
}
.icon-btn img {
    width: 24px;
    height: 24px;
    filter: invert(1);
}
.capsule-group {
    display: flex;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 30px;
    padding: 2px 10px;
}
.capsule-nav .icon-btn {
    margin: 0 5px;
}""",
    "css/calculator.css": """.calculator-container {
    display: flex;
    flex-direction: column;
    flex: 1;
    justify-content: flex-end;
    padding: 20px;
}
.display {
    text-align: right;
    margin-bottom: 20px;
}
.preview {
    font-size: 24px;
    color: rgba(255, 255, 255, 0.6);
    min-height: 30px;
}
.result {
    font-size: 64px;
    font-weight: 300;
    color: #fff;
    word-wrap: break-word;
    max-height: 150px;
    overflow: hidden;
}
.keypad {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
}
.btn {
    border: none;
    border-radius: 50%;
    font-size: 32px;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    aspect-ratio: 1;
    transition: filter 0.2s;
}
.btn:active {
    filter: brightness(1.3);
}
.btn-dark {
    background-color: #333;
    color: #fff;
}
.btn-gray {
    background-color: #a5a5a5;
    color: #000;
}
.btn-orange {
    background-color: #ff9f0a;
    color: #fff;
}
.btn-zero {
    grid-column: span 2;
    aspect-ratio: auto;
    border-radius: 40px;
    justify-content: flex-start;
    padding-left: 30px;
}""",
    "css/modal.css": """.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.8);
}
.modal-content {
    background-color: #1e1e1e;
    margin: 30% auto;
    padding: 30px;
    border-radius: 15px;
    width: 80%;
    max-width: 350px;
    color: white;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
    border: 1px solid #333;
}
.close-btn {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}
.close-btn:hover {
    color: white;
}""",
    "js/app.js": """// App initialization and routing
function navigateTo(hash) {
    window.location.hash = hash;
}

window.addEventListener('hashchange', () => {
    // Basic routing
    const hash = window.location.hash;
    if (hash === '#/history') {
        alert('History screen not implemented in Web MVP. Use Flutter App.');
    } else if (hash === '#/currency') {
        alert('Currency screen not implemented in Web MVP. Use Flutter App.');
    } else if (hash === '#/unit') {
        alert('Unit screen not implemented in Web MVP. Use Flutter App.');
    }
});

function showInfo() {
    document.getElementById('info-modal').style.display = 'block';
}

function closeInfo() {
    document.getElementById('info-modal').style.display = 'none';
}
""",
    "js/calculator/calculator.js": """let expression = '';
let preview = '';

function appendInput(val) {
    const display = document.getElementById('main-display');
    const previewDisplay = document.getElementById('preview-display');

    if (val === 'AC') {
        expression = '';
        preview = '';
    } else if (val === '⌫') {
        expression = expression.slice(0, -1);
    } else if (val === '=') {
        checkSecretCode(expression);
        try {
            // Very basic evaluation for MVP
            let evalExpr = expression.replace(/×/g, '*').replace(/÷/g, '/');
            expression = eval(evalExpr).toString();
            preview = '';
        } catch (e) {
            expression = 'Error';
        }
    } else {
        expression += val;
        try {
            let evalExpr = expression.replace(/×/g, '*').replace(/÷/g, '/');
            preview = eval(evalExpr).toString();
        } catch(e) {
            preview = '';
        }
    }

    display.innerText = expression === '' ? '0' : expression;
    previewDisplay.innerText = preview;
}""",
    "js/calculator/secretDetector.js": """function checkSecretCode(expr) {
    if (expr === '1+1') {
        alert('Vault Mode: Lihat Saja (Gratis) - Navigating to Vault...');
        // In real web app, navigate to vault.html
    } else if (expr === '99+99') {
        const isVip = localStorage.getItem('vip_unlocked');
        if (isVip === 'true') {
            alert('Vault Mode: VIP Penuh - Navigating to Vault...');
        } else {
            alert('Akses Ditolak. Mengarahkan ke Pembayaran Rp 15.000...');
            // In real app, open Dana Deep Link or Payment screen
            window.location.href = "dana://pay?amount=15000&note=KalkulatorVIP";
        }
    }
}"""
}

for filepath, content in files.items():
    full_path = os.path.join(base_path, filepath)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, "w", encoding="utf-8") as f:
        f.write(content)

print("Web app files generated.")
