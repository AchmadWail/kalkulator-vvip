function checkSecretCode(expr) {
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
}