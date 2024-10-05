<script>
    import {onMount} from 'svelte'
    let url='http://localhost:xyz/'

    async function authenticateToken(){
        const token = localStorage.getItem('authToken'); 
        try {
                const response = await fetch(`${url}/authenticateToken`,{
                    method:'GET',
                    headers: {
                    'Authorization': `Bearer ${token}`, 
                    'Content-Type': 'application/json'
                    }
                })
            const data = await response.json()
            window.location.href=data.error?'/login':'admin'
        }catch(e){
            window.alert("error occured : "+e)
        }
    }
</script>

