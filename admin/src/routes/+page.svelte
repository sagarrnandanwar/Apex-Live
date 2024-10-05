<script>
    import {onMount} from 'svelte'
    let url='http://localhost:2000/'

    async function authenticateToken() {
    const token = localStorage.getItem('authToken'); 
    try {
        const response = await fetch(`${url}/authenticateToken`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,  // Bearer token for authorization
                'Content-Type': 'application/json'
            }
        });

        const data = await response.json();

        // If there's an error in the response data
        window.location.url =data.error? '/login':'/user';
       
    } catch (e) {
        window.alert("An error occurred: " + e.message);
    }
}


onMount(()=>{
    authenticateToken()
})
</script>