

import * as vscode from 'vscode';

import * as cp from 'child_process';
import { RcpService } from './rcp';
const kill = require('tree-kill');


const isActiveContext = 'flutter_preview.isActive';
var rcpService: RcpService;

export class PreviewService {
    private readonly disposables: vscode.Disposable[] = [];

    private readonly workspaceUri: vscode.Uri;
    private childProcess: cp.ChildProcess | undefined;
    public isActive: Boolean = false;


    private currentDocument: vscode.Uri | undefined;

    private rcpService: RcpService | undefined;

    constructor(workspaceUri: vscode.Uri) {
        this.workspaceUri = workspaceUri;
    }

    async start() {
        let self = this;
        if (this.isActive && vscode.debug.activeDebugSession?.name === 'Flutter Preview') {
            vscode.window.showInformationMessage('Flutter preview is already running');
            return;
        }
        this.isActive = true;
        vscode.commands.executeCommand("setContext", isActiveContext, true);
        await this.launchDartPreviewProccess();

        let disp = vscode.workspace.onDidSaveTextDocument((e) => { self.onDidSaveTextEditor(e); });
        let disp2 = vscode.window.onDidChangeActiveTextEditor((e) => {
            self.onDidUpdateActiveTextEditor();
        });
        this.disposables.push(disp, disp2);
        this.onDidUpdateActiveTextEditor();
    }

    async launchDartPreviewProccess() {
        let self = this;
        console.log('Set up dart process');
        try {

    
            this.childProcess = cp.spawn('flutter', [
                'pub',
                'run',
                'preview:preview'
            ], { cwd: this.workspaceUri.fsPath, shell: true });

            rcpService = new RcpService(this.childProcess!.stdout!, this.childProcess!.stdin!);
            var sr = this.rcpService;
            var ch = this.childProcess;

            rcpService.onNotification((data) => {
                if (data['method'] === 'preview.restart') {
                    vscode.commands.executeCommand('flutter.hotRestart');
                } else if (data['method'] === 'preview.launch') {
                    let port = data['params']['port'];
                    self.launchDebugSession(port);

                }
            });
            console.log('Finish Set up dart process');
            this.childProcess?.on('error', (err) => {
              //  this.cancel();
                console.log('Error dart process: ', err.toString());
            });

          

            this.childProcess?.stderr?.on('data',
                function (data) {
                    console.log('err data: ' + data);
                }
            );
        } catch (e) {
            console.log(e);
        }
    }





    private async launchDebugSession(port: number) {

        const launchConfiguration = {
            type: "dart",
            name: "Flutter Preview",
            request: "launch",
            // deviceId: "macOS",
            cwd: "",
            internalConsoleOptions: "neverOpen",
            args: [
                "--target=lib/main.preview.dart",
                "--dart-define=flutter.preview=true",
                `--dart-define=preview.port=${port}`
            ],
        };

        const launched = await vscode.debug.startDebugging(vscode.workspace.workspaceFolders![0], launchConfiguration);
        if (!launched) {
            vscode.window.showInformationMessage('Flutter is not ready');
            this.cancel();
            return;
        }
        let disp = vscode.debug.onDidTerminateDebugSession((e) =>
            this.cancel()
        );
        this.disposables.push(disp);
    }


    cancel() {
        console.log('cancel session');

        this.isActive = false;
        this.rcpService?.dispose();
        this.rcpService = undefined;
        if (this.childProcess !== undefined) {
            kill(this.childProcess.pid, 'SIGKILL');
        }
        this.childProcess = undefined;
        this.disposables.forEach((s) => s.dispose());
        vscode.commands.executeCommand("setContext", isActiveContext, false);
    }






    onDidSaveTextEditor(document: vscode.TextDocument) {
        if (document.languageId === "dart" && document.uri === this.currentDocument) {
            this.onDidUpdateActiveTextEditor();
        }
    };



    onDidUpdateActiveTextEditor() {
        const editor = vscode.window.activeTextEditor;
        this.currentDocument = editor?.document?.uri;
       
        let relativePath = vscode.Uri.file(this.currentDocument!.fsPath.replace(this.workspaceUri.fsPath, ''));
        const path = relativePath.path.toString().replace('/', '');

        rcpService.request('preview.setActiveFile', { path: path }).then((needsHotReload) => {

            if (needsHotReload) {
                vscode.commands.executeCommand('flutter.hotReload');
            }
        });
    };

    dispose() {

        this.cancel();
    }
}