// App initialization and routing
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
