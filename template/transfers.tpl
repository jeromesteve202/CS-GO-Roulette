
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Transfers - CSGOBANANAS.COm</title>
		<link href="/template/css/bootstrap.min.new.css" rel="stylesheet">
<link href="/template/css/font-awesome.min.css" rel="stylesheet">
<link href="/template/css/dataTables.bootstrap.min.css" rel="stylesheet">

<link href="/template/css/mineNew.css?v=5" rel="stylesheet">
<link id="style" href="" rel="stylesheet">

<link rel="shortcut icon" href="favicon.ico">

<script src="/template/js/jquery-1.11.1.min.js"></script>
<script src="/template/js/jquery.cookie.js"></script>
<script src="/template/js/bootstrap.min.js"></script>
<script src="/template/js/bootbox.min.js"></script>
<script src="/template/js/jquery.dataTables.min.js"></script>
<script src="/template/js/dataTables.bootstrap.js"></script>
<script src="/template/js/tinysort.js"></script>
<script src="/template/js/expanding.js"></script>
<script src="/template/js/theme.js"></script>
<style>

</style>
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
		
		</style>
		<script type="text/javascript">
			$(document).ready(function(){
				$("table").DataTable({
					"searching":false,
					"pageLength":50,
					"lengthChange":false,
				});
			});			
		</script>	
	</head>
	<body>
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
</script>		<div class="container">
			<br>
			
				<table class='table table-striped dataTable no-footer'><thead><th>Transfer ID</th><th>From</th><th>To</th><th>Amount</th><th>Note</th><th>Time</th></thead><tbody>
				<?php foreach($transfers as $key => $value): ?>
					<tr><td><?=$value['id']?></td><td><?=($value['from1'] == $user['steamid'])?'YOU':'<a href="http://steamcommunity.com/profiles/'.$value['from1'].'/" target="_blank">'.$value['to1'].'</a>'?></td><td><?=($value['to1'] == $user['steamid'])?'YOU':'<a href="http://steamcommunity.com/profiles/'.$value['to1'].'/"" target="_blank">'.$value['to1'].'</a>'?></td><td><?=$value['amount']?></td><td></td><td><?=date('Y-m-d H:i:s', $value['time'])?></td></tr>
				<?php endforeach; ?>
				</tbody></table>		
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
			<li>Copyright © 2016, CSGOBANANAS.COM - All rights reserved.</li>
			<li><a href="/tos">ToS</a></li>
			<li><a href="/faq">FAQ</a></li>
			<li><a href="/support?new">Support</a></li>
			<li><a href="http://steampowered.com" target="_target">Powered by Steam</a></li>
		</ul>
	</div>	
</footer>			
	</body>
</html>