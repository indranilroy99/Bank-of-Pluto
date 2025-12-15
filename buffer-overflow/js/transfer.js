document.getElementById('transferForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const recipient = document.getElementById('recipient').value.trim();
    const resultBox = document.getElementById('result');
    
    // Validate account number (10 digits)
    if (!/^\d{10}$/.test(recipient)) {
        resultBox.className = 'result-box error';
        resultBox.textContent = 'Please enter a valid 10-digit account number.';
        return;
    }
    
    const formData = new FormData(this);
    
    fetch('cgi-bin/transfer.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        if (data.includes('Error Code:') || data.includes('Transaction Processing Error')) {
            resultBox.className = 'result-box error';
        } else {
            resultBox.className = 'result-box success';
        }
        resultBox.textContent = data;
    })
    .catch(error => {
        resultBox.className = 'result-box error';
        resultBox.textContent = 'Error: ' + error.message;
    });
});

// Real-time validation
document.getElementById('recipient').addEventListener('input', function(e) {
    const value = e.target.value.trim();
    const errorMsg = document.getElementById('recipient-error');
    
    if (value && !/^\d{10}$/.test(value)) {
        if (!errorMsg) {
            const msg = document.createElement('small');
            msg.id = 'recipient-error';
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
