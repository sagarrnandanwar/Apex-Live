const app = require('express')()
let PORT = 4000
let index=0

app.get('/',(req, res) => {
    index++
    console.log(`[${index}] GET request received  [${Date.now()}]`)
    res.send('Hello World!')
})

app.listen(PORT,()=>{
    console.log(`Server is running on port ${PORT}`)
});