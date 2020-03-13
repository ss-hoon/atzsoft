<%'@ CodePage=65001 Language="VBScript"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<%
Session.Codepage=65001
Response.Expires = -1
Response.AddHeader "Pragma", "no-cache"
Response.AddHeader "cache-control", "no-store"
response.CharSet = "utf-8"

company_name        = "PANTRA"
company_name_eng    = "PANTRA"

head_sql_ip			= "(local)"
head_odbc_user      = "atzsoft"
head_odbc_pass		= "dmstjd123$%^"
head_odbc_name      = "pt_xoffice"

local_sql_ip		= "(local)"
local_odbc_user     = "atzsoft"
local_odbc_pass	    = "dmstjd123$%^"
local_odbc_name     = "pt_xerp"

erp_db              = "pt_xerp"
sys_db              = "pt_xoffice"
pop_db              = "pt_xpop"

userid_st           = "P"                           '사용자 계정 첫문자 설정

admin_password      = "admin"
admin_url           = "pop_admin.asp"

webhard_url         = "http://ptr.xoffice.kr:8080"
serverpath          = "D:\NEW_pt\nerp\"
pstdocpath          = "D:\NEW_pt\nerp\upload\pstdoc\"

pop_path            =  "D:\NEW_pt\pop\screen\"             ' pop_img link 경로
pop_url             =  "/pop/screen/"          		       ' pop_img link 경로

file_upload_path    = "D:\NEW_pt\NERP\upload\"
file_upload_url     = "/nerp/upload/"
file_upload_size    = 40                                   ' byte단위 ( board에서 *1020000 함 )

'******* head DB 에 연결을 하는 부분 *************
' asysDbConnect="Provider=SQLOLEDB;Data Source="& head_sql_ip &";Initial Catalog="& head_odbc_name &";User ID="& head_odbc_user &";Password="& head_odbc_pass &";"
' Set aconn = Server.CreateObject("ADODB.Connection")
' aconn.ConnectionTimeout = 2000000
' aconn.CommandTimeout = 2000000
' aconn.Open asysDbConnect

'******* local DB 에 연결을 하는 부분 *************
' sysDbConnect="Provider=SQLOLEDB;Data Source="& local_sql_ip &";Initial Catalog="& local_odbc_name &";User ID="& local_odbc_user &";Password="& local_odbc_pass &";"
sysDbConnect="Provider=SQLOLEDB;Data Source="& local_sql_ip &";Initial Catalog="& local_odbc_name &";Integrated Security=SSPI;"
Set conn = Server.CreateObject("ADODB.Connection")
conn.ConnectionTimeout = 2000000
conn.CommandTimeout = 2000000
conn.Open sysDbConnect

' 배경색상 library
bgcolor_01 = "#4D4D4D"  ' 상단 바 배경색상
bgcolor_02 = "#2C2C2C"  ' 하단 바 배경색상
bgcolor_03 = "#888888"  ' GRID foot toolbar 배경색상

' 글자색상 library
color_01 = "#000000"    ' 기본색상
color_02 = "#F55447"    ' red 색상
color_03 = "#418CF0"    ' blue 색상
color_04 = "#FFE48D"    ' yellow 색상

'## 바코드
px = "3.779"

'## 초품 검사시간
sTestH1_s71 = "09" : sTestM1_s71 = "00" : eTestH1_s71 = "10" : eTestM1_s71 = "00"
sTestH1_s72 = "19" : sTestM1_s72 = "00" : eTestH1_s72 = "20" : eTestM1_s72 = "00"

'## 중품 검사시간
sTestH2_s71 = "11" : sTestM2_s71 = "00" : eTestH2_s71 = "12" : eTestM2_s71 = "00"
sTestH2_s72 = "23" : sTestM2_s72 = "00" : eTestH2_s72 = "00" : eTestM2_s72 = "00"

'## 종품 검사시간
sTestH3_s71 = "15" : sTestM3_s71 = "00" : eTestH3_s71 = "16" : eTestM3_s71 = "00"
sTestH3_s72 = "03" : sTestM3_s72 = "00" : eTestH3_s72 = "04" : eTestM3_s72 = "00"

'## 공장구분값 (pop/index.asp에서 설정한 값)'
if request.cookies("fact_cd") = "" or request.cookies("fact_nm") = "" then
    ' response.write "config"
    if Request.ServerVariables("PATH_INFO") = "/pop/index.asp" and Request.ServerVariables("QUERY_STRING") = "" then
        Response.redirect "/pop/index.asp?openFactWin=Y"
    elseif Request.ServerVariables("PATH_INFO") <> "/pop/index.asp" then
        Response.redirect "/pop/index.asp?openFactWin=Y"
    end if
else
    CONST_FACT_CD = request.cookies("fact_cd")
    CONST_FACT_NM = request.cookies("fact_nm")
    CONST_FACT_GB = request.cookies("fact_gb") '# 2019-08-21 factgb : 본사(01), 진례(02), 천안(03)'
end if
    ' response.write CONST_FACT_CD
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<meta charset="UTF-8">
<meta http-equiv = "Content-Type" content = "text/html;charset=UTF-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
<link rel="apple-touch-icon-precomposed" href="/nerp/inc/images/atz_75.png">  <!--아이폰용 바로가기 이미지-->
<link rel="shortcut icon"  href="/nerp/inc/images/atz_75.png">  <!--안드로이드바로가기 이미지-->
<title><%=company_name%></title>
<link rel="stylesheet" type="text/css" href="/pop/inc/easyui/themes/default/easyui.css?ver=1.251">
<link rel="stylesheet" type="text/css" href="/pop/inc/easyui/themes/icon.css?ver=1.0">
<link rel="stylesheet" type="text/css" href="/pop/inc/easyui/themes/color.css">
<link rel="stylesheet" type="text/css" href="/pop/inc/jquery/keypad/jquery.keypad.css">

<script type="text/javascript" src="/pop/inc/easyui/jquery.min.js"></script>
<script type="text/javascript" src="/pop/inc/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="/pop/inc/easyui/locale/easyui-lang-en.js"></script>
<script type="text/javascript" src="/pop/inc/easyui/datagrid-scrollview.js"></script>
<script type="text/javascript" src="/pop/inc/easyui/jquery.edatagrid.js"></script>
<script type="text/javascript" src="/pop/inc/easyui/jquery.number.js"></script>
<script type="text/javascript" src="/pop/inc/easyui/jQuery.print.js"></script>
<script type="text/javascript" src="/pop/inc/easyui/jquery.cookie.js"></script>

<script src="/pop/inc/jquery/keypad/jquery.plugin.js"></script>
<script src="/pop/inc/jquery/keypad/jquery.keypad.js?ver=1.0"></script>

<script src="//kendo.cdn.telerik.com/2016.3.914/js/kendo.all.min.js"></script>
<script defer src="https://use.fontawesome.com/releases/v5.0.6/js/all.js"></script>



<!-- <link rel="stylesheet" type="text/css" href="/pop/easyui/easyui.css?ver=1.4">
<link rel="stylesheet" type="text/css" href="/pop/easyui/color.css">
<link rel="stylesheet" type="text/css" href="/pop/easyui/icon.css">
<link rel="stylesheet" type="text/css" href="/pop/easyui/buttons.css" />
<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="/pop/easyui/jquery.min.js"></script>
<script src="/pop/easyui/jQuery.print.js"></script>
<script type="text/javascript" src="/pop/easyui/jquery.easyui.min.js"></script>
<script src="//kendo.cdn.telerik.com/2016.3.914/js/kendo.all.min.js"></script>
<script type="text/javascript" src="/pop/easyui/datagrid-scrollview.js"></script>

<script src="/pop/easyui/keypad/jquery.plugin.js"></script>
<script src="/pop/easyui/keypad/jquery.keypad.js"></script>
<link href="/pop/easyui/keypad/jquery.keypad.css?ver=1.2" rel="stylesheet">

<script type="text/javascript" src="/nerp/inc/easyui/locale/easyui-lang-ko.js"></script>
<script defer src="https://use.fontawesome.com/releases/v5.0.6/js/all.js"></script>

<link href="https://fonts.googleapis.com/css?family=Exo+2" rel="stylesheet"> -->


<style type="text/css">

@import 'https://fonts.googleapis.com/css?family=Roboto+Condensed';
@import 'https://fonts.googleapis.com/css?family=Roboto';

body
{
font-family:'Exo 2','Roboto Condensed','Nanum Gothic';
touch-action: none;
}

.pg_title
{
float:left;font-size:18px;padding:15px;color:#fff;
}

/* easyUI library Default font-size 설정 기본 폰트 사이즈 : 18px */
.datagrid-cell{  /* 데이터그리드 데이터 행 font,height 조정 */
  margin: 0;
  padding: 12px;
  white-space: nowrap;
  word-wrap: normal;
  overflow: hidden;
  height: 25px;
  line-height: 25px;
  font-size: 18px;
  font-weight:normal;
}

.datagrid-cell-rownumber {  /* 데이터그리드 RowNumner 행 font,height 조정 */
  margin: 0;
  padding: 0px;
  white-space: nowrap;
  word-wrap: normal;
  overflow: hidden;
  height: 25px;
  line-height: 25px;
  font-size: 15px;
  font-weight:bold;
}

.datagrid-header .datagrid-cell span {   /* 데이터그리드 헤더 font */
font-size: 15px;
}

/* easyUI Tab UI 설정, 기본 폰트 사이즈 : 18px */
.tabs-title {
font-size: 18px;
}
.tabs {
list-style-type: none;
height: 55px;
margin: 0px;
padding: 0px;
padding-left: 4px;
width: 50000px;
border-style: solid;
border-width: 0 0 0 0;
}

.tabs li a.tabs-inner {
display: inline-block;
text-decoration: none;
margin: 0;
padding: 20px 40px 20px 40px;
height: 0;
line-height: 0;
text-align: center;
white-space: nowrap;
border-width: 1px;
border-style: solid;
-moz-border-radius: 0;
-webkit-border-radius: 0;
border-radius: 0;
}
.tabs-header-bottom .tabs li a.tabs-inner {
-moz-border-radius: 0;
-webkit-border-radius: 0;
border-radius: 0;
}
.tabs-header-left .tabs li.tabs-selected a.tabs-inner {
color: #fff;
background: #4D4C6D;
}
.tabs li a.tabs-inner {
color: #fff;
background: #4D4C6D;
}

.l-btn-text {     /* linkbutton font */
display: inline-block;
vertical-align: top;
width: auto;
line-height: 24px;
font-size: 18px;
padding: 2px;
margin: 0 4px;
font-weight:normal;
border-radius:0;
}

.l-btn {
-moz-border-radius: 0;
-webkit-border-radius: 0;
border-radius: 0;
padding:5px 25px;
}

.textbox {
position: relative;
border: 1px solid #95B8E7;
background-color: #fff;
vertical-align: middle;
display: inline-block;
overflow: hidden;
white-space: nowrap;
padding: 0 5px;    /* textbox,combobox,datetinme 오른쪽 icon 높이조절용 padding, 상단,하단은 0으로 줄것 */
margin: 0;
-moz-border-radius: 0;
-webkit-border-radius: 0;
border-radius: 0;
height:38px;
font-size: 20px;
}
.textbox .textbox-text {
font-size: 20px;
border: 0;
margin: 0 4px;
padding: 8px;    /* combobox,datetinme 오른쪽 icon 높이조절용 padding */
white-space: normal;
vertical-align: top;
outline-style: none;
resize: none;
-moz-border-radius: 0;
-webkit-border-radius: 0;
border-radius: 0;
}

.textbox-icon {
display: inline-block;
width: 18px;
height: 20px;
overflow: hidden;
vertical-align: top;
background-position: center center;
cursor: pointer;
opacity: 0.6;
filter: alpha(opacity=60);
text-decoration: none;
outline-style: none;
}

.combobox-item,
.combobox-group,
.combobox-stick {
font-size: 18px;
padding: 5px;
}
.combo-arrow {
padding:0 5px;
width: 18px;
height: 20px;
overflow: hidden;
display: inline-block;
vertical-align: top;
cursor: pointer;
opacity: 0.6;
filter: alpha(opacity=60);
}

.spinner-button-up {
background: url('/pop/inc/easyui/images/spinner_arrows1.png') no-repeat 1px center;
}
.spinner-button-down {
background: url('/pop/inc/easyui/images/spinner_arrows1.png') no-repeat -15px center;
}


.switchbutton {
text-decoration: none;
display: inline-block;
overflow: hidden;
vertical-align: middle;
margin: 0;
padding: 0;
cursor: pointer;
background: #bbb;
border: 1px solid #bbb;
border-radius:0;
}

.switchbutton-on,
.switchbutton-off,
.switchbutton-handle {
display: inline-block;
text-align: center;
height: 100%;
float: left;
font-size: 18px;
border-radius:0;
}


.switchbutton-on,
.switchbutton-reversed .switchbutton-off {
-moz-border-radius: 0 0 0 0;
-webkit-border-radius: 0 0 0 0;
border-radius: 0 0 0 0;
}
.switchbutton-off,
.switchbutton-reversed .switchbutton-on {
-moz-border-radius: 0 0 0 0;
-webkit-border-radius: 0 0 0 0;
border-radius: 0 0 0 0;
}

/*reload, close버튼 텍스트 오른쪽 정렬 해제*/
span.l-btn-left{
width: auto;
}

/* 메시지 scnackbar 형태로 뿌려주기 */
/* The snackbar - position it at the bottom and in the middle of the screen */
#snackbar {
visibility: hidden; /* Hidden by default. Visible on click */
min-width: 800px; /* Set a default minimum width */
margin-left: -125px; /* Divide value of min-width by 2 */
background-color: #333; /* Black background color */
color: orange; /* White text color */
text-align: center; /* Centered text */
border-radius: 2px; /* Rounded borders */
padding: 20px; /* Padding */
position: fixed; /* Sit on top of the screen */
z-index: 9999999; /* Add a z-index if needed */
left: 35%; /* Center the snackbar */
bottom: 130px; /* 30px from the bottom */
font-size:30px;
}

/* Show the snackbar when clicking on a button (class added with JavaScript) */
#snackbar.show
{
visibility: visible; /* Show the snackbar */

/* Add animation: Take 0.5 seconds to fade in and out the snackbar.
However, delay the fade out process for 2.5 seconds */
-webkit-animation: fadein 0.5s, fadeout 0.5s 2.5s;
animation: fadein 0.5s, fadeout 0.5s 2.5s;
}

/* Animations to fade the snackbar in and out */
@-webkit-keyframes fadein {
from {bottom: 0; opacity: 0;}
to {bottom: 130px; opacity: 1;}
}

@keyframes fadein {
from {bottom: 0; opacity: 0;}
to {bottom: 130px; opacity: 1;}
}

@-webkit-keyframes fadeout {
from {bottom: 130px; opacity: 1;}
to {bottom: 0; opacity: 0;}
}

@keyframes fadeout {
from {bottom: 130px; opacity: 1;}
to {bottom: 0; opacity: 0;}
}

#msg
{ font-size:30px;}

.window {border-radius:0;border:1px solid #ccc;}
.window,
.window-shadow {
position: absolute;
}
.window-shadow {
background: #ccc;
}


.calendar table {
table-layout: fixed;
border-collapse: separate;
font-size: 18px;
width: 100%;
height: 100%;
}
.calendar table td,
.calendar table th {
font-size: 18px;
}

.calendar-header {
position: relative;
height: 42px;
}
.calendar-title {
text-align: center;
height: 42px;
}
.calendar-title span {
position: relative;
display: inline-block;
top: 2px;
padding: 0 3px;
height: 38px;
line-height: 38px;
font-size: 18px;
cursor: pointer;
-moz-border-radius: 5px 5px 5px 5px;
-webkit-border-radius: 5px 5px 5px 5px;
border-radius: 5px 5px 5px 5px;
}


.td_1 {
width: 30%;
text-align: center;
background: #FAFAFA;
border-bottom: 1px dotted #E0E0E0;
border-right: 1px dotted #E0E0E0;
padding:10px;
font-size:18px;
}
.td_2 {
width:70%;
background:#ffffff;
border-bottom:1px dotted #E0E0E0;
padding:10px;
font-size:18px;
}

/* 바코드 Style Start */
.barcode
{
    width: <%=px*70%>px;
    /*height:<%=px*14%>px;*/
    height:<%=px*10%>px;
    /*margin: 5px auto;*/
    margin: 4px auto;
}

img {
    /* opacity: 0.4; */
    filter: alpha(opacity=40); /* For IE8 and earlier */
}

.bar_tb
{
    width:360px;
    /*font-size:15px;*/
    height:420px;
    font-size:16px;
    border:2px solid #333;
    border-spacing:0;
    align-self: center;
    margin-top: 5px;
}


/*수량은 폰트사이즈 크게 적용 by김효정 2018-11-01*/
.bar_fs26 { font-size:26px; }
.bar_fs23 { font-size:23px; }
.bar_fs18 { font-size:18px; }
.bar_fs15 { font-size:15px; }
.bar_fs13 { font-size:13px; }

/* 주입제 바코드 Style Start */
.barcode2
{
    width: <%=px*55%>px;
    /*height:<%=px*14%>px;*/
    height:<%=px*10%>px;
    /*margin: 5px auto;*/
    margin: 4px auto;
}


/* 주입제 이동전표 */
.bar_tb2
{
    width:200px;
    /*font-size:15px;*/
    font-size:9px;
    border:2px solid #333;
    border-spacing:0;
    align-self: center;
}

.bar_t
{
    /*font-size:20px;text-align:center;font-weight:bold;border-width:0 0 1px 0;border-style:solid;border-color:#333;*/
    height:110px;font-size:28px;text-align:center;font-weight:bold;border-width:0 0 1px 0;border-style:solid;border-color:#333;padding-top:3px; padding-bottom:3px;
}

/* 주입제 */
.bar_t2
{
    /*font-size:20px;text-align:center;font-weight:bold;border-width:0 0 1px 0;border-style:solid;border-color:#333;*/
    font-size:9px;text-align:center;font-weight:bold;border-width:0 0 1px 0;border-style:solid;border-color:#333;
}

.bar1
{
    /*width:30%;height:20px;text-align:center;border-width:0 1px 1px 0;border-style:solid;border-color:#333;*/
    width:42%;height:30px;text-align:center;border-width:0 1px 1px 0;border-style:solid;border-color:#333;word-break:break-all;
}

.bar2
{
    /*width:70%;height:20px;border-width:0 0 1px 0;border-style:solid;border-color:#333;padding-left:10px;*/
    width:58%;height:19px;border-width:0 0 1px 0;border-style:solid;border-color:#333;padding-left:5px;word-break:break-all;
}

.bar3
{
    /*width:30%;height:20px;text-align:center;border-width:0 1px 1px 0;border-style:solid;border-color:#333;*/
    width:30%;height:19px;text-align:center;border-width:0 1px 1px 0;border-style:solid;border-color:#333;
}

.bar4
{
    /*width:70%;height:20px;border-width:0 0 1px 0;border-style:solid;border-color:#333;padding-left:10px;*/
    width:70%;height:19px;border-width:0 0 1px 0;border-style:solid;border-color:#333;padding-left:10px;
}

.prt_outdiv
{
    /*padding:15px;background:#fff;width:300px;border-radius:5px;*/
    /*padding:3px;background:#fff;width:280px;border-radius:5px;*/
    padding:1px; background:#fff;width:360px;border-radius:5px;
    /* 현진에 적용된 라벨 워터마크 2018-02-01 by김효정
    background-image: url("./watermark3.png");
    background-repeat: no-repeat;
    background-position: 75% 35%;
    background-size: 117px 74px;*/
}

.prt_outdiv2
{
    /*padding:15px;background:#fff;width:300px;border-radius:5px;*/
    padding:3px;background:#fff;width:220px;border-radius:5px;
}

div.breakhere {page-break-before: always}

</style>

<script type="text/javascript">

function myFunction(msg) {
    // Get the snackbar DIV
    var x = document.getElementById("snackbar")

    // Add the "show" class to DIV
    x.className = "show";
    x.innerHTML = msg;

    // After 3 seconds, remove the show class from DIV
    setTimeout(function () { x.className = x.className.replace("show", ""); }, 3000);
}

function myformatter(date)
{
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();
    return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
}

function myparser(s)
{
    if (!s) return new Date();
    var ss = (s.split('-'));
    var y = parseInt(ss[0], 10);
    var m = parseInt(ss[1], 10);
    var d = parseInt(ss[2], 10);
    if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
        return new Date(y, m - 1, d);
    } else {
        return new Date();
    }
}

//자동으로 URL Bar 아래로 스크롤 하는 방법

if ((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPad/i))) {
    window.addEventListener('load', function () {
        setTimeout(scrollTo, 0, 0, 1);
    }, false);
}

// status-bar-style: default, black, black-translucent(반투명)
// UI 없는 Fullscreen 모드인지 확인하기

if (navigator.standalone) {alert("전체화면 실행중");}

</script>
<div id="snackbar"></div>
<%
    if session("charset") = "" then
        session("charset") = request.cookies("charset")
    end if

    select case Ucase(session("charset"))
    case "KOR" : char_gubun = 0
    case "RUS" : char_gubun = 1
    case "ENG" : char_gubun = 2
    case "CHN" : char_gubun = 3
    case "VIE" : char_gubun = 4
    case "MEX" : char_gubun = 5
    case "POL" : char_gubun = 6
    case "JPN" : char_gubun = 7
    case else : char_gubun = 0
    end select

%>
<!--#include virtual="/nerp/inc/lang/lang.asp" -->

<body>
<div style='width:144px;height:57px;' id='testQR'>
  <div style='border:1px solid;height:56px;width:143px'>

           <div id='qrcode1' style='float:left;margin-left:5px;padding-top:12px;'></div>
           <script type='text/javascript'>
            $('#qrcode1').kendoQRCode({
                   value: '123',
                   type: 'ecc200',
                   size: '25px'
              });
            </script>
&nbsp;<div style='display:inline-block;line-height:1px'> <span style='font:bold 8px/0 Arial Narrow;display:inline-block' id='GMPN1'>8491</span> <span style='font:bold 14px Arial Narrow;display:inline-block' id='GMPN2'>8167</span>
<br/><span style='display:inline-block;font:bold 8px Arial Narrow;' id='VPPS_label'>7390200000000X</span>
<br/><span style='display:inline-block;font:bold 8px Arial Narrow;' id='DUNS_label'>555343750</span>
<br/><span style='display:inline-block;font:bold 8px Arial Narrow;' id='lotno_label'>1111111111111111</span>
</div>
</div>
</div>
</body>
