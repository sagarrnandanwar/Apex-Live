<script>
    import {onMount} from 'svelte'
    let admin = true;
    let viewMode = 0;
    let projectName=''
    let emailID=''
    let isAdmin=false
    let editCam=false
    let editEmployee=false
    let talukaName=''


    let pollingStationNumber=''
    let pollingStationOperator=''
    let pollingStationAddress=''
    let pollingStationTaluka=''


    let employeeList=[]
    let cameraList=[]
    let pollingStationList=[]
    let talukasList=[]

    let cameraPollStation=''
    let serialNumber = '';

    let employeeName=''
    let employeePassword=''
    let employeeNumber=''
    let employeeAdmin=false



    let url='http://localhost:2000'
    let token


    const getToken = () => {
        return localStorage.getItem('authToken'); 
    };


    async function fetchPollingStations() {
       
       try {
           const response = await fetch(`${url}/getPollingStation`, {
               method: 'GET',
               headers: {
                   'Authorization': `Bearer ${token}`,
                   'Content-Type': 'application/json'
               }
           });

          

           pollingStationList = await response.json();
       } catch (error) {
           console.error('Error fetching employees:', error);
           errorMessage = 'An error occurred while fetching employees.';
       }
   }

    async function fetchTalukas() {
       
        try {
            const response = await fetch(`${url}/getTalukas`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                const { error } = await response.json();
                errorMessage = error; // Display the error message from the server
                return;
            }

            talukasList = await response.json();
        } catch (error) {
            console.error('Error fetching employees:', error);
            errorMessage = 'An error occurred while fetching employees.';
        }
    }


    async function fetchEmployees() {
        try {
            const response = await fetch(`${url}/getEmployees`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                const { error } = await response.json();
                errorMessage = error; // Display the error message from the server
                return;
            }

            employeeList = await response.json();
        } catch (error) {
            console.error('Error fetching employees:', error);
            errorMessage = 'An error occurred while fetching employees.';
        }
    }



    async function registerPollingStation(){

        if (pollingStationNumber=='' || !pollingStationOperator || !pollingStationAddress || !pollingStationTaluka||pollingStationNumber==''||pollingStationOperator==''||pollingStationAddress==''||pollingStationTaluka=='') {
            alert("Missing some info for taluka");
            return;
        }

        try{

            const response = await fetch(`${url}/registerPollingStation`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ 
                     number:pollingStationNumber,
                     operator:pollingStationOperator,
                     address:pollingStationAddress,
                     taluka:pollingStationTaluka
                })
            });

            const data = await response.json();

            if (response.ok) {
                if(data.done){
                    alert("Polling Station registered! with name : " + data.name)
                    pollingStationNumber=''                    
                }
            } else {
                alert(data.error || 'Registeration failed');
            }

        }catch(err){

        }
    }


    async function registerTaluka(){
        if (!talukaName || talukaName=='') {
            alert("Please enter taluka name");
            return;
        }
        
        try {
            const response = await fetch(`${url}/registerTaluka`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ name: talukaName})
            });

            const data = await response.json();

            if (response.ok) {
                if(data.done){
                    alert("Taluka registered! with name : " + data.name)
                    talukaName=''
                }
            } else {
                alert(data.error || 'Registeration failed');
            }
        } catch (error) {
            console.error('Error during registering:', error);
            alert("An error occurred during registering. Please try again.");
        }
    }





    async function registerEmployee(){
        if (!employeeName || !employeeNumber || !employeePassword || employeeName=='' || employeeNumber=='' || employeePassword=='') {
            alert("Please enter all name, password and number");
            return;
        }

        try {
            const response = await fetch(`${url}/registerEmployee`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ name: employeeName,password: employeePassword,number: employeeNumber,isAdmin:employeeAdmin}) // Assuming 'email' is used as username in the backend
            });

            const data = await response.json();

            if (response.ok) {
                if(data.done){
                    alert("Employee registered! with name : " + data.name)
                    employeeName=''
                    employeePassword=''
                    employeeNumber=''
                    employeeAdmin=false
                }
            } else {
                alert(data.error || 'Registeration failed');
            }
        } catch (error) {
            console.error('Error during registering:', error);
            alert("An error occurred during registering. Please try again.");
        }
    }



    async function authenticateToken() {
        const token = getToken(); 
        if (!token) {
            window.location = '/login'; 
            return;
        }
    
        try {
            const response = await fetch(`${url}/authenticateToken`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${token}`, // Send token in authorization header
                    'Content-Type': 'application/json'
                }
            });

            const data = await response.json();

            if (response.ok) {
                // Token is valid; you can proceed to the user page or show user data
                console.log('Authenticated user:', data);
                if(data.error) window.location='/login'
                isAdmin=data.isAdmin
               
            } else {
                alert(data.error || 'Token is invalid');
                window.location = '/login'; // Redirect to login if token is invalid
            }
        } catch (error) {
            console.error('Error during token authentication:', error);
            alert("An error occurred while authenticating the token.");
        }
    }


    // Function to handle camera initialization
    async function registerCamera() {
        // Implementation for registering the camera (e.g., storing serial number or location)
        alert('Camera registered with serial number: ' + serialNumber);
    }

    function getInfo(){
        fetchPollingStations()
        fetchEmployees()
        fetchTalukas()
        
    }

    function openCamera(id){
        editCam=true;
    }

    function openEmployee(id){
        editEmployee=true;
    }

    function saveChanges(){

    }


    onMount(()=>{
        token=getToken()
        authenticateToken();
        getInfo()
    })
</script>

<div class="{editCam?"flex":"hidden"} p-10 flex-col items-center absolute z-20 bg-black bg-opacity-70" style="height:100%;width:100vw">
    <div class="w-2/3 bg-gray-100 mx-auto rounded-xl">
        <div class="w-full flex flex-row justify-between">
            <div class="text-5xl w-full flex flex-row justify-center mt-3">
                Edit Camera
            </div>
            <button on:click={()=>{editCam=false}} class="mt-3 px-7 py-3 text-red-500 text-4xl">❌</button>
        </div>
        <div class="flex flex-col mx-auto w-2/3 gap-3 text-2xl my-10 bg-gray-300 rounded-xl">
            
            <div class="ml-10 mt-5 my-2">Polling Station :</div>
            <input bind:value={projectName} class="border-gray-500 border-1 ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Project Name">
            <div class="ml-10 my-2">Location :</div>
            <input class="border-gray-500 border-1  ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Location">
            <div class="ml-10 mt-5 my-2">Serial Number :</div>
            <input bind:value={serialNumber} class="border-gray-500 border-1  ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Serial Number">
            <button on:click={saveChanges} class=" mx-auto mt-10 mb-10 bg-white  bg-{viewMode==1?"blue-500":"transparent"} px-7 py-2 rounded-xl text-blue-700 transition-all transform duration-300 hover:bg-blue-500  hover:shadow-xl hover:text-white">Save Changes</button>
        </div>
    </div>
</div>




<div class="{editEmployee?"flex":"hidden"} p-10 flex-col items-center absolute z-20 bg-black bg-opacity-70" style="height:100%;width:100vw">
    <div class="w-2/3 bg-gray-100 mx-auto rounded-xl">
        <div class="w-full flex flex-row justify-between">
            <div class="text-5xl w-full flex flex-row justify-center mt-3">
                Edit Camera
            </div>
            <button on:click={()=>{editEmployee=false}} class="mt-3 px-7 py-3 text-red-500 text-4xl">❌</button>
        </div>
        <div class="flex flex-col mx-auto w-2/3 gap-3 text-2xl my-10 bg-gray-300 rounded-xl">
            
            <div class="ml-10 mt-5 my-2">Employee Name :</div>
            <input bind:value={projectName} class="border-gray-500 border-1 ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Employee Name">
            <div class="ml-10 my-2">Password :</div>
            <input class="border-gray-500 border-1  ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Password">
            <div class="ml-10 mt-5 my-2">Phone Number :</div>
            <input bind:value={serialNumber} class="border-gray-500 border-1  ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Mobile Number">
            <button on:click={saveChanges} class=" mx-auto mt-10 mb-10 bg-white  bg-{viewMode==1?"blue-500":"transparent"} px-7 py-2 rounded-xl text-blue-700 transition-all transform duration-300 hover:bg-blue-500  hover:shadow-xl hover:text-white">Save Changes</button>
        </div>
    </div>
</div>



<div class="flex flex-col bg-gray-200" style="min-height:200svh;width:100%">
    <div class="w-full py-10 h-full rounded-xl px-20 text-2xl">
        <div class="w-full flex flex-row justify-between">
            <div class=" flex flex-row gap-5  pl-5 ml-10">
                <button on:click={()=>{viewMode=0}} class="bg-{viewMode==0?"green-700":"transparent"} px-7 order-1 py-2 rounded-xl text-{viewMode==0?"white":"black"} transition-all transform duration-300 {viewMode==0?"hover:bg-green-600 hover:shadow-xl hover:scale-105 text-white":""}">Cameras</button>
                <button on:click={()=>{viewMode=2}} class="bg-{viewMode==2?"purple-700":"transparent"} px-7 order-2 py-2 rounded-xl text-{viewMode==2?"white":"black"} transition-all transform duration-300 {viewMode==2?"hover:bg-purple-600  hover:shadow-xl hover:scale-105 text-white":""}">Employees</button>
                <button on:click={()=>{viewMode=1}} class="bg-{viewMode==1?"orange-500":"transparent"} px-7 order-0 py-2 rounded-xl text-{viewMode==1?"white":"black"} transition-all transform duration-300 {viewMode==1?"hover:bg-orange-400  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
                <button on:click={()=>{viewMode=3}} class="bg-{viewMode==3?"yellow-500":"transparent"} px-7 order-3 py-2 rounded-xl text-{viewMode==3?"white":"black"} transition-all transform duration-300 {viewMode==3?"hover:bg-yellow-500  hover:shadow-xl hover:scale-105 text-white":""}">Polling Stations</button>
                <button on:click={()=>{viewMode=4}} class="bg-{viewMode==4?"red-500":"transparent"} px-7 order-4 py-2 rounded-xl text-{viewMode==4?"white":"black"} transition-all transform duration-300 {viewMode==4?"hover:bg-red-500  hover:shadow-xl hover:scale-105 text-white":""}">Talukas</button>
            </div>
            
                <button on:click={getInfo} class="bg-pink-500 px-7 order-4 py-2 rounded-xl text-white transition-all transform duration-300 hover:bg-pink-500  hover:shadow-xl hover:scale-105 text-white">↻ fetch data</button>

           
        </div>

        <div class="w-full flex flex-row h-auto px-10">
            <div class="w-full rounded-xl  flex flex-col h-auto text-2xl mt-10 ">
                {#if viewMode==0}
                    
                    <p>1</p>
                    

                {:else if viewMode==1}
                    <div class="grid grid-rows-2 grid-cols-2 w-full gap-10 rounded-xl justify-around h-full">
                        <div class=" flex bg-gray-300 flex-col p-3 rounded-3xl justify-center">
                        
                            <div class="mx-auto mt-5 mb-5 text-4xl ">Register Camera</div>

                            <div class="ml-10 mt-5 my-2">Polling Station :</div>
                                <select bind:value={cameraPollStation} class="ml-7 w-3/4 px-3 py-2 rounded-xl">
                                    {#each pollingStationList as poll}
                                        <option>{poll.id}) {poll.polling_station}</option>
                                    {/each}
                                </select>
                            <div class="ml-10 mt-5 my-2">Serial Number :</div>
                            <input bind:value={serialNumber} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Serial Number">
                            
                            <button on:click={registerCamera} class="w-1/4 mx-auto mt-10 mb-4  bg-{viewMode==1?"blue-500":"transparent"} px-7 py-2 rounded-xl text-{viewMode==1?"white":"black"} transition-all transform duration-300 {viewMode==1?"hover:bg-blue-500  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
                                             
                        </div>

                        <div class="overflow-y-auto bg-gray-300 flex flex-col rounded-3xl justify-center">
                            <div class="mx-auto mt-5 mb-5 text-4xl ">Register Employee</div>

                            <div class="ml-10 mt-5 my-2">Name :</div>
                            <input bind:value={employeeName} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Full Name">
                            <div class="ml-10 my-2">Password :</div>
                            <input bind:value={employeePassword} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Password">
                            <div class="ml-10 my-2">Mobile Number :</div>
                            <input bind:value={employeeNumber} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Confirm Password">
                        
                            <div class="flex flex-row items-center w-full justify-center my-5 gap-5">
                                <div>Is Admin?</div> 
                                <input class="transform scale-[2]" bind:checked={employeeAdmin} type="checkbox">
                            </div>
                           
                            <button on:click={registerEmployee} class="w-1/4 mx-auto mt-2 mb-10  bg-{viewMode==1?"blue-500":"transparent"} px-7 py-2 rounded-xl text-{viewMode==1?"white":"black"} transition-all transform duration-300 {viewMode==1?"hover:bg-blue-500  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
                                   
                        </div>

                        <div class="bg-gray-300 flex flex-col p-3 rounded-3xl justify-center">
                        
                            <div class="mx-auto mt-5 mb-5 text-4xl ">Register Polling Station</div>

                            <div class="ml-10 mt-5 my-2">Polling Station Number :</div>
                            <input bind:value={pollingStationNumber} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Polling Station">
                            <div class="ml-10 my-2">Operator :</div>

                            <select bind:value={pollingStationOperator} class="ml-7 w-3/4 px-3 py-2 rounded-xl">
                                {#each employeeList as employee}
                                    <option>{employee.full_name}</option>
                                {/each}
                            </select>

                            
                            <div class="ml-10 mt-5 my-2">Taluka :</div>
                            <select bind:value={pollingStationTaluka} class="ml-7 w-3/4 px-3 py-2 rounded-xl">
                                {#each talukasList as taluka}
                                    <option>{taluka.taluka}</option>
                                {/each}
                            </select>
                            
                            <div class="ml-10 mt-5 my-2">Address :</div>
                            
                            <input bind:value={pollingStationAddress} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Serial Number">
                            
                            <button on:click={registerPollingStation} class="w-1/4 mx-auto mt-10 mb-4  bg-{viewMode==1?"blue-500":"transparent"} px-7 py-2 rounded-xl text-{viewMode==1?"white":"black"} transition-all transform duration-300 {viewMode==1?"hover:bg-blue-500  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
                                             
                        </div>



                        
                        <div class="overflow-y-auto bg-gray-300 flex flex-col rounded-3xl justify-center">
                            <div class="mx-auto mt-5 mb-5 text-4xl ">Register Taluka</div>

                            <div class="ml-10 mt-5 my-2">Taluka Name :</div>
                            <input bind:value={talukaName} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Full Name">
                                                      
                            <button on:click={registerTaluka} class="w-1/4 mx-auto mt-10 mb-10  bg-{viewMode==1?"blue-500":"transparent"} px-7 py-2 rounded-xl text-{viewMode==1?"white":"black"} transition-all transform duration-300 {viewMode==1?"hover:bg-blue-500  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
                                   
                        </div>
                    </div>
                    
                {:else if viewMode==2}
                    
                    <div class="flex flex-wrap gap-3 w-full bg-gray-200 p-10 rounded-2xl">
                        {#each employeeList as employee}
                            <button class="w-1/4 transform hover:scale-95 hover:shadow-xl duration-300 transition-all flex flex-col gap-3 p-5 rounded-2xl bg-white">
                                <div class="text-2xl w-full flex flex-row gap-4 justify-between">
                                    <div class="flex flex-row gap-4">
                                        <div>{employee.id} ) </div>
                                        <div>{employee.full_name}</div>
                                    </div>
                                    <div>{employee.is_admin?"admin":"user"}</div>
                                </div>
                                <div class="text-2xl w-full flex flex-row gap-4 justify-between">
                                    <div>Mobile No.</div>
                                    <div>+91 {employee.phone_number}</div>
                                </div>
                            </button>
                        {/each}
                    </div>



                {:else if viewMode==3}

                <div class="flex flex-wrap gap-3 w-full bg-gray-200 p-10 rounded-2xl">
                    {#each pollingStationList as polls}
                        <button class="w-1/4 transform hover:scale-95 hover:shadow-xl duration-300 transition-all flex flex-row gap-3 p-5 rounded-2xl bg-white">   
                            <div class="flex flex-row justify-between">
                                <div class="flex flex-row">
                                    <div>{polls.id})  </div>
                                    <div>{polls.polling_station}</div>
                                </div>
                            </div>
                        </button>
                    {/each}
                    <button class="w-1/4 transform hover:scale-95 hover:shadow-xl duration-300 transition-all flex flex-row gap-3 p-5 rounded-2xl bg-white">   
                        <div class="flex flex-row justify-between">
                            <div class="flex flex-row gap-4">
                                <div>1) </div>
                                <div>ADDAWDAWD</div>
                            </div>
                        </div>
                    </button>
                </div>

                
                {:else if viewMode==4}

                <div class="flex flex-wrap gap-3 w-full bg-gray-200 p-10 rounded-2xl">
                    {#each talukasList as taluka}
                        <button class="w-1/4 transform hover:scale-95 hover:shadow-xl duration-300 transition-all flex flex-row gap-3 p-5 rounded-2xl bg-white">   
                            <div>{taluka.id})  </div>
                            <div>{taluka.taluka}</div>
                        </button>
                    {/each}
                </div>


                {/if}
            </div>
        </div>
    </div>
</div>
