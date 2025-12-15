document.getElementById('statementForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    const resultBox = document.getElementById('result');
    
    fetch('cgi-bin/statement.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        resultBox.className = 'result-box success';
        resultBox.innerHTML = '<pre>' + data.replace(/\n/g, '<br>') + '</pre>';
    })
    .catch(error => {
        resultBox.className = 'result-box error';
        resultBox.textContent = 'Error: ' + error.message;
    });
});

