/**
 * Collection of Methods to help in debugging LWCs during runtime in the browser
 */

/**
 * Return a proxy object that's converted to JSON and back for output to the console
 * @param {Object} proxyObj The object to reveal the contents of given that it's a proxy
 * @returns
 */
const deProxyObj = (proxyObj) => {
    return JSON.parse(JSON.stringify(proxyObj));
};

/**
 * Basic method to detect if parameter is an event object.
 * @param {*} param0
 * @returns Boolean representing if the object is an event.
 */
const isEvent = ({ bubbles, composed, target }) => {
    return bubbles !== undefined && composed !== undefined && target;
};

/**
 * Prints out pretty debug information to the console
 * @param {String} label A label for the console
 * @param  {...any} args The arguments to log
 */
const debugLog = async (label, ...args) => {
    const fontStyles = `
        color:orange;
        font-size:12px;
        font-weight:600;
    `;
    const logLabel = args.length ? label : '';
    let displayArgs = [];
    if (args.length) {
        displayArgs = args.map((arg) => {
            if (arg && typeof arg === 'object' && isEvent(arg)) {
                return 'Event Object skipped';
            }
            return typeof arg === 'object' ? deProxyObj(arg) : arg;
        });
    } else {
        displayArgs.push(typeof label === 'object' ? deProxyObj(label) : label);
    }
    console.log(`%cDEBUG: ${logLabel}`, fontStyles, ...displayArgs);
};

/**
 * Provides a simpler way to debug a variable, especially if the label is the variable name
 * (`debugVar({ myVar })`).
 * @param {Object} obj The object to use for debugging the var.
 */
const debugVar = (obj) => {
    if (typeof obj === 'object') {
        const key = Object.keys(obj)[0];
        const val = obj[key];
        debugLog(key, val);
    }
};

export { debugLog, deProxyObj, debugVar };
