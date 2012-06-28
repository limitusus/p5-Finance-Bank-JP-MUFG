package t::Helper::Page;

use strict;
use warnings;
use utf8;

sub balances {
    my $html = << 'END_HTML';
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja"><head>
<meta http-equiv="content-type" content="text/html;charset=Shift_JIS">
<!-- title -->
<title>残高照会 - 三菱東京UFJダイレクト</title>
<!-- /title -->
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<meta name="DCS.dcsuri" content="/directbanking/CD001.html">
<link rel="stylesheet" type="text/css" href="https://directg.s.bk.mufg.jp/refresh/DIRECT_STYLE/COMMON/CommonStyle.css">
<script type="text/javascript">
<!--
var msg = '処理を実行します よろしいですか？';
function doTransaction(trxID) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = self.name;
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if (confirm(msg)) {
      if (check()) {
        mForm.target = self.name;
        mForm.submit();
      }
  }
  return false;
}
function doTransaction2(trxID, c) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = self.name;
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    mForm.target = self.name;
    mForm.submit();
  }
  return ;
}
function doTransaction3(trxID, c, f, t) {
  mForm = f.document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = t;
  mForm._FRAMID.value = f.name;
  mForm._TARGETWINID.value = '';
  if (c) {
    if(!confirm(msg)) { return; }
  }
  if (check()) {
    mForm.target = t;
    mForm.submit();
  }
  return ;
}
function setParameter(trxID) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
}
function doTransactionForWin(trxID, c, t) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  if(t.length == 0){
      t ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = t;
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    mForm.target = t;
    mForm.submit();
  }
  return ;
}
function doTransactionForWin2(trxID, c, t, opt){
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  if(t.length == 0){
      t ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = t;
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    ww = window.open('', t, opt);
    mForm.target = t;
    mForm.submit();
    ww.focus();  }
  return ;
}
function doTransactionForWin3(trxID, c, tf, tw) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = tf;
  mForm._FRAMID.value = '';
  if(tw.length == 0){
      tw ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = tw;
  if (c) {
    if(!confirm(msg)) { return; }
  }
  if (check()) {
    mForm.target = tf;
    mForm.submit();
  }
  return ;
}
function doSubTransaction(trxID, listIndex) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._SUBINDEX.value = listIndex;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if(check()){
    mForm.target = self.name;
    mForm.submit();
  }
  return ;
}
var isTrx      = 0;
var delayTime  = 5000;
function check(){
  if (isTrx == 0) {
    isTrx = 1;
    setTimeout("resetTrx()",delayTime);
    return true;
  } else {
    return false;
  }
}
function resetTrx() {
  isTrx = 0;
}
function openHelp( url ){
  var helpWindow = window.open("https://directg.s.bk.mufg.jp" + url, "help", "width=600,height=600,menubar=yes,toolbar=yes,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes");
  helpWindow.focus();
  return false;
}
function openHelpNonSSL( url ){
  var helpWindow = window.open("http://direct.bk.mufg.jp" + url, "help", "width=600,height=600,menubar=yes,toolbar=yes,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes");
  helpWindow.focus();
  return false;
}
function goAnother( url ) {
  pForm = document.AnotherForm;
  pForm.action = url;
  if(check()){
    pForm.target = '_top';
    pForm.submit();
  }
  return;
}
function openAnother( url, name ){
  var helpWindow = window.open(url, name, "menubar=yes,toolbar=no,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=600");
  helpWindow.focus();
  return false;
}
function setCookie( myKey, myVal ){
  var expire = new Date();
  expire.setTime(expire.getTime() + 60*24*60*60*1000);
  var tempStr = myKey + "=" + myVal + "; ";
  tempStr += "expires=" + expire.toGMTString() + "; ";
  tempStr += "domain=bk.mufg.jp;";
  tempStr += "path=/;";
  document.cookie = tempStr;
}
function getCookie( myKey ){
  var cookies = [];
  if( document.cookie ){
    var cookiesStr = document.cookie.split(";");
    for( var i=0; i < cookiesStr.length; i++ ){
      var cookiePair = cookiesStr[i].split("=");
      if( cookiePair.length != 2 ){
        continue;
      }
      cookies[cookiePair[0].replace( /^ *| *$/g, "" )] = cookiePair[1].replace( /^ *| *$/g, "" );
    }
    return cookies[myKey];
  }
}
function topLayoutSet(){
	if( document.getElementById("top-stageInfoTd") && document.getElementById("top-iLetterTd") ){
		var iLetterElm = document.getElementById("top-iLetterTd");
		var stageInfoElm = document.getElementById("top-stageInfoTd");
		stageInfoElm.style.height = "auto";
		iLetterElm.style.height = "auto";
		if( iLetterElm.offsetHeight > stageInfoElm.offsetHeight ){
			stageInfoElm.style.height = iLetterElm.offsetHeight + "px";
		}else{
			iLetterElm.style.height = stageInfoElm.offsetHeight + "px";
		}
	}
}
function setFontSize( size ){
  var targetElm = document.getElementsByTagName("body")[0];
  if( !targetElm ){
    setTimeout( function(){ setFontSize( size ); } , 0 );
    return;
  }
  var bodyClassName = " font-" + size;
  var existingBodyClassName = targetElm.className.replace( /font-.*$/, "");
  if( existingBodyClassName != "" ){
    bodyClassName = existingBodyClassName + " " + bodyClassName;
  }
  targetElm.className = bodyClassName;
  setCookie( "mufont" , size );
  if( (/Mac/i.test(navigator.userAgent) && /Netscape/i.test(navigator.userAgent)) || /MSIE/i.test(navigator.userAgent) ){
    if( document.getElementById("field01-Keyboard") ) if( SWKB.openingKeyboardId ) SWKB.keyboardAreaLayout();
  }
  topLayoutSet();
}
function initFontSize(){
  if( /Netscape/i.test(navigator.userAgent) ){
    document.getElementsByTagName("body")[0].className += " ns";
  }
  setFontSize( getCookie( "mufont" ) || "middle" );
}
// Mozilla
if (document.addEventListener) {
  document.addEventListener("DOMContentLoaded", initFontSize, false);
}
// IE
/*@cc_on @*/
/*@
document.write("<script id=__ie_onload defer><\/script>");
var script = document.getElementById("__ie_onload");
script.onreadystatechange = function() {
  if ( this.readyState === "complete" ) {
    initFontSize();
  }
};
@*/
// Safari
if ( /WebKit/i.test(navigator.userAgent) ) {
  var _timer = setInterval( function() {
    if ( /loaded|complete/.test(document.readyState) ) {
      clearInterval(_timer);
      initFontSize();
    }
  }, 10 );
}
if ( window.addEventListener ) {
	window.addEventListener("load", topLayoutSet, false);
}else if( window.attachEvent ) {
	window.attachEvent("onload", topLayoutSet);
}
function setSpFlag( trxID, value ){
    var tempStr = "sp_flag=" + value + ";";
    tempStr += "domain=bk.mufg.jp" + ";";
    tempStr += "path=/" + ";";
    document.cookie = tempStr;
    doTransaction2(trxID , false);
}
function logoutFromAD001() {
doTransaction2('AD001_022', false);
}
//-->
</script>
</head>
<body>
<div id="container">
  <form  method="POST" action="" name="AnotherForm" onSubmit="return false;">
  </form>
  <form  method="POST" action="/ib/dfw/APL/bnkib/banking" name="MainForm" onSubmit="return false;">
  <input type="hidden" name="_PAGEID" value="CD001"><input type="hidden" name="_SENDTS" value="1341744292652"><input type="hidden" name="_TRANID" value=""><input type="hidden" name="_SUBINDEX" value="-1"><input type="hidden" name="_TARGET" value=""><input type="hidden" name="_FRAMID" value=""><input type="hidden" name="_LUID" value="LUID"><input type="hidden" name="_WINID" value="root"><input type="hidden" name="_TARGETWINID" value="">
<!-- Header -->
<div id="header">
  <div id="header-contents">
    <div id="header-logo">
      <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_direct.gif" width="241" height="34" alt="DIRECT 三菱東京UFJダイレクト">
    </div>
    <ol id="header-navi">
    
        
      <li><a href="#" onClick="JavaScript:doTransaction2('AW001_028', false); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_navi_toppage.gif" width="95" height="24" alt="トップページ"></a></li>
        
      <li><a href="#" onClick="JavaScript:logoutFromAD001(); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_navi_logout.gif" width="86" height="24" alt="ログアウト"></a></li>
    
    </ol>
  </div>
</div>
<!-- /Header -->
    
<!-- Menu -->
<div id="menu">
  <div id="menu-heading">
    <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/hd_servicemenu.gif" width="220" height="29" alt="サービスメニュー">
  </div>
  <ol class="menu-section">
    <li class="current"><a href="#" onClick="JavaScript:doTransaction2('AD001_001', false); return false;"><span>残高照会</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_002', false); return false;"><span>入出金明細照会</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_003', false); return false;"><span>振込</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_004', false); return false;"><span>振替</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_005', false); return false;"><span>税金・各種料金払込</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_006', false); return false;"><span>定期預金</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_007', false); return false;"><span>外貨預金</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/toushishintaku/ToushinKouzaShutoku.do'); return false;"><span>投資信託</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/shoukenchuukai/ShoukenChuukaiMenu.do'); return false;"><span>株式等（金融商品仲介）</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_045', false); return false;"><span>保険</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_013', false); return false;"><span>住宅ローン・<span class="small">その他ローン</span></span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_010', false); return false;"><span>クレジットカード</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_012', false); return false;"><span>各種手続</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('https://direct11.bk.mufg.jp/ib/dfw/NET/cgi-bin/netorder2/sm/003/netorder_sm_003.pl'); return false;"><span>ご相談</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/torihikikanri/TorihikiGamenKensakuHyouzi.do'); return false;"><span>お取引記録</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/jouhoukei/AutoLoginTorihikiSentaku.do'); return false;"><span>オートログイン</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_017', false); return false;"><span>メインバンク プラス</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_044', false); return false;"><span>じぶん銀行</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_011', false); return false;"><span>外国送金</span></a></li>
    <li><a href="#" onClick="JavaScript:openAnother('https://direct11.bk.mufg.jp/ib/dfw/QA/btmu_ib_answer.html','mufg_qa'); return false;"><span>お問い合わせ・Q&amp;A</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/torihikikanri/InformationIchiranShoukaiKidoku.do'); return false;"><span>お知らせ履歴</span></a></li>
  </ol>
<div id="top-marketInfo">
  <a href="#" onClick="JavaScript:openAnother('http://qweb10-3.qhit.net/mufg_bank/qsearch.exe?F=users/mufg_bank/market','mufg_market'); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/user/market.gif" width="220" height="158" alt="マーケット情報"></a>
</div>
</div>
<!-- /Menu -->
    
  <!-- START OF SmartSource Data Collector TAG -->
  <script src="https://directg.s.bk.mufg.jp/wt_js/CD/fpc.js" type="text/javascript"></script>
  <script src="https://directg.s.bk.mufg.jp/wt_js/CD/sdc.js" type="text/javascript"></script>
  <!-- END OF SmartSource Data Collector TAG -->
  <script src="https://directg.s.bk.mufg.jp/refresh/DIRECT_SCRIPT/COMMON/Keychk.js" type="text/javascript"></script>
<script type="text/javascript">
<!--
function openWindowScreen(trxID, pageId, style) {
  doTransactionForWin2(trxID, false, pageId, style);
  resetTrx();
}
function openPrintWindow(trxID, pageId) {
  openWindowScreen(trxID, pageId, 'width=670,height=480,menubar=yes,toolbar=yes,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes');
}
function openKinriWindow(trxID, pageId) {
  openWindowScreen(trxID, pageId, 'menubar=yes,toolbar=no,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes,width=980,height=600');
}
function openKouzaShoukaiWindow(trxID, pageId) {
  openWindowScreen(trxID, pageId, 'menubar=yes,toolbar=no,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes,width=980,height=600');
}
function gotoPageFromCD001(index) {
    document.MainForm.SENTAKU.value = parseInt(index);
    doTransaction2('CD001_002',false);
}
function nextPageFromCD001(trx,index) {
    document.MainForm.SENTAKU.value = parseInt(index);
    doTransaction2(trx,false);
}
function gotoPageMeisaiFromCD001() {
    doTransaction2('CD001_006',false);
}
function gotoPageGaikaZanFromCD001() {
    doTransaction2('CD001_005',false);
}
function gotoPageJibunZanFromCD001() {
    doTransaction2('CD001_009',false);
}
//-->
</script>
<input type="hidden" name="SENTAKU" value="" />
<div id="contents">
<!-- TorihikiMenu -->
  <div id="serviceTitle">
    <h1><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/YEN/t_zandakasyoukai.gif" width="530" height="20" alt="残高照会"></h1>
    <div class="sideinfo">
      <a href="#" onclick="JavaScript:openHelp('/refresh/ref_direct393.html'); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/btn_help.gif" width="51" height="15" alt="ヘルプ"></a>
    </div>
  </div>
<!-- /TorihikiMenu -->
<!-- Tstep -->
<!-- /Tstep -->
<!-- MainContents-->
  <div class="serviceContents">
<!-- Message-->
<!-- /Message-->
    <div class="aCenter section"><a href="http://direct.bk.mufg.jp/refresh/ref_direct597.html" target="_blank"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/user/yen_banner.gif" alt=""></a></div>
    <div class="section sideinfo">
      <a href="#" class="print" onClick="JavaScript:openPrintWindow('CD001_001', 'CD002'); return false;">このページを印刷する</a>
    </div>
    <div class="section">
      <div class="sideinfo"><a href="#" onclick="JavaScript:openHelp('/refresh/ref_direct394.html'); return false;" class="help">引出可能額について</a></div>
      <table class="data">
        <thead>
          <tr>
            <th>取引店</th>
            <th>預金種類</th>
            <th>口座番号</th>
            <th>残高</th>
            <th>引出可能額</th>
            <th>明細照会<br>（最近10日間）</th>
          </tr>
        </thead>
        <tbody>
          
            <tr class=odd>
              <td>恵比寿支店</td>
              <td>
                
                  普通
                
              </td>
              <td>8888888</td>
              <td class=number>15,000,000円</td>
              <td class=number>500,000円</td>
              <td class=aCenter><input type="button" class="button next" value="表示" onClick="nextPageFromCD001('CD001_003',0)"></td>
            </tr>
          
            <tr class=even>
              <td>恵比寿支店</td>
              <td>
                
                  定期
                
              </td>
              <td>9999999</td>
              <td class=number>0円</td>
              <td class=number>***</td>
              <td class=aCenter><input type="button" class="button next" value="表示" onClick="nextPageFromCD001('CD001_004',1)"></td>
            </tr>
          
        </tbody>
      </table>
      <div class="sideinfo">（2012年7月8日 19時44分現在）</div>
      <p>預金種類が財形の場合、リンクを押すと詳細情報を確認できます。</p>
      <div class="section">
        <strong class="attention">（ご注意）</strong><br>
        <ul>
          
          <li>お客さまと当行のカードローンの契約の状態により、引出可能額に表示された金額のお引き出しができない場合があります。</li>
          <li>預金種類が定期、財形、個人年金預金の場合、「表示」を押すと預金明細を全件照会できます。</li>
        </ul>
      </div>
    </div>
    <div class="section">
      <div class="sideinfo">
        <a href="#" class="relational" onclick="JavaScript:gotoPageMeisaiFromCD001(); return false;">入出金明細照会</a><a href="#" class="relational" onclick="JavaScript:gotoPageGaikaZanFromCD001(); return false;">外貨預金残高照会</a><a href="#" class="relational" onclick="JavaScript:gotoPageJibunZanFromCD001(); return false;">じぶん銀行口座残高照会</a>
      </div>
    </div>
  </div>
<!-- /MainContents -->
    <!-- Footer -->
      <div id="footer">
        <div class="sideInfo">
          <a href="#header" class="toPagetop">このページの先頭へ</a>
        </div>
        <address id="footer-helpDesk">
          <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/footer_helpdesk.gif" width="585" height="70" alt="インターネットバンキング ヘルプデスク フリーダイヤル0120-543-555 または 042-311-7000（通話料有料） 受付時間/毎日9:00～21:00">
        </address>
        <div id="footer-siteInfo">
          <a href="http://direct.bk.mufg.jp/refresh/ref_direct005.html" target="_blank">本サイトのご利用にあたって</a>
        </div>
        <div id="footer-copyright">
          Copyright(c) 2012 The Bank of Tokyo-Mitsubishi UFJ,Ltd. All rights reserved.
        </div>
      </div>
    <!-- /Footer -->
    </div>
    </div>
    </form>
</body>
</html>
END_HTML

    return $html;
}

sub transactions {
    my $html = << 'END_HTML';
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja"><head>
<meta http-equiv="content-type" content="text/html;charset=Shift_JIS">
<!-- title -->
<title>入出金明細照会 - 三菱東京UFJダイレクト</title>
<!-- /title -->
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link rel="stylesheet" type="text/css" href="https://directg.s.bk.mufg.jp/refresh/DIRECT_STYLE/COMMON/CommonStyle.css">
<script type="text/javascript">
<!--
var msg = '処理を実行します よろしいですか？';
function doTransaction(trxID) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = self.name;
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if (confirm(msg)) {
      if (check()) {
        mForm.target = self.name;
        mForm.submit();
      }
  }
  return false;
}
function doTransaction2(trxID, c) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = self.name;
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    mForm.target = self.name;
    mForm.submit();
  }
  return ;
}
function doTransaction3(trxID, c, f, t) {
  mForm = f.document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = t;
  mForm._FRAMID.value = f.name;
  mForm._TARGETWINID.value = '';
  if (c) {
    if(!confirm(msg)) { return; }
  }
  if (check()) {
    mForm.target = t;
    mForm.submit();
  }
  return ;
}
function setParameter(trxID) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
}
function doTransactionForWin(trxID, c, t) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  if(t.length == 0){
      t ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = t;
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    mForm.target = t;
    mForm.submit();
  }
  return ;
}
function doTransactionForWin2(trxID, c, t, opt){
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  if(t.length == 0){
      t ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = t;
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    ww = window.open('', t, opt);
    mForm.target = t;
    mForm.submit();
    ww.focus();  }
  return ;
}
function doTransactionForWin3(trxID, c, tf, tw) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = tf;
  mForm._FRAMID.value = '';
  if(tw.length == 0){
      tw ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = tw;
  if (c) {
    if(!confirm(msg)) { return; }
  }
  if (check()) {
    mForm.target = tf;
    mForm.submit();
  }
  return ;
}
function doSubTransaction(trxID, listIndex) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._SUBINDEX.value = listIndex;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if(check()){
    mForm.target = self.name;
    mForm.submit();
  }
  return ;
}
var isTrx      = 0;
var delayTime  = 5000;
function check(){
  if (isTrx == 0) {
    isTrx = 1;
    setTimeout("resetTrx()",delayTime);
    return true;
  } else {
    return false;
  }
}
function resetTrx() {
  isTrx = 0;
}
function openHelp( url ){
  var helpWindow = window.open("https://directg.s.bk.mufg.jp" + url, "help", "width=600,height=600,menubar=yes,toolbar=yes,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes");
  helpWindow.focus();
  return false;
}
function openHelpNonSSL( url ){
  var helpWindow = window.open("http://direct.bk.mufg.jp" + url, "help", "width=600,height=600,menubar=yes,toolbar=yes,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes");
  helpWindow.focus();
  return false;
}
function goAnother( url ) {
  pForm = document.AnotherForm;
  pForm.action = url;
  if(check()){
    pForm.target = '_top';
    pForm.submit();
  }
  return;
}
function openAnother( url, name ){
  var helpWindow = window.open(url, name, "menubar=yes,toolbar=no,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=600");
  helpWindow.focus();
  return false;
}
function setCookie( myKey, myVal ){
  var expire = new Date();
  expire.setTime(expire.getTime() + 60*24*60*60*1000);
  var tempStr = myKey + "=" + myVal + "; ";
  tempStr += "expires=" + expire.toGMTString() + "; ";
  tempStr += "domain=bk.mufg.jp;";
  tempStr += "path=/;";
  document.cookie = tempStr;
}
function getCookie( myKey ){
  var cookies = [];
  if( document.cookie ){
    var cookiesStr = document.cookie.split(";");
    for( var i=0; i < cookiesStr.length; i++ ){
      var cookiePair = cookiesStr[i].split("=");
      if( cookiePair.length != 2 ){
        continue;
      }
      cookies[cookiePair[0].replace( /^ *| *$/g, "" )] = cookiePair[1].replace( /^ *| *$/g, "" );
    }
    return cookies[myKey];
  }
}
function topLayoutSet(){
	if( document.getElementById("top-stageInfoTd") && document.getElementById("top-iLetterTd") ){
		var iLetterElm = document.getElementById("top-iLetterTd");
		var stageInfoElm = document.getElementById("top-stageInfoTd");
		stageInfoElm.style.height = "auto";
		iLetterElm.style.height = "auto";
		if( iLetterElm.offsetHeight > stageInfoElm.offsetHeight ){
			stageInfoElm.style.height = iLetterElm.offsetHeight + "px";
		}else{
			iLetterElm.style.height = stageInfoElm.offsetHeight + "px";
		}
	}
}
function setFontSize( size ){
  var targetElm = document.getElementsByTagName("body")[0];
  if( !targetElm ){
    setTimeout( function(){ setFontSize( size ); } , 0 );
    return;
  }
  var bodyClassName = " font-" + size;
  var existingBodyClassName = targetElm.className.replace( /font-.*$/, "");
  if( existingBodyClassName != "" ){
    bodyClassName = existingBodyClassName + " " + bodyClassName;
  }
  targetElm.className = bodyClassName;
  setCookie( "mufont" , size );
  if( (/Mac/i.test(navigator.userAgent) && /Netscape/i.test(navigator.userAgent)) || /MSIE/i.test(navigator.userAgent) ){
    if( document.getElementById("field01-Keyboard") ) if( SWKB.openingKeyboardId ) SWKB.keyboardAreaLayout();
  }
  topLayoutSet();
}
function initFontSize(){
  if( /Netscape/i.test(navigator.userAgent) ){
    document.getElementsByTagName("body")[0].className += " ns";
  }
  setFontSize( getCookie( "mufont" ) || "middle" );
}
// Mozilla
if (document.addEventListener) {
  document.addEventListener("DOMContentLoaded", initFontSize, false);
}
// IE
/*@cc_on @*/
/*@
document.write("<script id=__ie_onload defer><\/script>");
var script = document.getElementById("__ie_onload");
script.onreadystatechange = function() {
  if ( this.readyState === "complete" ) {
    initFontSize();
  }
};
@*/
// Safari
if ( /WebKit/i.test(navigator.userAgent) ) {
  var _timer = setInterval( function() {
    if ( /loaded|complete/.test(document.readyState) ) {
      clearInterval(_timer);
      initFontSize();
    }
  }, 10 );
}
if ( window.addEventListener ) {
	window.addEventListener("load", topLayoutSet, false);
}else if( window.attachEvent ) {
	window.attachEvent("onload", topLayoutSet);
}
function setSpFlag( trxID, value ){
    var tempStr = "sp_flag=" + value + ";";
    tempStr += "domain=bk.mufg.jp" + ";";
    tempStr += "path=/" + ";";
    document.cookie = tempStr;
    doTransaction2(trxID , false);
}
function logoutFromAD001() {
doTransaction2('AD001_022', false);
}
//-->
</script>
</head>
<body>
<div id="container">
  <form  method="POST" action="" name="AnotherForm" onSubmit="return false;">
  </form>
  <form  method="POST" action="/ib/dfw/APL/bnkib/banking" name="MainForm" onSubmit="return false;">
  <input type="hidden" name="_PAGEID" value="CG017"><input type="hidden" name="_SENDTS" value="1341747780624"><input type="hidden" name="_TRANID" value=""><input type="hidden" name="_SUBINDEX" value="-1"><input type="hidden" name="_TARGET" value=""><input type="hidden" name="_FRAMID" value=""><input type="hidden" name="_LUID" value="LUID"><input type="hidden" name="_WINID" value="root"><input type="hidden" name="_TARGETWINID" value="">
<!-- Header -->
<div id="header">
  <div id="header-contents">
    <div id="header-logo">
      <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_direct.gif" width="241" height="34" alt="DIRECT 三菱東京UFJダイレクト">
    </div>
    <ol id="header-navi">
    
        
      <li><a href="#" onClick="JavaScript:doTransaction2('AW001_028', false); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_navi_toppage.gif" width="95" height="24" alt="トップページ"></a></li>
        
      <li><a href="#" onClick="JavaScript:logoutFromAD001(); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_navi_logout.gif" width="86" height="24" alt="ログアウト"></a></li>
    
    </ol>
  </div>
</div>
<!-- /Header -->
    
<!-- Menu -->
<div id="menu">
  <div id="menu-heading">
    <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/hd_servicemenu.gif" width="220" height="29" alt="サービスメニュー">
  </div>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_001', false); return false;"><span>残高照会</span></a></li>
    <li class="current"><a href="#" onClick="JavaScript:doTransaction2('AD001_002', false); return false;"><span>入出金明細照会</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_003', false); return false;"><span>振込</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_004', false); return false;"><span>振替</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_005', false); return false;"><span>税金・各種料金払込</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_006', false); return false;"><span>定期預金</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_007', false); return false;"><span>外貨預金</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/toushishintaku/ToushinKouzaShutoku.do'); return false;"><span>投資信託</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/shoukenchuukai/ShoukenChuukaiMenu.do'); return false;"><span>株式等（金融商品仲介）</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_045', false); return false;"><span>保険</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_013', false); return false;"><span>住宅ローン・<span class="small">その他ローン</span></span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_010', false); return false;"><span>クレジットカード</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_012', false); return false;"><span>各種手続</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('https://direct11.bk.mufg.jp/ib/dfw/NET/cgi-bin/netorder2/sm/003/netorder_sm_003.pl'); return false;"><span>ご相談</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/torihikikanri/TorihikiGamenKensakuHyouzi.do'); return false;"><span>お取引記録</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/jouhoukei/AutoLoginTorihikiSentaku.do'); return false;"><span>オートログイン</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_017', false); return false;"><span>メインバンク プラス</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_044', false); return false;"><span>じぶん銀行</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_011', false); return false;"><span>外国送金</span></a></li>
    <li><a href="#" onClick="JavaScript:openAnother('https://direct11.bk.mufg.jp/ib/dfw/QA/btmu_ib_answer.html','mufg_qa'); return false;"><span>お問い合わせ・Q&amp;A</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/torihikikanri/InformationIchiranShoukaiKidoku.do'); return false;"><span>お知らせ履歴</span></a></li>
  </ol>
<div id="top-marketInfo">
  <a href="#" onClick="JavaScript:openAnother('http://qweb10-3.qhit.net/mufg_bank/qsearch.exe?F=users/mufg_bank/market','mufg_market'); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/user/market.gif" width="220" height="158" alt="マーケット情報"></a>
</div>
</div>
<!-- /Menu -->
    
<script type="text/javascript">
<!--
function openWindowScreen(trxID, pageId, style) {
  doTransactionForWin2(trxID, false, pageId, style);
  resetTrx();
}
function openPrintWindow(trxID, pageId) {
  openWindowScreen(trxID, pageId, 'width=670,height=480,menubar=yes,toolbar=yes,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes');
}
function openKinriWindow(trxID, pageId) {
  openWindowScreen(trxID, pageId, 'menubar=yes,toolbar=no,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes,width=980,height=600');
}
function openKouzaShoukaiWindow(trxID, pageId) {
  openWindowScreen(trxID, pageId, 'menubar=yes,toolbar=no,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes,width=980,height=600');
}
function gotoPageFromCG017() {
    doTransaction2('CG017_006', false)
}
function gotoBackFromCG017(trx) {
    doTransaction2(trx, false)
}
function prevPagingFromCG017() {
    doTransaction2('CG017_004', false)
}
function nextPagingFromCG017() {
    doTransaction2('CG017_005', false)
}
//-->
</script>
<div id="contents">
<!-- TorihikiMenu -->
  <div id="serviceTitle">
    
    <h1><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/YEN/t_nyusyukin_eco.gif" width="530" height="20" alt="入出金明細照会（Eco通帳照会）"></h1>
    
    <div class="sideinfo">
    
      <a href="#" onclick="JavaScript:openHelp('/refresh/ref_direct767.html'); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/btn_help.gif" width="51" height="15" alt="ヘルプ"></a>
    
    </div>
  </div>
<!-- /TorihikiMenu -->
<!-- Tstep -->
  <ol id="serviceFlow">
    <li class="first">照会口座／期間選択</li>
    <li class="current">照会結果</li>
    
    <li>メモ編集</li>
    
  </ol>
<!-- /Tstep -->
<!-- MainContents-->
  <div class="serviceContents">
    <!-- Message-->
    
    
    <!-- /Message-->
    <div class="section sideinfo">
      <a href="#" class="print" onClick="JavaScript:openPrintWindow('CG017_001', 'CG018'); return false;">このページを印刷する</a>
    </div>
    <div class="section">
      <table class="data">
        <tbody>
          <tr>
            <th class="halfFull">照会日時</th>
            <td>2012年7月8日 20時43分</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="section">
      <table class="data">
        <thead>
          <tr>
            <th>取引店</th>
            <th>預金種類</th>
            <th>口座番号</th>
            <th>現在残高</th>
          </tr>
        </thead>
        <tbody>
          <tr class="odd">
            <td>恵比寿支店</td>
            <td>普通</td>
            <td>8888888</td>
            <td class="number">14,989,895円</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="section">
      <table class="data">
        <tbody>
          <tr>
            <th class="halfFull">照会種類</th>
            <td>全取引</td>
          </tr>
          <tr>
            <th class="halfFull">照会期間</th>
            <td>2012年6月22日～2012年6月22日</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="section">
    
      <div class="sideinfo">
        <input type="button" class="button imemoButton" value="メモ編集" onclick="gotoPageFromCG017()">
      </div>
    
      <table class="data">
        <thead>
          <tr>
            <th>日付</th>
            <th colspan="2">摘要／摘要内容</th>
            <th>支払い金額</th>
            <th>預かり金額</th>
            <th>差引残高</th>
            
            <th class="imemo">メモ<br>（最大全角7文字）</th>
            
          </tr>
        </thead>
        <tbody>
          
          <tr class=odd>
            <td>2012年6月22日</td>
            <td>振込ＩＢ１</td>
            <td>テスト　タロウ</td>
            <td class="number">2,000円</td>
            <td class="number">&nbsp;</td>
            <td class="number">14,998,000円</td>
            
            <td class="imemo">&nbsp;</td>
            
          </tr>
          
          <tr class=even>
            <td>2012年6月22日</td>
            <td>カ－ド</td>
            <td>&nbsp;</td>
            <td class="number">8,000円</td>
            <td class="number">&nbsp;</td>
            <td class="number">14,990,000円</td>
            
            <td class="imemo">&nbsp;</td>
            
          </tr>
          
          <tr class=odd>
            <td>2012年6月22日</td>
            <td>手数料</td>
            <td>&nbsp;</td>
            <td class="number">105円</td>
            <td class="number">&nbsp;</td>
            <td class="number">14,989,895円</td>
            
            <td class="imemo">&nbsp;</td>
            
          </tr>
          
        </tbody>
      </table>
      <div class="sideinfo">
        
        
      </div>
      
      <ul class="notice">
        <li>メモ欄にはお客さまが自由に入力できますのでご利用ください。</li>
      </ul>
      
    </div>
    <div class="buttons">
      <input type="button" class="button" value="戻る" onclick="gotoBackFromCG017('CG017_002')">
    </div>
  </div>
<!-- /MainContents -->
    <!-- Footer -->
      <div id="footer">
        <div class="sideInfo">
          <a href="#header" class="toPagetop">このページの先頭へ</a>
        </div>
        <address id="footer-helpDesk">
          <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/footer_helpdesk.gif" width="585" height="70" alt="インターネットバンキング ヘルプデスク フリーダイヤル0120-543-555 または 042-311-7000（通話料有料） 受付時間/毎日9:00～21:00">
        </address>
        <div id="footer-siteInfo">
          <a href="http://direct.bk.mufg.jp/refresh/ref_direct005.html" target="_blank">本サイトのご利用にあたって</a>
        </div>
        <div id="footer-copyright">
          Copyright(c) 2012 The Bank of Tokyo-Mitsubishi UFJ,Ltd. All rights reserved.
        </div>
      </div>
    <!-- /Footer -->
    </div>
    </div>
    </form>
</body>
</html>
END_HTML

    return $html;
}

sub download {
    my $html = << 'END_HTML';

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja"><head>
<meta http-equiv="content-type" content="text/html;charset=Shift_JIS">
<!-- title -->
<title>入出金明細照会 - 三菱東京UFJダイレクト</title>
<!-- /title -->
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link rel="stylesheet" type="text/css" href="https://directg.s.bk.mufg.jp/refresh/DIRECT_STYLE/COMMON/CommonStyle.css">
<script type="text/javascript">
<!--
var msg = '処理を実行します よろしいですか？';
function doTransaction(trxID) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = self.name;
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if (confirm(msg)) {
      if (check()) {
        mForm.target = self.name;
        mForm.submit();
      }
  }
  return false;
}
function doTransaction2(trxID, c) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = self.name;
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    mForm.target = self.name;
    mForm.submit();
  }
  return ;
}
function doTransaction3(trxID, c, f, t) {
  mForm = f.document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = t;
  mForm._FRAMID.value = f.name;
  mForm._TARGETWINID.value = '';
  if (c) {
    if(!confirm(msg)) { return; }
  }
  if (check()) {
    mForm.target = t;
    mForm.submit();
  }
  return ;
}
function setParameter(trxID) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
}
function doTransactionForWin(trxID, c, t) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  if(t.length == 0){
      t ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = t;
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    mForm.target = t;
    mForm.submit();
  }
  return ;
}
function doTransactionForWin2(trxID, c, t, opt){
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  if(t.length == 0){
      t ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = t;
  if (c) {
    if(!confirm(msg)) { return ; }
  }
  if (check()) {
    ww = window.open('', t, opt);
    mForm.target = t;
    mForm.submit();
    ww.focus();  }
  return ;
}
function doTransactionForWin3(trxID, c, tf, tw) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._TARGET.value = tf;
  mForm._FRAMID.value = '';
  if(tw.length == 0){
      tw ='_NOTARGETWINID';
  }
  mForm._TARGETWINID.value = tw;
  if (c) {
    if(!confirm(msg)) { return; }
  }
  if (check()) {
    mForm.target = tf;
    mForm.submit();
  }
  return ;
}
function doSubTransaction(trxID, listIndex) {
  mForm = document.MainForm;
  mForm._TRANID.value = trxID;
  mForm._SUBINDEX.value = listIndex;
  mForm._TARGET.value = '';
  mForm._FRAMID.value = '';
  mForm._TARGETWINID.value = '';
  if(check()){
    mForm.target = self.name;
    mForm.submit();
  }
  return ;
}
var isTrx      = 0;
var delayTime  = 5000;
function check(){
  if (isTrx == 0) {
    isTrx = 1;
    setTimeout("resetTrx()",delayTime);
    return true;
  } else {
    return false;
  }
}
function resetTrx() {
  isTrx = 0;
}
function openHelp( url ){
  var helpWindow = window.open("https://directg.s.bk.mufg.jp" + url, "help", "width=600,height=600,menubar=yes,toolbar=yes,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes");
  helpWindow.focus();
  return false;
}
function openHelpNonSSL( url ){
  var helpWindow = window.open("http://direct.bk.mufg.jp" + url, "help", "width=600,height=600,menubar=yes,toolbar=yes,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes");
  helpWindow.focus();
  return false;
}
function goAnother( url ) {
  pForm = document.AnotherForm;
  pForm.action = url;
  if(check()){
    pForm.target = '_top';
    pForm.submit();
  }
  return;
}
function openAnother( url, name ){
  var helpWindow = window.open(url, name, "menubar=yes,toolbar=no,location=yes,directories=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=600");
  helpWindow.focus();
  return false;
}
function setCookie( myKey, myVal ){
  var expire = new Date();
  expire.setTime(expire.getTime() + 60*24*60*60*1000);
  var tempStr = myKey + "=" + myVal + "; ";
  tempStr += "expires=" + expire.toGMTString() + "; ";
  tempStr += "domain=bk.mufg.jp;";
  tempStr += "path=/;";
  document.cookie = tempStr;
}
function getCookie( myKey ){
  var cookies = [];
  if( document.cookie ){
    var cookiesStr = document.cookie.split(";");
    for( var i=0; i < cookiesStr.length; i++ ){
      var cookiePair = cookiesStr[i].split("=");
      if( cookiePair.length != 2 ){
        continue;
      }
      cookies[cookiePair[0].replace( /^ *| *$/g, "" )] = cookiePair[1].replace( /^ *| *$/g, "" );
    }
    return cookies[myKey];
  }
}
function topLayoutSet(){
	if( document.getElementById("top-stageInfoTd") && document.getElementById("top-iLetterTd") ){
		var iLetterElm = document.getElementById("top-iLetterTd");
		var stageInfoElm = document.getElementById("top-stageInfoTd");
		stageInfoElm.style.height = "auto";
		iLetterElm.style.height = "auto";
		if( iLetterElm.offsetHeight > stageInfoElm.offsetHeight ){
			stageInfoElm.style.height = iLetterElm.offsetHeight + "px";
		}else{
			iLetterElm.style.height = stageInfoElm.offsetHeight + "px";
		}
	}
}
function setFontSize( size ){
  var targetElm = document.getElementsByTagName("body")[0];
  if( !targetElm ){
    setTimeout( function(){ setFontSize( size ); } , 0 );
    return;
  }
  var bodyClassName = " font-" + size;
  var existingBodyClassName = targetElm.className.replace( /font-.*$/, "");
  if( existingBodyClassName != "" ){
    bodyClassName = existingBodyClassName + " " + bodyClassName;
  }
  targetElm.className = bodyClassName;
  setCookie( "mufont" , size );
  if( (/Mac/i.test(navigator.userAgent) && /Netscape/i.test(navigator.userAgent)) || /MSIE/i.test(navigator.userAgent) ){
    if( document.getElementById("field01-Keyboard") ) if( SWKB.openingKeyboardId ) SWKB.keyboardAreaLayout();
  }
  topLayoutSet();
}
function initFontSize(){
  if( /Netscape/i.test(navigator.userAgent) ){
    document.getElementsByTagName("body")[0].className += " ns";
  }
  setFontSize( getCookie( "mufont" ) || "middle" );
}
// Mozilla
if (document.addEventListener) {
  document.addEventListener("DOMContentLoaded", initFontSize, false);
}
// IE
/*@cc_on @*/
/*@
document.write("<script id=__ie_onload defer><\/script>");
var script = document.getElementById("__ie_onload");
script.onreadystatechange = function() {
  if ( this.readyState === "complete" ) {
    initFontSize();
  }
};
@*/
// Safari
if ( /WebKit/i.test(navigator.userAgent) ) {
  var _timer = setInterval( function() {
    if ( /loaded|complete/.test(document.readyState) ) {
      clearInterval(_timer);
      initFontSize();
    }
  }, 10 );
}
if ( window.addEventListener ) {
	window.addEventListener("load", topLayoutSet, false);
}else if( window.attachEvent ) {
	window.attachEvent("onload", topLayoutSet);
}
function setSpFlag( trxID, value ){
    var tempStr = "sp_flag=" + value + ";";
    tempStr += "domain=bk.mufg.jp" + ";";
    tempStr += "path=/" + ";";
    document.cookie = tempStr;
    doTransaction2(trxID , false);
}
function logoutFromAD001() {
doTransaction2('AD001_022', false);
}
//-->
</script>
</head>
<BODY onLoad="downloadClicked()">
<div id="container">
  <form  method="POST" action="" name="AnotherForm" onSubmit="return false;">
  </form>
  <form  method="POST" action="/ib/dfw/APL/bnkib/banking" name="MainForm" onSubmit="return false;">
  <input type="hidden" name="_PAGEID" value="CG019"><input type="hidden" name="_SENDTS" value="1341828357767"><input type="hidden" name="_TRANID" value=""><input type="hidden" name="_SUBINDEX" value="-1"><input type="hidden" name="_TARGET" value=""><input type="hidden" name="_FRAMID" value=""><input type="hidden" name="_LUID" value="LUID"><input type="hidden" name="_WINID" value="root"><input type="hidden" name="_TARGETWINID" value="">
<!-- Header -->
<div id="header">
  <div id="header-contents">
    <div id="header-logo">
      <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_direct.gif" width="241" height="34" alt="DIRECT 三菱東京UFJダイレクト">
    </div>
    <ol id="header-navi">
    
        
      <li><a href="#" onClick="JavaScript:doTransaction2('AW001_028', false); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_navi_toppage.gif" width="95" height="24" alt="トップページ"></a></li>
        
      <li><a href="#" onClick="JavaScript:logoutFromAD001(); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/header_navi_logout.gif" width="86" height="24" alt="ログアウト"></a></li>
    
    </ol>
  </div>
</div>
<!-- /Header -->
    
<!-- Menu -->
<div id="menu">
  <div id="menu-heading">
    <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/hd_servicemenu.gif" width="220" height="29" alt="サービスメニュー">
  </div>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_001', false); return false;"><span>残高照会</span></a></li>
    <li class="current"><a href="#" onClick="JavaScript:doTransaction2('AD001_002', false); return false;"><span>入出金明細照会</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_003', false); return false;"><span>振込</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_004', false); return false;"><span>振替</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_005', false); return false;"><span>税金・各種料金払込</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_006', false); return false;"><span>定期預金</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_007', false); return false;"><span>外貨預金</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/toushishintaku/ToushinKouzaShutoku.do'); return false;"><span>投資信託</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/shoukenchuukai/ShoukenChuukaiMenu.do'); return false;"><span>株式等（金融商品仲介）</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_045', false); return false;"><span>保険</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_013', false); return false;"><span>住宅ローン・<span class="small">その他ローン</span></span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_010', false); return false;"><span>クレジットカード</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_012', false); return false;"><span>各種手続</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('https://direct11.bk.mufg.jp/ib/dfw/NET/cgi-bin/netorder2/sm/003/netorder_sm_003.pl'); return false;"><span>ご相談</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/torihikikanri/TorihikiGamenKensakuHyouzi.do'); return false;"><span>お取引記録</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/jouhoukei/AutoLoginTorihikiSentaku.do'); return false;"><span>オートログイン</span></a></li>
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_017', false); return false;"><span>メインバンク プラス</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_044', false); return false;"><span>じぶん銀行</span></a></li>
  </ol>
  <ol class="menu-section">
    <li><a href="#" onClick="JavaScript:doTransaction2('AD001_011', false); return false;"><span>外国送金</span></a></li>
    <li><a href="#" onClick="JavaScript:openAnother('https://direct11.bk.mufg.jp/ib/dfw/QA/btmu_ib_answer.html','mufg_qa'); return false;"><span>お問い合わせ・Q&amp;A</span></a></li>
    <li><a href="#" onClick="JavaScript:goAnother('../ibp/torihikikanri/InformationIchiranShoukaiKidoku.do'); return false;"><span>お知らせ履歴</span></a></li>
  </ol>
<div id="top-marketInfo">
  <a href="#" onClick="JavaScript:openAnother('http://qweb10-3.qhit.net/mufg_bank/qsearch.exe?F=users/mufg_bank/market','mufg_market'); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/user/market.gif" width="220" height="158" alt="マーケット情報"></a>
</div>
</div>
<!-- /Menu -->
    
<script type="text/javascript">
<!--
function downloadClicked() {
    doTransaction2('CG019_001',　false);
    resetTrx();
}
function gotoPageFromCG019() {
    doTransaction2('CG019_001',　false);
}
function gotoBackFromCG019() {
    doTransaction2('CG019_002',　false);
}
//-->
</script>
<div id="contents">
<!-- TorihikiMenu -->
  <div id="serviceTitle">
    <h1><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/YEN/t_nyusyukkinmeisai.gif" width="530" height="20" alt="入出金明細照会"></h1>
    <div class="sideinfo">
      <a href="#" onclick="JavaScript:openHelp('/refresh/ref_direct770.html'); return false;"><img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/btn_help.gif" width="51" height="15" alt="ヘルプ"></a>
    </div>
  </div>
<!-- /TorihikiMenu -->
<!-- Tstep -->
  <ol id="serviceFlow">
    <li class="first">照会口座／期間選択</li>
    <li class="current">ダウンロード</li>
  </ol>
<!-- /Tstep -->
<!-- MainContents-->
  <div class="serviceContents">
    <!-- Message-->
    
    
    <!-- /Message-->
    <h2>明細ダウンロード</h2>
    <table class="cols section">
      <tr>
        <td>
          <p>下記の明細をダウンロードします。<br>ダウンロードが実行されない場合は、「ダウンロード」ボタンを押してください。</p>
        </td>
        <td>
          <div class="sideinfo">
            <input type="button" value="ダウンロード" class="button carryOut" onclick="gotoPageFromCG019()">
          </div>
        </td>
      </tr>
    </table>
    <div class="section">
      <table class="data section">
        <thead>
          <tr>
            <th>取引店</th>
            <th>預金種類</th>
            <th>口座番号</th>
            <th>ダウンロード期間</th>
          </tr>
        </thead>
        <tbody>
          <tr class="odd">
            <td>恵比寿支店</td>
            <td>普通</td>
            <td>8888888</td>
            <td>2012年6月1日～2012年7月9日</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="buttons">
      <input type="button" class="button" value="戻る" onclick="gotoBackFromCG019()">
    </div>
  </div>
<!-- /MainContents -->
    <!-- Footer -->
      <div id="footer">
        <div class="sideInfo">
          <a href="#header" class="toPagetop">このページの先頭へ</a>
        </div>
        <address id="footer-helpDesk">
          <img src="https://directg.s.bk.mufg.jp/refresh/imgs/DIRECT_IMAGE/COMMON/footer_helpdesk.gif" width="585" height="70" alt="インターネットバンキング ヘルプデスク フリーダイヤル0120-543-555 または 042-311-7000（通話料有料） 受付時間/毎日9:00～21:00">
        </address>
        <div id="footer-siteInfo">
          <a href="http://direct.bk.mufg.jp/refresh/ref_direct005.html" target="_blank">本サイトのご利用にあたって</a>
        </div>
        <div id="footer-copyright">
          Copyright(c) 2012 The Bank of Tokyo-Mitsubishi UFJ,Ltd. All rights reserved.
        </div>
      </div>
    <!-- /Footer -->
    </div>
    </div>
    </form>
</body>
</html>
END_HTML

    return $html;
}

sub csv {
    my $csv = << 'END_CSV';
"日付","摘要","摘要内容","支払い金額","預かり金額","差引残高","メモ","未資金化区分","入払区分"
"2012/6/22","振込ＩＢ１","テスト　タロウ","2,000","","14,998,000","","","振替支払い"
"2012/6/22","カ−ド","","8,000","","14,990,000","","","支払い"
"2012/6/22","手数料","","105","","14,989,895","","","振替支払い"
END_CSV

    return $csv;
}

sub expiration {
    my $html = << 'END_HTML';
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML LANG="ja">

<HEAD>
<TITLE>三菱東京ＵＦＪダイレクト</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=Shift_JIS">

<style type="text/css"><!--
td{
font-size:x-small;
}

.border0{
background-color: #EE0000;
color: #ffffff;
padding:6px;
}

.border1{
border-top-width:1px;
border-top-style: solid;
height:1em;
}

.border2{
border-bottom-style:solid;
border-bottom-width:1px;
height:1em;
}

.border3{
border-top-width: 6px;
border-top-style: solid;
height:1px;
}

.border1,.border2,.border3{
border-color : #EE0000;
margin:2px;
text-align:center;
}
--></style>

</HEAD>

<BODY BGCOLOR="#FFFFFF">
<DIV ALIGN="CENTER"> 
<form>
<BR>
<BR>


<TABLE BORDER="0" CELLPADDING="6" CELLSPACING="0" WIDTH="550"><TR><TD ALIGN="center" CLASS="border0"><B>三菱東京ＵＦＪダイレクト</B></TD></TR></TABLE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="554">
<TR><TD ALIGN="CENTER">
<DIV CLASS="border1"></DIV>

<!-- here  -->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="490" HEIGHT="220">
<TR><TD ALIGN="LEFT">
お客さまのセキュリティ 確保のためお取引を中断させていただきました。お取引を行うには、再度ログインしてください。(IW052)
</TD></TR>
</TABLE>
<!--// here -->


<DIV CLASS="border2"></DIV>
<DIV CLASS="border3"></DIV>
<BR>
<INPUT TYPE="BUTTON" VALUE="　閉じる　" onClick="window.top.close()">

</TD></TR>
</TABLE>

</form>
</DIV>
</BODY>
</HTML>
END_HTML

    return $html;
}

1;
