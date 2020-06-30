

import * as vscode from 'vscode';
import { ChildProcess } from 'child_process';

const spawn = require('child_process').spawn;

const isActiveContext = 'flutter_preview.isActive';


export class PreviewService {
    private readonly disposables: vscode.Disposable[] = [];

    private readonly path: String;
    private process: ChildProcess | undefined;
    public isActive: Boolean = false;

    private currentDocument: vscode.Uri | undefined;

    constructor(path: String) {
        this.path = path;
    }


    async start() {
        if (this.isActive && vscode.debug.activeDebugSession?.name === 'Flutter Preview') {
            vscode.window.showInformationMessage('Flutter preview is already running');
            return;
        }
        this.isActive = true;
        vscode.commands.executeCommand("setContext", isActiveContext, true);
        await this.launchAnalyticsProccess();
        await this.launchDebugSession();
        let disp = vscode.workspace.onDidSaveTextDocument((e) => { this.saveTextEditor(e); });
        let disp2 = vscode.window.onDidChangeActiveTextEditor((e) => {

            this.updateActiveTextEditor();
        });
        this.disposables.push(disp, disp2);
        this.updateActiveTextEditor();
    }

    launchAnalyticsProccess() {
        try {
            this.process = spawn('flutter', [
                'pub',
                'run',
                'preview:run'
            ], { cwd: this.path });


            this.process?.on('exit', (code) => {
                console.log('child process exited with code : ', code);
            });


            this.process?.on('error', (err) => {
                console.log('Error: ', err.toString());
            });
            this.process?.stdout?.on('data', function (data) {
                if (`${data}` === 'Needs reload\n') {
                    console.log('Hot reload');
                    vscode.commands.executeCommand('flutter.hotReload');
                } if (`${data}` === 'Needs restart\n') {
                    console.log('Hot Restart');
                    vscode.commands.executeCommand('flutter.hotRestart');
                } else {
                    console.log("Got data from child: " + data);
                }

            });

            this.process?.stderr?.on('data',
                function (data) {
                    console.log('err data: ' + data);
                }
            );
        } catch (e) {
            console.log(e);
        }
    }


    private async launchDebugSession() {

        const launchConfiguration = {
            type: "dart",
            name: "Flutter Preview",
            request: "launch",
            deviceId: "macOS",
            cwd: "",
            internalConsoleOptions: "neverOpen",
            args: [
                "--target=lib/main.preview.dart"
            ],
        };

        const launched = await vscode.debug.startDebugging(vscode.workspace.workspaceFolders![0], launchConfiguration);
        if (!launched) {
            vscode.window.showInformationMessage('Flutter is not ready');
            this.cancel();
            return;
        }
        let disp = vscode.debug.onDidTerminateDebugSession(() =>
            this.cancel()
        );
        this.disposables.push(disp);
    }


    cancel() {
        this.isActive = false;
        console.log('cancel session');
        this.process?.kill();
        this.process = undefined;
        this.disposables.forEach((s) => s.dispose());
        vscode.commands.executeCommand("setContext", isActiveContext, false);
    }




    saveTextEditor(document: vscode.TextDocument) {
        console.log(document.uri === this.currentDocument);
        if (document.languageId === "dart" && document.uri === this.currentDocument) {
            this.updateActiveTextEditor();
        }
    };



    updateActiveTextEditor() {
        const editor = vscode.window.activeTextEditor;
        this.currentDocument = editor?.document?.uri;
        const path = this.currentDocument!.toString().split(":")[1].replace(this.path + '/', '');
        this.process?.stdin?.write(path + '\n');
    };

    dispose() {
        this.disposables.forEach((s) => s.dispose());
    }




}