The design of the API endpoints will be that they make the request then return the response from the request.
Their input will be the RestClient (authenticated), and any Structs representing the objects necessary to make the request.
For example when you create a course, you call Api.Courses.post_course. Input is a RestClient and a Course.

Every one requires an authenticated RestClient, except for the system/version endpoint.

The RestClient contains an fqdn field indicating the Learn host that recieves the request.

These endpoints will NOT convert the JSON into an object. Their sole purpose is to return the response from the server 
specfied in the RestClient.
