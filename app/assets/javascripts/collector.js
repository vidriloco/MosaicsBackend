var remoteMetaSurveyId=null;
var applicationURL = "127.0.0.1:3000";
var apiPath = "/api/evaluation/?/new";

var loadRemoteMetaSurvey = function() {
	if(remoteMetaSurveyId!=null) {
		apiPath=apiPath.replace( "?", remoteMetaSurveyId);
		$.ajax({
		  type: "GET",
		  url: apiPath
		});
	}
}

$(document).ready(function() {
	loadRemoteMetaSurvey();
});