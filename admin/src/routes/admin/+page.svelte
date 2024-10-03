<script>
    let admin=true
    let viewMode=true
    let employeeMode=false
</script>

<div class="flex flex-col bg-gray-800" style="height:100svh;width:100vw">
    <div class="w-full p-10 h-full rounded-xl">
        <div class="w-full flex flex-row gap-5 text-2xl ">
            <button on:click={()=>{viewMode=true}} class="bg-{viewMode?"green-700":"transparent"} px-7 py-2 rounded-xl text-{viewMode?"white":"black"} transition-all transform duration-300 {!viewMode?"hover:bg-green-600 hover:shadow-xl hover:scale-105 text-white":""}">View</button>
            <button on:click={()=>{viewMode=false}} class="bg-{!viewMode?"orange-700":"transparent"} px-7 py-2 rounded-xl text-{!viewMode?"white":"black"} transition-all transform duration-300 {viewMode?"hover:bg-orange-600  hover:shadow-xl hover:scale-105 text-white":""}">Register</button>
        </div>
        <div class="w-full flex flex-row h-auto">
            <div class="w-1/4 flex flex-col h-auto text-2xl my-5 ">
                {#if viewMode}
                    <div class="flex flex-col gap-4">
                        <button on:click={()=>{employeeMode=true}} class="bg-{employeeMode?"blue-700":"transparent"} px-7 py-2 rounded-xl text-{employeeMode?"white":"black"} transition-all transform duration-300 {!employeeMode?"hover:bg-blue-600 hover:shadow-xl hover:scale-105 text-white":""}">View Camera</button>
                        <button on:click={()=>{employeeMode=false}} class="bg-{!employeeMode?"blue-700":"transparent"} px-7 py-2 rounded-xl text-{!employeeMode?"white":"black"} transition-all transform duration-300 {employeeMode?"hover:bg-blue-600  hover:shadow-xl hover:scale-105 text-white":""}">View Employees</button>
                    </div>
                {:else}
                    <div class="flex flex-col gap-4">
                        <button on:click={()=>{employeeMode=true}} class="bg-{employeeMode?"blue-700":"transparent"} px-7 py-2 rounded-xl text-{employeeMode?"white":"black"} transition-all transform duration-300 {!employeeMode?"hover:bg-blue-600 hover:shadow-xl hover:scale-105 text-white":""}">View Camera</button>
                        <button on:click={()=>{employeeMode=false}} class="bg-{!employeeMode?"blue-700":"transparent"} px-7 py-2 rounded-xl text-{!employeeMode?"white":"black"} transition-all transform duration-300 {employeeMode?"hover:bg-blue-600  hover:shadow-xl hover:scale-105 text-white":""}">View Employees</button>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>
