import * as vscode from 'vscode';

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
            localResourceRoots: [this._extensionUri]
        };

        webviewView.webview.html = this._getHtmlForWebview();

        // Handle messages from the webview
        webviewView.webview.onDidReceiveMessage(message => {
            switch (message.command) {
                case 'alert':
                    vscode.window.showInformationMessage(message.text);
                    return;
            }
        });
    }

    private _getHtmlForWebview(): string {
        return `
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Sidebar Webview</title>
            </head>
            <body>
                <h1>Hello from the sidebar!</h1>
                <button onclick="sendMessage()">Send Message</button>
                <script>
                    const vscode = acquireVsCodeApi();
                    
                    function sendMessage() {
                        vscode.postMessage({
                            command: 'alert',
                            text: 'Hello from the webview!'
                        });
                    }
                </script>
            </body>
            </html>
        `;
    }
}