import ballerina/http;
import ballerina/log;

configurable string log_test = ?;

service /command on new http:Listener(9000){
	resource function get prompt(string command) returns string {
        log:printInfo("Test Configurable: " + log_test);
        return runCommand(command);
    }
}
