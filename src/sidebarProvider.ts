import { randomBytes } from 'crypto';
import type * as vscode from 'vscode';
import { dispatchAlertMessage } from './alertMessageHandler';

export interface SidebarProviderDependencies {
	joinPath(base: vscode.Uri, ...pathSegments: string[]): vscode.Uri;
	showInformationMessage(text: string): unknown;
}

export class SidebarProvider implements vscode.WebviewViewProvider {
	constructor(
		private readonly extensionUri: vscode.Uri,
		private readonly dependencies: SidebarProviderDependencies,
	) {}

	public resolveWebviewView(
		webviewView: vscode.WebviewView,
		_context: vscode.WebviewViewResolveContext,
		_token: vscode.CancellationToken,
	): void {
		webviewView.webview.options = {
			enableScripts: true,
			localResourceRoots: [this.dependencies.joinPath(this.extensionUri, 'media')]
		};

		webviewView.webview.html = this.getHtmlForWebview(webviewView.webview);

		const messageSubscription = webviewView.webview.onDidReceiveMessage(message => {
			dispatchAlertMessage(message, text => this.dependencies.showInformationMessage(text));
		});
		webviewView.onDidDispose(() => messageSubscription.dispose());
	}

	private getHtmlForWebview(webview: vscode.Webview): string {
		const nonce = getNonce();
		const scriptUri = webview.asWebviewUri(
			this.dependencies.joinPath(this.extensionUri, 'media', 'main.js')
		);
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
