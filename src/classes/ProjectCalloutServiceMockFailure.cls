@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request){
		HttpResponse response = new HttpResponse();
        response.setStatusCode(500);
        return response;
    }
}