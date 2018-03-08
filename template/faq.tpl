
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>FAQ - CSGO BANANAS.com</title>
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
			h4{
        margin-top:50px;
        text-decoration: underline;
        font-weight: bold;
      }
		</style>
		<script type="text/javascript">	
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
			<!-- <a class="navbar-brand" style="padding-top:0px;padding-bottom:0px;padding-right:0px" href="./"><img alt="CSGOBANANA.com" height="34" style="margin-top:8px;margin-bottom:8px;margin-right:5px" src="/template/img/just.png"></a> -->
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
</div>
<script>
function saveSettings(){
	for(var i=0;i<SETTINGS.length;i++){
		setCookie("settings_"+SETTINGS[i],$("#settings_"+SETTINGS[i]).is(":checked"));
	}
	$("#settingsModal").modal("hide");
	if($("#settings_dongers").is(":checked")){
		$("#balance").html("por favor, summary");
	}else{
		$("#balance").html("por favor, summary");
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
					bootbox.alert("Success! you will be credited "+data.credits+" credits.");					
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
</script>		<div class="container" style="margin-bottom:20%">

      <div class="col-md-3" style="position:static;top:50px">



<div class="list-group">
	<li class="list-group-item active">To start</li>
	<a href="#q1" class="list-group-item">What CSGOBANANA.com?</a>

	<li class="list-group-item active">deposits</li> 
	<a href="#q2" class="list-group-item">How much coins ?</a>
	<a href="#q3" class="list-group-item">How prices are set ?</a>
	<a href="#q4" class="list-group-item">My articles do not appear in the deposits ?</a>
	<a href="#q5" class="list-group-item">I put things , but did not get a coin ?</a>
	<a href="#q6" class="list-group-item">Will be I able to withdraw the coin , if I rejected the operation?</a>
	<a href="#q7" class="list-group-item">Why bot canceled my exchange ?</a>

	<li class="list-group-item active">Print</li> 
	<a href="#q13" class="list-group-item">What is Anti -trade system ?</a>

	<li class="list-group-item active">Honesty</li>
	<a href="#q8" class="list-group-item">What is the control of integrity ?</a>
	<a href="#q9" class="list-group-item">How it works?</a>
	<a href="#q10" class="list-group-item">How can I check the result of the event?</a>
	<li class="list-group-item active">Referral system</li>
	<a href="#q11" class="list-group-item">How works the referral system?</a>
	<a href="#q12" class="list-group-item">What is the referral level?</a>
</div>







      </div>

    <div class="col-md-9">
            <h4 id="q1" style="margin-top:0px" class="text-warning">What CSGOBANANA.com?</h4>
                <p>CSGOBANANA.COM is a brand new way to gamble CS:GO skins. We are NOT a jackpot site – instead players deposit skins for credits and bet those credits on a roulette inspired game:</p><p>Bet 1-7 (red) or 8-14 (black) for DOUBLE your credits. Bet 0 (green) for FOURTEEN times your credits.</p><p>It doesn't matter how big your inventory is, or how much you bet, your odds are always the same.</p><p>Bets occur in real time, across the entire site, meaning you bet, win, and lose along with other players.</p><p>All rolls are generated using a provably fair system – ensuring a fair roll each and every time.</p>
            <h4 id="q2" class="text-warning">How much are credits worth?</h4>
                <p>Credits have no real-life value. Instead they are exchanged for CS:GO items from our public shop. Every 1000 credits will buy you roughly $1 worth of items. See below for more information.</p>
            <h4 id="q3" class="text-warning">How are prices determined?</h4>
                <p>Baseline prices are determined using publicly available data from SteamAnalyst. Some items are not accepted due to price, volatility, or popularity. Furthermore the following discounts are applied:</p><table class="table"><tbody><tr><th>Price</th><th>You will get</th></tr><tr><td>0.00 - 0.30</td><td>Not accepted</td></tr><tr><td>0.30 - 5.00</td><td>20% less</td></tr><tr><td>5.00 - 10.00</td><td>10% less</td></tr><tr><td>10.00+</td><td>Full price</td></tr><tr><td>Stickers</td><td>10% less + (% of value)</td></tr></tbody></table><p></p>
            <h4 id="q4" class="text-warning">My items are not showing up for deposit?</h4>
                <p>First, make sure your inventory is set to public.</p><p>By default CSGOBANANA.com loads items from cache. Occasionally this may become out of date. To load directly from Steam (and update the cache) click the “force reload” button.</p>
            <h4 id="q5" class="text-warning">I've deposited but haven't received my credits!?</h4>
                <p>After accepting the trade offer you must “confirm” the deposit by clicking the confirm button under the “incoming trade offer” panel. This allows our system to verify that the offer has been accepted – only then will the credits be forwarded to your account.</p>
            <h4 id="q6" class="text-warning">Will I be refunded if I decline a withdraw?</h4>
                <p>Yes. If you decline the trade offer for any reason (or it expires) you will be refunded the full amount after “confirming” with our system.</p>
            <h4 id="q7" class="text-warning">Why did the bot cancel my trade offer?</h4>
                <p>Our bots automatically cancel trade offers older than 10 minutes to make room for new trade offers. If you're unable to respond within 10 minutes simply “confirm” the old trade offer and try again.</p>
            <h4 id="q8" class="text-warning">What is Provably Fair?</h4>
                <p>Provably fair is a way of generating random numbers using cryptography such that the results can be verified by a third party. This means the operators cannot manipulate the outcome of any roll. In short, we use the results of a state run lottery to seed our RNG (random number generator) – for a detailed explanation see below.</p>
            <h4 id="q9" class="text-warning">How does it work?</h4>
                <p>Each roll is computed using the SHA-256 hash of 3 distinct inputs.</p><p>First, is the server seed. This is a precomputed value generated by CSGOBANANA.com some time in the past. Seeds are generated in a chain such that today's seed is the hash of tomorrow's seed. Since there is no way to reverse SHA-256 we can prove each seed was generated in advance by working backwards from a precomputed chain.</p>
            <h4 id="q10" class="text-warning">How can I check the result of the event?</h4>
                <p>You can execute PHP code straight from your web browser with tools like <a href="http://www.phptester.net/" target="_blank">PHP Tester</a>. Simply copy-paste the following code into the window and replace the server_seed, lotto, and round_id values for your own. Execute the code to verify the roll.</p>
                <pre>$server_seed = "39b7d32fcb743c244c569a56d6de4dc27577d6277d6cf155bdcba6d05befcb34";
$lotto = "0422262831";
$round_id = "1";
$hash = hash("sha256",$server_seed."-".$lotto."-".$round_id);
$roll = hexdec(substr($hash,0,8)) % 15;
echo "Round $round_id = $roll";</pre>
                <p>Notice how any change to the lottery results radically changes the rolls.</p><p>Note that you'll be unable to verify rolls until the server seed is disclosed at 00:00 (MSK).</p>
            <h4 id="q11" class="text-warning">How does the affiliate system work?</h4>
                <p>The affiliate system lets anyone earn credits by referring new players to the site. Visit the affiliate dashboard to generate your unique referral code. Share with friends, in forum signatures, or on social media.</p><p>When new players use your referral code they'll earn 100 FREE credits. And you'll earn credits every time your referrals place a bet – regardless if they win or lose.</p>
            <h4 id="q12" class="text-warning">What is affiliate level?</h4>
                <p>Your affiliate level determines how much (%) you'll earn from each referral. Your affiliate level is determined by the amount of unique depositors you've referred:</p><p></p><table class="table"><tbody><tr><th>Unique Depositors</th><th>Affiliate Level</th></tr><tr><td>0</td><td>Silver IV (1 coin per 300 bet)</td></tr><tr><td>50</td><td>Legendary Eagle (1 coin per 200 bet)</td></tr><tr><td>200+</td><td>Global Elite (1 coin per 100 bet)</td></tr></tbody></table><p>You can track your visitor statistics from the dashboard. A green check mark indicates that the player has made at least one deposit (the amount of the deposit does not matter). While you'll earn a % from all visitors only those who've made at least one deposit count towards the affiliate level.</p><p>Note that for privacy reasons complete steam id's are obscured.</p><p>When leveling up your new % is applied to all previous earnings. For example, if you've earned 100k as Bronze affiliate, your earnings will instantly jump to 200k when reaching Silver, and then 300k when reaching Gold – even if none of your referrals or new depositors placed any bets during that time.</p>               
            <h4 id="q13" class="text-warning">What is the Anti-Trade System?</h4>
                <p>The Anti-Trade system is to prevent users that just deposit to withdraw other items without even playing on the site.</p><p>We call them traders, they want to make profit from such situation. To prevent this we have added a system where you need to place bets worth half of the amount you want to withdraw.</p><p>Each withdraw will lower your available coins to withdraw and of course balance.</p></div>
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
			<li>Copyright &copy; 2016, CSGOBANANAS.com - All rights reserved.</li>
			<li><a href="/tos">Terms of Use</a></li>
			<li><a href="/faq">FAQ</a></li>
			<li><a href="/support?new">Contacts</a></li>
			<li><a href="http://steampowered.com" target="_target">Powered by Steam</a></li>
		</ul>
	</div>	
</footer>			
	</body>
</html>