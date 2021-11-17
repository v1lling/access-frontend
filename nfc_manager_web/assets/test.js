async function test(params) {
    let color = params;
    console.log('Color: ' + color);
    await sleep(2000);
    const ndef = new NDEFReader();
    ndef.scan().then(() => {
        console.log("Scan started successfully.");
        ndef.onreadingerror = () => {
            console.log("Cannot read data from the NFC tag. Try another one?");
            return "no way";
        };
        ndef.onreading = event => {
            console.log("NDEF message read.");
            var customEvent = new CustomEvent("fromJavascriptToDart");
            document.dispatchEvent(customEvent);
            return "Hola";
        };
    }).catch(error => {
        console.log("Error! Scan failed to start: " + error);
        return "nope";
    });

}
function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}