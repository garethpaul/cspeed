"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.dispatchAlertMessage = dispatchAlertMessage;
const alertMessage_1 = require("./alertMessage");
function dispatchAlertMessage(message, showAlert) {
    const alert = (0, alertMessage_1.parseAlertMessage)(message);
    if (!alert) {
        return false;
    }
    showAlert(alert.text);
    return true;
}
//# sourceMappingURL=alertMessageHandler.js.map