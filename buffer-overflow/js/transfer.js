document.getElementById('transferForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const recipient = document.getElementById('recipient').value.trim();
    const resultBox = document.getElementById('result');
    
    // Validate: must contain at least 10 digits (but can have more characters)
    const digitCount = (recipient.match(/\d/g) || []).length;
    if (digitCount < 10) {
        resultBox.className = 'result-box error';
        resultBox.textContent = 'Please enter an account number with at least 10 digits.';
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
    const digitCount = (value.match(/\d/g) || []).length;
    
    if (value && digitCount < 10) {
        if (!errorMsg) {
            const msg = document.createElement('small');
            msg.id = 'recipient-error';
            msg.style.color = '#dc3545';
            msg.textContent = 'Account number must contain at least 10 digits';
            e.target.parentNode.appendChild(msg);
        }
    } else {
        if (errorMsg) {
            errorMsg.remove();
        }
    }
});
