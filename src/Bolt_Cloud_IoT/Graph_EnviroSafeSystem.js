setChartLibrary('google-chart');
setChartTitle('Enviro Safe Indoor Smart System');


$("#muliple_graph_span").append("<hr style=border-width:7><h3 style=background-color:#ADD8E6;color:#4682B4;\
border-radius:30px;padding:10px><u><b>LPG Concentration Graph</b></u></h3>");
var lineGraph1 = new boltGraph();
lineGraph1.setChartType("lineGraph");
lineGraph1.setAxisName('Time','GPL [ppm]');
lineGraph1.plotChart('time_stamp','lpg');

$("#muliple_graph_span").append("<hr style=border-width:7><h3 style=background-color:#ADD8E6;color:#4682B4;\
border-radius:30px;padding:10px><u><b>Carbon Monoxide Concentration Graph</b></u></h3>");
var lineGraph2 = new boltGraph();
lineGraph2.setChartType("lineGraph");
lineGraph2.setAxisName('Time','CO [ppm]');
lineGraph2.plotChart('time_stamp','cbm');

$("#muliple_graph_span").append("<hr style=border-width:7><h3 style=background-color:#ADD8E6;color:#4682B4;\
border-radius:30px;padding:10px><u><b>Temperature Graph</b></u></h3>");
var lineGraph3 = new boltGraph();
lineGraph3.setChartType("lineGraph");
lineGraph3.setAxisName('Time','Average Temperature [°C]');
lineGraph3.plotChart('time_stamp','avg_temp');

$("#muliple_graph_span").append("<hr style=border-width:7><h3 style=background-color:#ADD8E6;color:#4682B4;\
border-radius:30px;padding:10px><u><b>Humidity Graph</b></u></h3>"); 
var lineGraph4 = new boltGraph();
lineGraph4.setChartType("lineGraph");
lineGraph4.setAxisName('Time','Average Humidity [%RH]');
lineGraph4.plotChart('time_stamp','avg_hum');

$("#muliple_graph_span").append("<hr style=border-width:7><h3 style=background-color:#ADD8E6;color:#4682B4;\
border-radius:30px;padding:10px><u><b>Flame Detected Graph</b></u></h3>");
var lineGraph5 = new boltGraph();
lineGraph5.setChartType("lineGraph");
lineGraph5.setAxisName('Time','Flame');
lineGraph5.plotChart('time_stamp','flame');

$("#muliple_graph_span").append("<hr style=border-width:7><h6 style=text-align:right> Designed by Giuseppe Pirilli</h6>");
