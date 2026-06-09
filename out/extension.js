"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
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
            if (isAlertMessage(message)) {
                vscode.window.showInformationMessage(message.text);
            }
        });
    }
    _getHtmlForWebview(webview) {
        const nonce = getNonce();
        const contentSecurityPolicy = [
            "default-src 'none'",
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
	<script nonce="${nonce}">
		const vscode = acquireVsCodeApi();
		const button = document.getElementById('send-message');
		button.addEventListener('click', () => {
			vscode.postMessage({
				command: 'alert',
				text: 'Hello from the webview!'
			});
		});
	</script>
</body>
</html>`;
    }
}
function isAlertMessage(message) {
    if (!message || typeof message !== 'object') {
        return false;
    }
    const candidate = message;
    return candidate.command === 'alert' &&
        typeof candidate.text === 'string' &&
        candidate.text.trim().length > 0 &&
        candidate.text.length <= 200;
}
function getNonce() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let text = '';
    for (let i = 0; i < 32; i++) {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    return text;
}
//# sourceMappingURL=extension.js.map