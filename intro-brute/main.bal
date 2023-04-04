import ballerina/io;
import ballerina/http;
import ballerina/url;
import ballerina/uuid;

configurable string client_id = ?;
configurable string client_secret = ?;
configurable string introspect_base_url = ?;
configurable string introspect_path = ?;

http:Client apiClient = check new (introspect_base_url, auth = {
    username: client_id,
    password: client_secret
}, timeout = 10, httpVersion = "1.1");

public function main() returns error? {
    int loop = 0;
    while (true) {
        io:println(string ` ${loop}`);
        loop += 1;
        error? introspectResult = introspect();
    }
}

public function introspect() returns error? {
    string accessToken = uuid:createType1AsString();
    string dataString = check url:encode(accessToken, "UTF-8");
    string sendPayload = string `token=${dataString}`;

    io:print(string `${accessToken} `);

    http:Response|http:ClientError result = apiClient->post(
            introspect_path,
            sendPayload,
            {"Content-Type": "application/x-www-form-urlencoded"});

    if (result is http:ClientError) {
    } else {
        if (result.statusCode == 200) {
            json|error payload = check result.getJsonPayload();
            if (payload is json) {
                io:print(string ` HTTP STATUS ${result.statusCode} ${payload.toString()}`);
                Introspect introspect = check payload.cloneWithType();
                io:println(string `${accessToken} : ${introspect.email}`);

            }
        } else {
            io:println(result.statusCode);
        }
    }
}

public type Introspect record {|
    string email;
|};
