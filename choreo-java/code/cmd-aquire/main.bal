import ballerina/http;

service /command on new http:Listener(9000){
	resource function get prompt(string command) returns string {
        return runCommand(command, 30);
    }
}
