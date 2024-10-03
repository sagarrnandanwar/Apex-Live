let consoleIndex=-1
let colorSwitch="\x1b[37m"

function getFormattedDate() {
    const date = new Date();

    const day = String(date.getDate()).padStart(2, '0'); 
    const month = String(date.getMonth() + 1).padStart(2, '0'); 
    const year = String(date.getFullYear()).slice(-2); 

    let hours = date.getHours();
    const minutes = String(date.getMinutes()).padStart(2, '0'); 
    const ampm = hours >= 12 ? 'PM' : 'AM';

    hours = hours % 12;
    hours = hours ? hours : 12; 

    const formattedHours = String(hours).padStart(2, '0');

    return `\x1b[90m${day}/${month}/${year}\x1b[37m ;\x1b[90m ${formattedHours}:${minutes} ${ampm}\x1b[37m`;
}

function printLog(prefix,color,status,message){
    switch(color){
        case "r":
            colorSwitch="\x1b[31m"
            break
        case "g":
            colorSwitch="\x1b[32m"
            break
        case "y":
            colorSwitch="\x1b[33m"
            break
        case "b":
            colorSwitch="\x1b[34m"
            break
        case "m":
            colorSwitch="\x1b[35m"
            break
        case "c":
            colorSwitch="\x1b[36m"
            break
        case "w":
            colorSwitch="\x1b[37m"
            break
        default:
    }
    consoleIndex++;
    return `\n\n\x1b[90m${consoleIndex}\x1b[37m) [${getFormattedDate()}] (${colorSwitch}${prefix}\x1b[37m) status : ${colorSwitch}${status}\x1b[37m \n\t\x1b[37m${message}`
}

function printValue(property, value) {
    return `\n\t\t\x1b[36m${property} : \x1b[32m${value}\x1b[37m`
}

module.exports = {
    printLog,
    printValue,
};
