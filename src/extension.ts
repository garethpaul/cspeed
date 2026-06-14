import * as vscode from 'vscode';
import { SidebarProvider } from './sidebarProvider';

export function activate(context: vscode.ExtensionContext) {
	const provider = new SidebarProvider(context.extensionUri, {
		joinPath: vscode.Uri.joinPath,
		showInformationMessage: text => vscode.window.showInformationMessage(text)
	});
	context.subscriptions.push(
		vscode.window.registerWebviewViewProvider('sidebarWebviewView', provider)
	);
}
