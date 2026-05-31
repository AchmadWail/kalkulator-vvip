let expression = '';
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
}