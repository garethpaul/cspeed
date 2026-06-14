"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
const vscode = require("vscode");
const sidebarProvider_1 = require("./sidebarProvider");
function activate(context) {
    const provider = new sidebarProvider_1.SidebarProvider(context.extensionUri, {
        joinPath: vscode.Uri.joinPath,
        showInformationMessage: text => vscode.window.showInformationMessage(text)
    });
    context.subscriptions.push(vscode.window.registerWebviewViewProvider('sidebarWebviewView', provider));
}
//# sourceMappingURL=extension.js.map