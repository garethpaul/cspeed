"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
const crypto_1 = require("crypto");
const vscode = require("vscode");
function activate(context) {
    const provider = new SidebarProvider(context.extensionUri);
    context.subscriptions.push(vscode.window.registerWebviewViewProvider('sidebarWebviewView', provider));
}
class SidebarProvider {
    constructor(_extensionUri) {
        this._extensionUri = _extensionUri;
    }
    resolveWebviewView(webviewView, _context, _token) {
        webviewView.webview.options = {
            enableScripts: true,
            localResourceRoots: [vscode.Uri.joinPath(this._extensionUri, 'media')]
        };
        webviewView.webview.html = this._getHtmlForWebview(webviewView.webview);
        webviewView.webview.onDidReceiveMessage(message => {
            const alert = parseAlertMessage(message);
            if (alert) {
                vscode.window.showInformationMessage(alert.text);
            }
        });
    }
    _getHtmlForWebview(webview) {
        const nonce = getNonce();
        const scriptUri = webview.asWebviewUri(vscode.Uri.joinPath(this._extensionUri, 'media', 'main.js'));
        const contentSecurityPolicy = [
            "default-src 'none'",
            "base-uri 'none'",
            "form-action 'none'",
            `img-src ${webview.cspSource}`,
            `style-src ${webview.cspSource}`,
            `script-src 'nonce-${nonce}'`
        ].join('; ');
        return `<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="Content-Security-Policy" content="${contentSecurityPolicy}">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Sidebar Webview</title>
</head>
<body>
	<h1>Hello from the sidebar!</h1>
	<button id="send-message" type="button">Send Message</button>
	<script nonce="${nonce}" src="${scriptUri}"></script>
</body>
</html>`;
    }
}
function parseAlertMessage(message) {
    if (!message || typeof message !== 'object' || Array.isArray(message)) {
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
function getNonce() {
    return (0, crypto_1.randomBytes)(16).toString('base64');
}
//# sourceMappingURL=extension.js.map