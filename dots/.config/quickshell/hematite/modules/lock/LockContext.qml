import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked()
    signal failed()
    signal unlockFailed()

    property string currentText: ""
    property bool authInProgress: false
    property bool showFailure: false
    property bool fprintConfigured: false

    function tryUnlock() {
        if (currentText === "") return;

        root.authInProgress = true;
        pam.start();
    }

    /*
    function tryFPrintUnlock() {
        if (fprintConfigured) {
            fprintPam.start();
        }
    }

    function stopFPrintUnlock() {
        if (fprintPam.active) {
            fprintPam.abort();
        }
    }
    */

    PamContext {
        id: pam
        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText);
            }
        }
        onCompleted: result => {
            if (result == PamResult.Success) {
                root.unlocked();
            } else {
                root.currentText = "";
                root.showFailure = true;
            }

            root.unlockInProgress = false;
        }
    }

    /*
    Process {
        id: fingerprintCheckProc
        running: true
        command: ["bash", "-c", "fprintd-list $(whoami)"]
        stdout: StdioCollector {
            id: fingerprintOutputCollector
            onStreamFinished: {
                root.fingerprintsConfigured = fingerprintOutputCollector.text.includes("Fingerprints for user");
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                // console.warn("[LockContext] fprintd-list command exited with error:", exitCode, exitStatus);
                root.fingerprintsConfigured = false;
            }
        }
    }
    */
}