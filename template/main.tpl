<html lang="en"><head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>CSGOBANANAS.COM</title>
		<link href="/template/css/bootstrap.min.new.css" rel="stylesheet">
<link href="/template/css/font-awesome.min.css" rel="stylesheet">
<link href="/template/css/dataTables.bootstrap.min.css" rel="stylesheet">

<link href="/template/css/mineNew.css?v=5" rel="stylesheet">
<link id="style" href="" rel="stylesheet">

<!-- <link href="/template/css/dark.css" rel="stylesheet"> -->

<link rel="shortcut icon" href="favicon.ico">

<script src="/template/js/jquery-1.11.1.min.js"></script>
<script src="/template/js/jquery.cookie.js"></script>
<script src="/template/js/socket.io-1.4.5.js"></script>
<script src="/template/js/bootstrap.min.js"></script>
<script src="/template/js/bootbox.min.js"></script>
<script src="/template/js/jquery.dataTables.min.js"></script>
<script src="/template/js/dataTables.bootstrap.js"></script>
<script src="/template/js/tinysort.js"></script>
<script src="/template/js/expanding.js"></script>
<script src="/template/js/twitch.js"></script>
<script src="/template/js/theme.js"></script>
<script>
	var SETTINGS = ["confirm","sounds","dongers","hideme"];
	function inlineAlert(x,y){
		$("#inlineAlert").removeClass("alert-success alert-danger alert-warning hidden");
		if(x=="success"){
			$("#inlineAlert").addClass("alert-success").html("<i class='fa fa-check'></i><b> "+y+"</b>");
		}else if(x=="error"){
			$("#inlineAlert").addClass("alert-danger").html("<i class='fa fa-exclamation-triangle'></i> "+y);
		}else if(x=="cross"){
			$("#inlineAlert").addClass("alert-danger").html("<i class='fa fa-times'></i> "+y);
		}else{
			$("#inlineAlert").addClass("alert-warning").html("<b>"+y+" <i class='fa fa-spinner fa-spin'></i></b>");
		}
	}
	function resizeFooter(){
		var f = $('.footer').outerHeight(true);
		var w = $(window).outerHeight(true);
		$('body').css('margin-bottom',f);
	}
	$(window).resize(function(){
		resizeFooter();
	});
	if (!String.prototype.format) {
	  String.prototype.format = function() {
	    var args = arguments;
	    return this.replace(/{(\d+)}/g, function(match, number) { 
	      return typeof args[number] != 'undefined'
	        ? args[number]
	        : match
	      ;
	    });
	  };
	}
	function setCookie(key,value){
		var exp = new Date();
		exp.setTime(exp.getTime()+(365*24*60*60*1000));
		document.cookie = key+"="+value+"; expires="+exp.toUTCString();
	}
	function getCookie(key){
		var patt = new RegExp(key+"=([^;]*)");
		var matches = patt.exec(document.cookie);
		if(matches){
			return matches[1];
		}
		return "";
	}
	function formatNum(x){
		if(Math.abs(x)>=10000){
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		return x;
	}
	$(document).ready(function(){
		resizeFooter();
		for(var i=0;i<SETTINGS.length;i++){
			var v = getCookie("settings_"+SETTINGS[i]);
			if(v=="true"){
				$("#settings_"+SETTINGS[i]).prop("checked",true);	
			}else if(v=="false"){
				$("#settings_"+SETTINGS[i]).prop("checked",false);	
			}			
		}
	});
</script>
		<style>
		.navbar{
			margin-bottom: 0px;
		}
		.progress-bar{
			transition:         none !important;
			-webkit-transition: none !important;
			-moz-transition:    none !important;
			-o-transition:      none !important;
		}
		#case {

			max-width: 1050px;
			height: 69px;
			background-image: url("/template/img/cases.png");
			background-repeat: no-repeat;
			background-position: 0px 0px;
			position: relative;
			margin:0px auto;

		}	
		</style>
		<script type="text/javascript" src="/template/js/new.js?v=<?=time()?>"></script>	</head>
	<body style="margin-bottom: 62px;">
		<nav class="navbar navbar-default navbar-static-top" role="navigation">
	<div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!-- <a class="navbar-brand" style="padding-top:0px;padding-bottom:0px;padding-right:0px" href="./"><img alt="CSGO.mk" height="34" style="margin-top:8px;margin-bottom:8px;margin-right:5px" src="/template/img/just.png"></a> -->
            <a class="navbar-brand" href="/"><div id="logo" class="logo"></div></a>
		</div>
		<div id="navbar" class="navbar-collapse collapse">
			<ul class="nav navbar-nav">
				<li class="" style="margin-left:5px"><a href="/">Home</a></li>
				<li class=""><a href="/deposit">Deposit</a></li>
				<li class=""><a href="/withdraw">Withdraw</a></li>
				<li class=""><a href="/rolls">Provably Fair</a></li>
				<li class=""><a href="/affiliates">Affiliates</a></li>
				<li><a href="#" data-toggle="modal" data-target="#promoModal">Free coins</a></li>
				<li class=""><a href="/support">Support</a></li>
			</ul>
			<? if($user): ?>
				<ul class="nav navbar-nav navbar-right">
						<!-- <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a></li> -->
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false" style="padding-top:0px;padding-bottom:0px;line-height:50px"> <img class="rounded" src="<?=$user['avatar']?>"> <b><?=$user['name']?></b> <span class="caret"></span></a>
					<ul class="dropdown-menu" role="menu">
						<!-- <li><a href="#" data-toggle="modal" data-target="#pointsModal"><i class="fa fa-user fa-fw"></i> Profile</a></li> -->
						<li><a href="#" data-toggle="modal" data-target="#promoModal"><i class="fa fa-ticket fa-fw"></i> Redeem</a></li>
						<!-- <li><a href="bets.php"><i class="fa fa-line-chart fa-fw"></i> Bet History</a></li> -->
						<li><a href="/offers"><i class="fa fa-history fa-fw"></i> Trade history</a></li>
						<li><a href="/transfers"><i class="fa fa-exchange fa-fw"></i> Transfer history</a></li>
						<!-- <li><a href="#" data-toggle="modal" data-target="#sendModal"><i class="fa fa-exchange fa-fw"></i> Send Credits</a></li> -->
						<li><a href="#" data-toggle="modal" data-target="#settingsModal"><i class="fa fa-cog fa-fw"></i> Settings</a></li>

						<li><a href="#" data-toggle="modal" data-target="#my64id"><i class="fa fa-question-circle"></i> My Steam64Id</a></li>
						
						
						
                        <li class="divider"></li>
						<li><a href="/exit"><i class="fa fa-power-off fa-fw"></i> Logout</a></li>
					</ul>
				</li>
						</ul>
			<? else: ?>
			<ul class="nav navbar-nav navbar-right">
				<a href="/login"><img style="margin-top:3px;" src="/template/img/green.png"></a>
			</ul>
			<? endif; ?>
		</div>
	</div>
</nav>
<div class="modal fade" id="my64id">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><b>My Steam64Id</b></h4>
			</div>
			<div class="modal-body">
				<b><?=($user)?$user['steamid']:''?></b>			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="settingsModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><b>Settings</b></h4>
			</div>
			<div class="modal-body">
				<form>	  			        	
								  
				  	<div class="checkbox">
				    	<label>
				      		<input type="checkbox" id="settings_confirm" checked>
				      		<strong>Confirm all bets over 10,000 coins</strong>
				    	</label>
				  	</div>
				  	<div class="checkbox">
				    	<label>
				      		<input type="checkbox" id="settings_sounds" checked>
				      		<strong>Enable sounds</strong>
				    	</label>
				  	</div>
				  	<div class="checkbox">
				    	<label>
				      		<input type="checkbox" id="settings_dongers">
				      		<strong>Display in $ amounts</strong>
				    	</label>
				  	</div>
				  	<div class="checkbox">
				    	<label>
				      		<input type="checkbox" id="settings_hideme">
				      		<strong>Hide my profile link in chat</strong>
				    	</label>
				  	</div>
				  	
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-success" onclick="saveSettings()">Save changes</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="promoModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><b>Redeem Promo Code!</b></h4>
			</div>
			<div class="modal-body">
				
				<div class="form-group">
					<label for="exampleInputEmail1">Promo code</label>
					<input type='text' class='form-control' id='promocode' value=''>				</div>				  	
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-success" onclick="redeem()">Reedem</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="chatRules">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><b>Chat Rules</b></h4>
			</div>
			<div class="modal-body" style="font-size:24px">				  
				<ol>
					<li>No Spamming</li>
					<li>No Begging for Coins</li>
					<li>No Posting Promo Codes</li>
					<li>No CAPS LOCK</li>
					<li>No Promo Codes in Profile Name</li>
					</ol>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-success btn-block" data-dismiss="modal">Got it!</button>
			</div>
		</div>
	</div>
</div>
<script>
function saveSettings(){
	for(var i=0;i<SETTINGS.length;i++){
		setCookie("settings_"+SETTINGS[i],$("#settings_"+SETTINGS[i]).is(":checked"));
	}
	$("#settingsModal").modal("hide");
	if($("#settings_dongers").is(":checked")){
		$("#balance").html("please reload");
	}else{
		$("#balance").html("please reload");
	}
}
function redeem(){
	var code = $("#promocode").val();
	$.ajax({
		url:"/redeem?code="+code,
		success:function(data){		
			try{
				data = JSON.parse(data);
				console.log(data);
				if(data.success){
					bootbox.alert("Success! You've received "+data.credits+" credits.");					
				}else{
					bootbox.alert(data.error);
				}
			}catch(err){
				bootbox.alert("Javascript error: "+err);
			}
		},
		error:function(err){
			bootbox.alert("AJAX error: "+err);
		}
	});
}
</script>			<ul id="contextMenu" class="dropdown-menu" role="menu" style="display:none">
				<li><a tabindex="-1" href="#" data-act="0">Username</a></li>
			    <li><a tabindex="-1" href="#" data-act="1">Mute player</a></li>
			    <li><a tabindex="-1" href="#" data-act="2">Kick player</a></li>
			    <li><a tabindex="-1" href="#" data-act="3">Send coins</a></li>
			    <li><a tabindex="-1" href="#" data-act="4">Ignore</a></li>
			</ul>			
			<div class="col-xs-3">
	<div id="pullout">
		<div id="tab1" class="tab-group" style="height: 515px;">
			<div class="dropdown" style="margin: -10px; font-family: 'Ubuntu-Medium'; font-size: 13px; padding: 20px; padding-bottom: 10px; text-align: center;">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="true">
					<span class="lang-select">MAIN ROOM </span><span class="caret"></span></a>
				<ul class="dropdown-menu language" role="menu" style="width: 100%; border: 0px; box-shadow: 0 0 0;">
					<li><a onclick="changeLang(1)" href="#">MAIN ROOM </a></li>
					<li><a onclick="changeLang(2)" href="#">PREDICT ROOM </a></li>
					<li><a onclick="changeLang(3)" href="#">MULTI-LANGUAGE ROOM </a></li>
					<li><a onclick="changeLang(4)" href="#">TRADE ROOM </a></li>
				</ul>
			</div>
			<div style="width: 106,5%;
height: 80px;
margin: 10px -10px -80px -10px;
"></div>
			<div class="divchat" id="chatArea"></div>
			<form id="chatForm">
				<div style="margin: 5px">
					<div class="input-group" style="margin-bottom: 5px">
						<input type="text" class="form-control" placeholder="Type here to chat..." id="chatMessage" maxlength="200">
						<div class="input-group-btn dropup">
							<button id="Smiles" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" type="button" class="btn btn-default dropdown-toggle" aria-label="Smiles">
								<span class="glyphicon fa fa-smile-o fa-lg"></span>
							</button>
							<ul class="dropdown-menu smiles" style="padding: 10px;" aria-labelledby="Smiles">
    							<li>
    								<img data-smile="BibleThump" src="/template/img/twitch/BibleThump.png">
    								<img data-smile="CA" src="/template/img/twitch/CA.png">
    								<img data-smile="CO" src="/template/img/twitch/CO.png">
    								<img data-smile="Tb" src="/template/img/twitch/Tb.png">
    								<img data-smile="deIlluminati" src="/template/img/twitch/deIlluminati.png">
    							</li>
    							<li>
    								<img data-smile="Fire" src="/template/img/twitch/Fire.png">
    								<img data-smile="Kappa" src="/template/img/twitch/Kappa.png">
    								<img data-smile="KappaPride" src="/template/img/twitch/KappaPride.png">
    								<img data-smile="KappaRoss" src="/template/img/twitch/KappaRoss.png">
    								<img data-smile="Keepo" src="/template/img/twitch/Keepo.png">
    							</li>
    							<li>
    								<img data-smile="Kreygasm" src="/template/img/twitch/Kreygasm.png">
    								<img data-smile="heart" src="/template/img/twitch/heart.png">
    								<img data-smile="offFire" src="/template/img/twitch/offFire.png">
    								<img data-smile="PJSalt" src="/template/img/twitch/PJSalt.png">
    								<img data-smile="rip" src="/template/img/twitch/rip.png">
    							</li>
    							<li>
    								<img data-smile="FailFish" src="/template/img/twitch/FailFish.png">
    							</li>
							</ul>
						</div>
					</div>
					<div class="pull-left">
						<span>Users online: <span id="isonline">0</span></span>
					</div>
					<div class="pull-right">
						<a href="#" class="clearChat">Clear chat</a>
					</div>
					<br>
					<div class="checkbox pull-right" style="margin: 0px">
						<label class="noselect"><input type="checkbox" id="scroll"><span>Stop chat</span></label>
					</div>
					<div class="pull-left">
						<a href="#" data-toggle="modal" data-target="#chatRules">Chat rules</a>
					</div>
				</div>
			</form>
		</div>
		<div id="tab2" class="tab-group hidden"></div>
		<div id="tab3" class="tab-group hidden"></div>
		</div>
		<div class="panel panel-default">
			<div class="panel-body" style="margin-top: 10px;">
				<div><span class="settings-header">LANGUAGE</span><span class="settings-header">THEME</span></div>
				<ul class="nav settings-header" style="padding-top: 10px; display: inline-block;">
					<li class="dropdown">
						<img class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false" src="/template/img/lang/en.png">
						<ul class="dropdown-menu" role="menu" style="min-width: 32px;margin-left: 24%;">
							<li><a href="?language=en"><img src="/template/img/lang/en.png"></a></li>
						</ul>
					</li>
				</ul>

				<a href="#" id="light" style="width:27%;" class="settings-header"><div class="template" style="background-color: #f1f1f1;">LIGHT</div></a>
				<a href="#" id="dark" style="width:1%;" class="settings-header"><div class="template" style="background-color: #272727; ">DARK</div></a>

			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-body text-center" style="margin-top: 10px;">
				<span>ACTIVE STREAMERS</span>
				<div id="streamoff" style="margin-top: 20px;">All streamers offline!</div>
				<div class="streamers">     
				</div>
			</div>
		</div>
	</div>
		<div id="mainpage" class="col-xs-9">
          <div class="alert alert-success text-center" style="margin-bottom:5px;margin-top:25px"><button type="button" class="close" data-dismiss="alert">×</button><b><i class="fa fa-exclamation-circle"></i>Join our <a href="http://steamcommunity.com/groups/CSGOBananas_com" target="_blank">steam group </a>and join giveaways. </b></div>
          <div class="alert alert-info text-center" style="margin-top:5px"><button type="button" class="close" data-dismiss="alert">×</button><b data-dismiss="alert" style="
    cursor: pointer;
" ><i class="fa fa-exclamation-circle"></i> All promocodes give 20 coins! &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <i class="fa fa-exclamation-circle"></i> If you want to help us add "CSGOBananas.com" to your <a href="https://steamcommunity.com/id/user/edit" target="_blank">Steam name</a></b></div>
		  <div class="well text-center" style="margin-bottom:10px;margin-top:25px; padding: 20px;">	
			<div class="progress text-center" style="height:50px;margin-bottom:5px;margin-top:5px">
				<span id="banner"></span>
				<div class="progress-bar progress-bar-danger" id="counter"></div>
			</div>


		<div id="case" style="margin-bottom: 5px; background-position: -710.5px 0px;"><div id="pointer"></div></div>
		<div class="well text-center" style="padding:5px;margin-bottom:5px"><div id="past"></div>
			<div style="margin: 20px 0px;">
			</div>
			<div class="form-group">
				<div class="input-btn bet-buttons">
					<span style="font-size: 13px;background-color: #b04a43; padding: 10px 20px; margin-right: 5px; color: #fff; border-radius: 10px;"> 
						<span>Balance: </span>
						<span id="dongers"></span>
						<span id="balance">0</span> <i style="cursor:pointer; margin-left: 5px;" class="fa fa-refresh noselect" id="getbal"></i>
					</span>
					<input type="text" class="form-control input-lg" placeholder="Bet amount..." id="betAmount">
					<button type="button" class="btn btn-danger betshort" data-action="clear">Clear</button>
					<button type="button" class="btn btn-default betshort" data-action="10">+10</button>
					<button type="button" class="btn btn-default betshort" data-action="100">+100</button>
					<button type="button" class="btn btn-default betshort" data-action="1000">+1000</button>
					<button type="button" class="btn btn-default betshort" data-action="half">1/2</button>
					<button type="button" class="btn btn-default betshort" data-action="double">x2</button>
					<button type="button" class="btn btn-primary betshort" data-action="max">Max</button>
				</div>
			</div>
			
		</div>
			</div>
			<div class="row text-center">
				<div class="col-xs-4 betBlock" style="padding-right:0px">
					<div class="panel panel-default bet-panel" id="panel11-7-b">
						<div class="panel-heading" style="padding: 3px;">
							<button class="btn btn-danger btn-lg  btn-block betButton" data-lower="1" data-upper="7">1 - 7</button>
						</div>
					</div>
					<div class="panel panel-default bet-panel" id="panel1-7-m" style="width: 220px; margin: auto; margin-bottom: 10px;">
						<div class="panel-body" style="padding:0px">
							<div class="my-row">
								<div class="text-center"><span class="mytotal">0</span></div>
							</div>
						</div>
					</div>
					<div class="panel panel-default bet-panel" id="panel1-7-t">
						<div class="panel-body" style="padding:0px" id="panel1-7">
							<div class="total-row">
								<div class="text-center">Total bet: <span class="total">0</span></div>
							</div>
							<ul class="list-group betlist"></ul>
						</div>
					</div>
				</div>
				
				<div class="col-xs-4 betBlock">
					<div class="panel panel-default bet-panel" id="panel0-0-b">
						<div class="panel-heading" style="padding: 3px;">
							<button class="btn btn-success btn-lg  btn-block betButton" data-lower="0" data-upper="0">0</button>
						</div>
					</div>
					<div class="panel panel-default bet-panel" id="panel0-0-m" style="width: 220px; margin: auto; margin-bottom: 10px;">
						<div class="panel-body" style="padding:0px">
							<div class="my-row">
								<div class="text-center"><span class="mytotal">0</span></div>
							</div>
						</div>
					</div>
					<div class="panel panel-default bet-panel" id="panel0-0-t">
						<div class="panel-body" style="padding:0px" id="panel0-0">
							<div class="total-row">
								<div class="text-center">Total bet: <span class="total">0</span></div>
							</div>
							<ul class="list-group betlist"></ul>
						</div>
					</div>
				</div>
				
				<div class="col-xs-4 betBlock" style="padding-left:0px">
					<div class="panel panel-default bet-panel" id="panel8-14-b">
						<div class="panel-heading" style="padding: 3px;">
							<button class="btn btn-inverse btn-lg  btn-block betButton" data-lower="8" data-upper="14">8 - 14</button>
						</div>
					</div>
					<div class="panel panel-default bet-panel" id="panel8-14-m" style="width: 220px; margin: auto; margin-bottom: 10px;">
						<div class="panel-body" style="padding:0px">
							<div class="my-row">
								<div class="text-center"><span class="mytotal">0</span></div>
							</div>
						</div>
					</div>
					<div class="panel panel-default bet-panel" id="panel8-14-t">
						<div class="panel-body" style="padding:0px" id="panel8-14">
							<div class="total-row">
								<div class="text-center">Total bet: <span class="total">0</span></div>
							</div>
							<ul class="list-group betlist"></ul>
						</div>
					</div>
				</div>
			</div>
		</div>
<footer class="well footer">
	<div class="">
		<div class="pull-left" style="overflow:hidden">
		<!--	<a href="https://www.facebook.com/CSGO.mkdotcom" target="_blank"><img class="rounded" src="/template/img/social/facebook_icon.png"></a>  -->
		<!--	<a href="https://twitter.com/CSGO.mk" target="_blank"><img class="rounded" src="/template/img/social/twitter_icon.png"></a>  -->
			<!-- <a href="#" target="_blank"><img class="rounded" src="/template/img/social/youtube icon.png"></a> -->
			<!-- <a href="#" target="_blank"><img class="rounded" src="/template/img/social/reddit icon.png"></a> -->
			<!-- <a href="#" target="_blank"><img class="rounded" src="/template/img/social/twitch icon.png"></a> -->
			<a href="http://steamcommunity.com/groups/CSGOBananas_com" target="_blank"><img class="rounded" src="/template/img/social/steam_icon.png"></a>
		</div>
		<div class="pull-right" style="overflow:hidden;">
			<!-- Prices provided by <a href="http://csgo.steamanalyst.com/" target="_blank">SteamAnalyst</a> -->
			<a href="http://csgo.steamanalyst.com/" target="_blank"><img class="" src="/template/img/social/sa.gif"></a>
		</div>
		<ul class="list-inline" style="display:inline-block;margin-top:10px">
			<li>Copyright © 2016, CSGOBANANAS.COM  - All rights reserved.</li>
			<li><a href="/tos">ToS</a></li>
			<li><a href="/faq">FAQ</a></li>
			<li><a href="/support?new">Support</a></li>
			<li><a href="http://steampowered.com" target="_target">Powered by Steam</a></li>
		</ul>
	</div>	
</footer>		
</body></html>