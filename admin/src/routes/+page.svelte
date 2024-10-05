<script>
    import { onMount } from 'svelte';
    let url = 'http://localhost:2000/';

    async function authenticateToken() {
        const token = localStorage.getItem('authToken');
        
        // Check if the token is missing or empty
        if (!token || token === "") {
            window.location.href = '/login';
            return; // Stop execution if there is no token
        }

        try {
            const response = await fetch(`${url}/authenticateToken`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${token}`,  // Bearer token for authorization
                    'Content-Type': 'application/json'
                }
            });

            // Check if the response is JSON
            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                const data = await response.json();

                // Redirect based on the presence of an error
                window.location.href = data.error ? '/login' : '/user';
            } else {
                // Handle non-JSON responses
                window.alert('Unexpected response format');
                window.location.href = '/login'; // Redirect to login on unexpected format
            }
        } catch (e) {
            window.alert("An error occurred: " + e.message);
            window.location.href = '/login'; // Redirect to login on error
        }
    }

    onMount(() => {
        authenticateToken();
    });
</script>
