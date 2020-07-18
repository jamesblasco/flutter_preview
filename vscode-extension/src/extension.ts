// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';
import fs = require("fs");
import path = require("path");
import { ChildProcess } from 'child_process';
import { PreviewService } from './preview';


const spawn = require('child_process').spawn;


const isActiveContext = 'flutter_preview.isActive';


var service: PreviewService | undefined;


export function activate(context: vscode.ExtensionContext) {

	console.log('Congratulations, your extension "flutter-preview" is now active!');

	vscode.commands.executeCommand("setContext", isActiveContext, false);
	vscode.commands.executeCommand("flutter-preview.activate");


	let disposable2 = vscode.commands.registerCommand('flutter-preview.activate', () => {


		// The code you place here will be executed every time your command is executed

		if (vscode.workspace.workspaceFolders) {
			const folderPath = vscode.workspace.workspaceFolders[0].uri;
			
			service?.dispose();
			service = new PreviewService(folderPath);


		} else {
			vscode.window.showInformationMessage('No Workspace Found');
		}


	});

	


	let disposable = vscode.commands.registerCommand('flutter-preview.run', () => {
		service?.start();
	});


	//	envStatusBarItem.command = disposable;
	context.subscriptions.push(disposable);
}


// this method is called when your extension is deactivated
export function deactivate() {
	service?.dispose();
	service = undefined;
}
