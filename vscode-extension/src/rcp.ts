
import * as rpc from "@open-rpc/client-js";
import * as ev from "events";

const reqUri = 'request';
const resUri = 'response';



export class RcpService {
    private redeable: NodeJS.ReadableStream;
    private writable: NodeJS.WritableStream;
    private emitter = new ev.EventEmitter();
    private transport = new rpc.EventEmitterTransport(this.emitter, reqUri, resUri);
    private requestManager = new rpc.RequestManager([this.transport]);
    private client = new rpc.Client(this.requestManager);

    private notificationListeners: Array<(data: any) => void> = [];

    constructor(redeable: NodeJS.ReadableStream, writable: NodeJS.WritableStream) {

        this.redeable = redeable;
        this.writable = writable;


        try {
            let self = this;

            // Stdout daemon callback
            this.redeable.on('data', (data) => {
                self.emitRedeable(data);
            });

            // Stdin daemon callback
            this.emitter.on(reqUri, (data) => {
                let request = JSON.stringify(data);
                console.log(`Request sent: ${request}`);
                self.writable.write(request + '\n'); // Send the output correctly from server
            });

            this.client.onNotification((data) => {
                self.notificationListeners.forEach((callback) => callback(data));
            });
            this.client.onError((error: rpc.JSONRPCError) => {
                console.log(`Error ${error.message}`);
            });



        } catch (e) {
            console.log(e); // never called
        }

    }


    request(method: string, params?: any, timeout?: number): Promise<any> {
        return this.client.request(method, params, timeout);

    }
    

    onNotification(callback: (data: any) => void) {
        this.notificationListeners.push(callback);
    }

    private emitRedeable(data: any) {
        let list = `${data}`.split('\n').filter((e) => e.trim().length !== 0);
        if (list.length === 0) { return; }
        let responses = `[ ${list.join(', ')} ]`;
        console.log(`Response received: ${responses}`);
        this.emitter.emit(resUri, responses); 
    }

    dispose() {
        this.emitter.removeAllListeners();
    }

}

