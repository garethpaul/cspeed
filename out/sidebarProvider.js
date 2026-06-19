"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SidebarProvider = void 0;
const crypto_1 = require("crypto");
const alertMessageHandler_1 = require("./alertMessageHandler");
class SidebarProvider {
    constructor(extensionUri, dependencies) {
        this.extensionUri = extensionUri;
        this.dependencies = dependencies;
    }
    resolveWebviewView(webviewView, _context, _token) {
        webviewView.webview.options = {
            enableScripts: true,
            localResourceRoots: [this.dependencies.joinPath(this.extensionUri, 'media')]
        };
        webviewView.webview.html = this.getHtmlForWebview(webviewView.webview);
        const messageSubscription = webviewView.webview.onDidReceiveMessage(message => {
            (0, alertMessageHandler_1.dispatchAlertMessage)(message, text => this.dependencies.showInformationMessage(text));
        });
        webviewView.onDidDispose(() => messageSubscription.dispose());
    }
    getHtmlForWebview(webview) {
        const nonce = getNonce();
        const scriptUri = webview.asWebviewUri(this.dependencies.joinPath(this.extensionUri, 'media', 'main.js'));
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
exports.SidebarProvider = SidebarProvider;
function getNonce() {
    return (0, crypto_1.randomBytes)(16).toString('base64');
}
//# sourceMappingURL=sidebarProvider.js.map