$(document).ready(function() {
	$(".toggle-mquestions").bind('click', function() {
		$(".mquestions").toggle();
		$(this).text($(".toggle-mquestions").text() == "Ocultar preguntas" ? "Mostrar preguntas" : "Ocultar preguntas");
	});
});