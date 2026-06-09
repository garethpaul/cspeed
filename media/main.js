// This script will be run within the webview itself
// It cannot access the main VS Code APIs directly.

(function () {
	const vscode = acquireVsCodeApi();
	const button = document.getElementById('send-message');

	if (!button) {
		return;
	}

	button.addEventListener('click', () => {
		vscode.postMessage({
			command: 'alert',
			text: 'Hello from the webview!'
		});
	});
}());
