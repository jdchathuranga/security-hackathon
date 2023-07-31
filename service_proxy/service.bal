import ballerina/http;

service / on new http:Listener(9090) {
    resource function get get(string baseUrl, string path) returns json|error {
        final http:Client httpClient = check new (baseUrl, timeout = 5);
        return check httpClient->get(string `${path}`);
    }
}
