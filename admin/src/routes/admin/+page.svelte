<script>
    let admin = true;
    let viewMode = 0;
    let serialNumber = '';
    let projectName=''
    let emailID=''
    let isAdmin=false
    let editCam=false
    // Function to handle camera initialization
    async function registerCamera() {
        // Implementation for registering the camera (e.g., storing serial number or location)
        alert('Camera registered with serial number: ' + serialNumber);
    }

    function openForm(id){
        editCam=true;

    }
</script>

<div class="{editCam?"flex":"hidden"} flex-col items-center absolute z-20 bg-black bg-opacity-70" style="height:100svh;width:100vw">
    <div class="w-2/3 mx-auto">
        <div >X</div>
    </div>
</div>

<div class="flex flex-col bg-gray-200" style="height:100svh;width:100vw">
    <div class="w-full py-10 h-full rounded-xl">
        <div class="w-full flex flex-row gap-5 text-2xl pl-10">
            <button on:click={()=>{viewMode=0}} class="bg-{viewMode==0?"green-700":"transparent"} px-7 order-1 py-2 rounded-xl text-{viewMode==0?"white":"black"} transition-all transform duration-300 {viewMode==0?"hover:bg-green-600 hover:shadow-xl hover:scale-105 text-white":""}">Camera</button>
            <button on:click={()=>{viewMode=2}} class="bg-{viewMode==2?"purple-700":"transparent"} px-7 order-2 py-2 rounded-xl text-{viewMode==2?"white":"black"} transition-all transform duration-300 {viewMode==2?"hover:bg-purple-600  hover:shadow-xl hover:scale-105 text-white":""}">Employees</button>
            <button on:click={()=>{viewMode=1}} class="bg-{viewMode==1?"orange-700":"transparent"} px-7 order-0 py-2 rounded-xl text-{viewMode==1?"white":"black"} transition-all transform duration-300 {viewMode==1?"hover:bg-orange-600  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
        </div>
        <div class="w-full flex flex-row h-auto px-10">
            <div class="w-full rounded-xl  flex flex-col h-auto text-2xl mt-10 ">
                {#if viewMode==0}
                    
                <div class="grid grid-rows-2 grid-cols-2 gap-2 px-4 py-4 rounded-lg h-full">
                    <button on:click={()=>{openForm("id")}} class=" flex flex-row w-1/2 w-full hover:bg-gray-600 transform hover:scale-95 hover:cursor-pointer transition-all duration-300 px-2 py-2 bg-gray-700 rounded-lg">
                        <div class="px-5 text-center text-white">1</div>
                        <div class="px-5 text-center text-white">Chimur_1</div>
                        <div class="px-5 text-center text-white">HF4G17375</div>
                        <div class="px-5 text-center text-white">ACTIVE</div>
                    </button>
                    <button on:click={()=>{openForm("id")}} class=" flex flex-row w-1/2 w-full hover:bg-gray-600 transform hover:scale-95 hover:cursor-pointer transition-all duration-300 px-2 py-2 bg-gray-700 rounded-lg">
                        <div class="px-5 text-center text-white">2</div>
                        <div class="px-5 text-center text-white">Chimur_1</div>
                        <div class="px-5 text-center text-white">HF4G17375</div>
                        <div class="px-5 text-center text-white">ACTIVE</div>
                    </button>
                    <button on:click={()=>{openForm("id")}} class=" flex flex-row w-1/2 w-full hover:bg-gray-600 transform hover:scale-95 hover:cursor-pointer transition-all duration-300 px-2 py-2 bg-gray-700 rounded-lg">
                        <div class="px-5 text-center text-white">3</div>
                        <div class="px-5 text-center text-white">Chimur_1</div>
                        <div class="px-5 text-center text-white">HF4G17375</div>
                        <div class="px-5 text-center text-white">ACTIVE</div>
                    </button>
                    <button on:click={()=>{openForm("id")}} class=" flex flex-row w-1/2 w-full hover:bg-gray-600 transform hover:scale-95 hover:cursor-pointer transition-all duration-300 px-2 py-2 bg-gray-700 rounded-lg">
                        <div class="px-5 text-center text-white">4</div>
                        <div class="px-5 text-center text-white">Chimur_1</div>
                        <div class="px-5 text-center text-white">HF4G17375</div>
                        <div class="px-5 text-center text-white">ACTIVE</div>
                    </button>
                    <button on:click={()=>{openForm("id")}} class=" flex flex-row w-1/2 w-full hover:bg-gray-600 transform hover:scale-95 hover:cursor-pointer transition-all duration-300 px-2 py-2 bg-gray-700 rounded-lg">
                        <div class="px-5 text-center text-white">5</div>
                        <div class="px-5 text-center text-white">Chimur_1</div>
                        <div class="px-5 text-center text-white">HF4G17375</div>
                        <div class="px-5 text-center text-white">ACTIVE</div>
                    </button>
                    <button on:click={()=>{openForm("id")}} class=" flex flex-row w-1/2 w-full hover:bg-gray-600 transform hover:scale-95 hover:cursor-pointer transition-all duration-300 px-2 py-2 bg-gray-700 rounded-lg">
                        <div class="px-5 text-center text-white">6</div>
                        <div class="px-5 text-center text-white">Chimur_1</div>
                        <div class="px-5 text-center text-white">HF4G17375</div>
                        <div class="px-5 text-center text-white">ACTIVE</div>
                    </button>
                    
                </div>
                {:else if viewMode==1}
                    <div class="flex flex-row w-full p-3 gap-10 rounded-xl justify-around h-full">
                        <div class="bg-gray-300 w-1/2 h-full flex flex-col p-3 rounded-lg ">
                        
                            <div class="mx-auto mt-5 mb-5 text-4xl ">Register Camera</div>

                            <div class="ml-10 mt-5 my-2">Project Name :</div>
                            <input bind:value={projectName} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Project Name">
                            <div class="ml-10 my-2">Location :</div>
                            <input class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Location">
                            <div class="ml-10 mt-5 my-2">Serial Number :</div>
                            <input bind:value={serialNumber} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Serial Number">
                            
                            <button on:click={registerCamera} class="w-1/4 mx-auto mt-10 mb-4  bg-{viewMode==1?"blue-500":"transparent"} px-7 py-2 rounded-xl text-{viewMode==1?"white":"black"} transition-all transform duration-300 {viewMode==1?"hover:bg-blue-500  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
                                             
                        </div>

                        <div class="overflow-y-auto bg-gray-300 w-1/2 h-full flex flex-col rounded-lg">
                            <div class="mx-auto mt-5 mb-5 text-4xl ">Register Employee</div>

                            <div class="ml-10 mt-5 my-2">Email :</div>
                            <input bind:value={emailID} class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Email Id">
                            <div class="ml-10 my-2">Password :</div>
                            <input class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Password">
                            <div class="ml-10 my-2">Confirm Password :</div>
                            <input class="ml-7 w-3/4 px-3 py-2 rounded-xl" placeholder="Confirm Password">
                            <div class="flex flex-row items-center w-full justify-center my-5 gap-5">
                                <div>Is Admin?</div> 
                                <input class="transform scale-[2]" type="checkbox">
                            </div>
                           
                            <button on:click={registerCamera} class="w-1/4 mx-auto mt-2 mb-10  bg-{viewMode==1?"blue-500":"transparent"} px-7 py-2 rounded-xl text-{viewMode==1?"white":"black"} transition-all transform duration-300 {viewMode==1?"hover:bg-blue-500  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
                                   
                        </div>
                    </div>
                    
                {:else}
                    
                <div>
                    nigga
                </div>
                {/if}
            </div>
        </div>
    </div>
</div>
