$(document).ready(function() {
	$.ajax({
		url: 'http://0.0.0.0:9191/totalRecords',
		type: 'GET',
		success: function(success){
			$(".totalRecords").html(success);
		},
	});
	$.ajax({
		url: 'http://0.0.0.0:9191/totalProducts',
		type: 'GET',
		success: function(success){
			$(".totalProducts").html(success);
		},
	});
	$.ajax({
		url: 'http://0.0.0.0:9191/users',
		type: 'GET',
		success: function(success){
			$(".users").html(success);
		},
	});
	$.ajax({
		url: 'http://0.0.0.0:9191/profit',
		type: 'GET',
		success: function(success){
			$(".profit").html("$ "+success);
		},
	});
	$.ajax({
		url: 'http://0.0.0.0:9191/segmentData',
		type: 'GET',
		success: function(success){
			js = success[0].split(",");
			label = [];
			values = [];
			for (i = 0 ; i < js.length; i++){
				x = js[i].replace(/"/g,'').replace(/\[/g,'').replace(/]/g,'');
				sp = x.split(":");
				label.push(sp[0].trim());
				values.push(sp[1].trim());
			}
			var chart_doughnut_settings = {
				type: 'doughnut',
				tooltipFillColor: "rgba(51, 51, 51, 0.55)",
				data: {
					labels: label,
					datasets: [{
						data: values,
						backgroundColor: [
							"#BDC3C7",
							"#9B59B6",
							"#E74C3C",
						],
						hoverBackgroundColor: [
							"#CFD4D8",
							"#B370CF",
							"#E95E4F",
						]
					}]
				},
				options: {
					legend: false,
					responsive: false
				}
			};
			$('.segment').each(function(){
				var chart_element = $(this);
				var chart_doughnut = new Chart( chart_element, chart_doughnut_settings);
			});
		},
	});
	$.ajax({
		url: 'http://0.0.0.0:9191/ship',
		type: 'GET',
		success: function(data){
			var morris = Morris.Bar({
				element: 'graph_bar1',
				data: data,
				xkey: 'label',
				ykeys: ['value'],
				labels: ['Used by Customers'],
				barRatio: 0.4,
				barColors: ['#26B99A', '#34495E', '#ACADAC', '#3498DB'],
				xLabelAngle: 35,
				hideHover: 'false',
				resize: true
			});
			console.log(data);
			//morris.setData(data);
		}
	});
});
//
