import ballerina/jballerina.java;

function runCommand(string command) returns string {
handle runTimeHandle = getRuntime();
    handle|error execHandle = exec(runTimeHandle, java:fromString(command));
    
    if (execHandle is handle) {
        handle execStream = getInputStream(execHandle);

        handle inputStreamReader = newInputStreamReader(execStream);

        handle bufferedReader = newBufferedReader(inputStreamReader);

        string output = "";
        while (true) {
            handle|error readLineHandle = readLine(bufferedReader);
            if (readLineHandle is handle) {
                // io:println(`> ${readLineHandle}`);
                string line = string `> ${readLineHandle.toString()}`;
                if line == "> " || line == "> null" {
                    break;
                } else {
                    output += line + "\n";
                }

            } else {
                break;
            }
        }
        return output;
    } else {
        return "Error running the command" + execHandle.toString();
    }
}

function readLine(handle bufferedReader) returns handle | error = @java:Method {
     'class: "java.io.BufferedReader"
} external;

function newBufferedReader(handle inputStreamReader) returns handle = @java:Constructor {
     'class: "java.io.BufferedReader"
} external;


function newInputStreamReader(handle inputStream) returns handle = @java:Constructor {
     'class: "java.io.InputStreamReader"
} external;

function getInputStream(handle execHandle) returns handle = @java:Method {
    'class: "java.lang.Process"
} external;

function getRuntime() returns handle = @java:Method {
   'class: "java.lang.Runtime"
} external;

function exec(handle command, handle e) returns handle | error = @java:Method {
    name: "exec",
   'class: "java.lang.Runtime"
} external;