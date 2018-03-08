var channels = ["johnmustacheyt","juniorcoju","thespoljo"]
var channelsOnline = 0;
var cha = 0;

timerChannels();
function timerChannels(){
	$('.streamers').html("");
	channelsOnline = 0;
	for(var i=0; i<channels.length; i++) {
		$.get( "https://api.twitch.tv/kraken/streams/"+channels[i], function( data ) {
		
		if(data.stream == null) {
			$("#streamoff").show();
		} else {
			setInterval(function()	{
			$("#streamoff").hide();
			}, 100);
			$('.streamers').append('<div class="streamer" data-viewers="'+data.stream.viewers+'">\
			<img src="'+data.stream.channel.logo+'">\
			<div class="sname"><a href="http://twitch.tv/'+data.stream.channel.name+'" target="_blank">'+data.stream.channel.name+'</a></div>\
			<div class="viewers"><i class="fa fa-circle-o online"></i> <b>'+data.stream.viewers+'</b> viewers, playing <b>'+data.stream.game+'</b></div>\
			</div>');
		}
		});
		
		channelsOnline++;
	}
}

setInterval(function()	{
	console.log('Loaded twitch script');
	timerChannels();
}, 30000);