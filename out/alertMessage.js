"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseAlertMessage = parseAlertMessage;
function parseAlertMessage(message) {
    if (!message || typeof message !== 'object' || Array.isArray(message)) {
        return undefined;
    }
    const prototype = Object.getPrototypeOf(message);
    if (prototype !== Object.prototype && prototype !== null) {
        return undefined;
    }
    const candidate = message;
    if (!Object.prototype.hasOwnProperty.call(candidate, 'command') ||
        !Object.prototype.hasOwnProperty.call(candidate, 'text')) {
        return undefined;
    }
    if (candidate.command !== 'alert' || typeof candidate.text !== 'string') {
        return undefined;
    }
    const text = candidate.text.trim();
    if (text.length === 0 || text.length > 200 || /[\r\n]/.test(text)) {
        return undefined;
    }
    return { command: 'alert', text };
}
//# sourceMappingURL=alertMessage.js.map