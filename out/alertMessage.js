"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseAlertMessage = parseAlertMessage;
function containsDisplayControlCharacter(text) {
    for (const character of text) {
        const codePoint = character.codePointAt(0);
        if (codePoint !== undefined &&
            (codePoint <= 0x1f ||
                (codePoint >= 0x7f && codePoint <= 0x9f) ||
                codePoint === 0x061c ||
                (codePoint >= 0x200e && codePoint <= 0x200f) ||
                codePoint === 0x2028 ||
                codePoint === 0x2029 ||
                (codePoint >= 0x202a && codePoint <= 0x202e) ||
                (codePoint >= 0x2066 && codePoint <= 0x2069))) {
            return true;
        }
    }
    return false;
}
function parseAlertMessage(message) {
    if (!message || typeof message !== 'object') {
        return undefined;
    }
    let prototype;
    let commandDescriptor;
    let textDescriptor;
    try {
        if (Array.isArray(message)) {
            return undefined;
        }
        prototype = Object.getPrototypeOf(message);
        commandDescriptor = Object.getOwnPropertyDescriptor(message, 'command');
        textDescriptor = Object.getOwnPropertyDescriptor(message, 'text');
    }
    catch {
        return undefined;
    }
    if (prototype !== Object.prototype && prototype !== null) {
        return undefined;
    }
    if (!commandDescriptor ||
        !textDescriptor ||
        !Object.prototype.hasOwnProperty.call(commandDescriptor, 'value') ||
        !Object.prototype.hasOwnProperty.call(textDescriptor, 'value')) {
        return undefined;
    }
    const command = commandDescriptor.value;
    const candidateText = textDescriptor.value;
    if (command !== 'alert' || typeof candidateText !== 'string') {
        return undefined;
    }
    if (containsDisplayControlCharacter(candidateText)) {
        return undefined;
    }
    const text = candidateText.trim();
    if (text.length === 0 || text.length > 200) {
        return undefined;
    }
    return { command: 'alert', text };
}
//# sourceMappingURL=alertMessage.js.map