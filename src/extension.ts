import { randomBytes } from 'crypto';
import * as vscode from 'vscode';
import { dispatchAlertMessage } from './alertMessageHandler';

export function activate(context: vscode.ExtensionContext) {
	const provider = new SidebarProvider(context.extensionUri);
	context.subscriptions.push(
		vscode.window.registerWebviewViewProvider('sidebarWebviewView', provider)
	);
}

class SidebarProvider implements vscode.WebviewViewProvider {
	constructor(private readonly _extensionUri: vscode.Uri) {}

	public resolveWebviewView(
		webviewView: vscode.WebviewView,
		_context: vscode.WebviewViewResolveContext,
		_token: vscode.CancellationToken,
	) {
		webviewView.webview.options = {
			enableScripts: true,
			localResourceRoots: [vscode.Uri.joinPath(this._extensionUri, 'media')]
		};

		webviewView.webview.html = this._getHtmlForWebview(webviewView.webview);

		webviewView.webview.onDidReceiveMessage(message => {
			dispatchAlertMessage(message, text => vscode.window.showInformationMessage(text));
		});
	}

	private _getHtmlForWebview(webview: vscode.Webview): string {
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

function getNonce(): string {
	return randomBytes(16).toString('base64');
}
