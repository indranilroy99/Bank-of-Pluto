document.getElementById('statementForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const account = document.getElementById('account').value.trim();
    const resultBox = document.getElementById('result');
    
    // Validate account number (10 digits)
    if (!/^\d{10}$/.test(account)) {
        resultBox.className = 'result-box error';
        resultBox.textContent = 'Please enter a valid 10-digit account number.';
        return;
    }
    
    const formData = new FormData(this);
    
    fetch('cgi-bin/statement.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        if (data.includes('Error Code:') || data.includes('Statement Generation Error')) {
            resultBox.className = 'result-box error';
        } else {
            resultBox.className = 'result-box success';
        }
        resultBox.innerHTML = '<pre style="white-space: pre-wrap; font-family: monospace;">' + data.replace(/\n/g, '<br>') + '</pre>';
    })
    .catch(error => {
        resultBox.className = 'result-box error';
        resultBox.textContent = 'Error: ' + error.message;
    });
});

// Real-time validation
document.getElementById('account').addEventListener('input', function(e) {
    const value = e.target.value.trim();
    const errorMsg = document.getElementById('account-error');
    
    if (value && !/^\d{10}$/.test(value)) {
        if (!errorMsg) {
            const msg = document.createElement('small');
            msg.id = 'account-error';
            msg.style.color = '#dc3545';
            msg.textContent = 'Please enter a 10-digit account number';
            e.target.parentNode.appendChild(msg);
        }
    } else {
        if (errorMsg) {
            errorMsg.remove();
        }
    }
});
