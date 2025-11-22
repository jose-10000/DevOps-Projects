// app.js
document.addEventListener('DOMContentLoaded', function() {
    const messageForm = document.getElementById('messageForm');
    const messageInput = document.getElementById('messageInput');
    const messagesList = document.getElementById('messagesList');

    // Function to load messages from the API
    function loadMessages() {
        fetch('/messages')
            .then(response => response.json())
            .then(data => {
                messagesList.innerHTML = '';
                data.forEach(message => {
                    const li = document.createElement('li');
                    li.innerHTML = `
                        <strong>${message.content}</strong>
                        <div class="timestamp">${new Date(message.timestamp).toLocaleString()}</div>
                    `;
                    messagesList.appendChild(li);
                });
            })
            .catch(error => console.error('Error loading messages:', error));
    }

    // Load messages on page load
    loadMessages();

    // Handle form submission
    messageForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const message = messageInput.value.trim();
        if (message) {
            fetch('/messages', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ content: message }),
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    messageInput.value = '';
                    loadMessages(); // Reload messages after posting
                } else {
                    alert('Error sending message: ' + data.error);
                }
            })
            .catch(error => console.error('Error sending message:', error));
        }
    });
});