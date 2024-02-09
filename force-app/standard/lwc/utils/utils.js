/* eslint-disable @lwc/lwc/no-async-operation */
import safeAwait from './safeAwait';
import { debugLog } from './loggingTools';

export { debugLog, safeAwait };

/**
 * Workaround for overriding style rules in child components "hidden" by Shadow DOM
 *  Credit: https://salesforce.stackexchange.com/a/270624/68974
 *
 * @param {Object} cmp, a reference to an LWC, injection target
 * {String} selector, a CSS selector targeting a specific element
 * {String} styles, a string of CSS to inject into the component
 */
export const injectStylesLWC = ({ cmp, selector, styles }) => {
    if (!cmp) {
        return;
    }
    let targetElement = cmp.template.querySelector(selector);
    if (!targetElement) {
        console.log('@@@ DOM element not found, trying again in 10ms');
        window.setTimeout(() => {
            injectStylesLWC({ cmp, selector, styles });
        }, 10);
        return;
    }
    const style = document.createElement('style');
    style.innerText = styles;
    targetElement.appendChild(style);
};

/**
 * Obtain relative static resource path.
 * @param String, the url
 * @return String, url substring representing relative path
 */
export const getResourcePath = (resourceURL) => {
    return resourceURL.slice(resourceURL.indexOf('/resource'));
};

/**
 * Accept a CamelCaseString and return a Space Separated String with the prefix of
 * 'Permissions' removed.
 * @param {String} input, The camel case string to convert
 */
export const formatSystemPermissionNames = (input) => {
    let result = input.replace(/^Permissions/, '').replace(/([A-Z])/g, ' $1');
    result = result.toLowerCase();
    result = result
        .split(' ')
        .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');
    return {
        id: input,
        label: result
    };
};

/**
 * Capitalizes each word in the given string
 * @param {String} str string to capitalize
 * @return {String} capitalized string
 */
export const capitalizeStr = (str = '') => {
    return str
        .split(' ')
        .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');
};

/**
 * A hack to convert HTML entities into their native characters
 * @param encodedString The string containing encoded HTML entities
 * @return The decoded string
 */
export const decodeEntities = (encodedString) => {
    var doc = new DOMParser().parseFromString(encodedString, 'text/html');
    return doc.documentElement.textContent;
};

/**
 * "Sleep" for the given number of milliseconds
 * @param delay The number of milliseconds to wait before continuing
 */
export const sleep = async (delay) => {
    await new Promise((resolve) => setTimeout(resolve, delay));
};

/**
 * Return a regex from the given modifier and an unspecified number of regexes, can be
 * used to create lengthy, but readabile, regexes
 * @param modifier an optional modifier to the regex, such as `g`
 * @param regexes  the individual regexes that should be combined
 * @note This technique allows actual regexes to be combined without the need to use
 *       escaped strings
 */
export const combineRegexes = (modifier, ...regexes) => {
    return new RegExp(
        regexes
            .map((regex) => {
                return regex.source;
            })
            .join(''),
        modifier
    );
};
