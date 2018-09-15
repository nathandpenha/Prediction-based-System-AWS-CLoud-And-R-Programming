$(document).ready(function() {
	$.ajax({
		url: 'http://localhost:9191/market',
		type: 'GET',
		success: function(data){
			var dis ="";
			for (i = 0 ; i<data.length; ++i){
			 dis +='<li>'
				+'<div class="block">'
				+'<div class="tags">'
				+'<a href="" class="tag">'
				+'<span>'+data[i].support+'</span>'
				+'</a>'
				+	'</div>'
				+'<div class="block_content">'
				+	'<h2 class="title">'
				+'<a>'+((data[i].items).replace("{","").replace("}","").replace("/",""))+'</a>'
				+	'</h2>'
				+	'<p class="excerpt">Count : '+data[i].count+'</a>'
				+	'</p>'
				+'</div>'
				+'</div>'
				+'</li>';
			}
			$("#listItems").append(dis);
		}
	});
});
