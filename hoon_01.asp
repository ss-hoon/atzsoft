<!DOCTYPE html>
<html>
<head>
  <meta charset = "UTF-8">
  <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/default/easyui.css">
  <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/icon.css">
  <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/color.css">
  <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/demo/demo.css">
  <script type="text/javascript" src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
  <script type="text/javascript" src="https://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>

</head>
<body>
  <div style="margin:20px 0;width:auto;height:auto">
  <table class="easyui-datagrid" id = "dg" title="발주(balju) 테이블" >
  <thead>
    <tr>
      <th data-options="field:'s_date',width:'20%'">시작날짜</th>
      <th data-options="field:'f_date',width:'20%'">종료날짜</th>
      <th data-options="field:'b_buseo',width:'20%'">부서</th>
      <th data-options="field:'w_name',width:'20%'">발주자</th>
      <th data-options="field:'b_pcode',width:'20%'">코드</th>
    </tr>
  </thead>
  </table>
  </div>
  <div id="searchbar" style="padding:2px 5px; height:auto">
    <input class="easyui-datebox" id="sdate">
    <label>~</label>
    <input class="easyui-datebox" id="edate">
    <input class = "easyui-combobox" id="dept">
    <input class="easyui-combobox" id="worker">
    <a href="#" class="easyui-linkbutton" iconCls="icon-search" id="search" onclick="doSearch()">Search</a>
  </div>
  <div id="snackbar"></div>
</body>
<style type = "text/css">
#snackbar {
    visibility: hidden; /* Hidden by default. Visible on click */
    min-width: 350px; /* Set a default minimum width */
    margin-left: -125px; /* Divide value of min-width by 2 */
    background-color: #333; /* Black background color */
    color: #fff; /* White text color */
    text-align: center; /* Centered text */
    border-radius: 2px; /* Rounded borders */
    padding: 16px; /* Padding */
    position: fixed; /* Sit on top of the screen */
    z-index: 9999999; /* Add a z-index if needed */
    left: 50%; /* Center the snackbar */
    bottom: 0; /* 30px from the bottom */
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
</style>
<script type = "text/javascript">
  $(document).ready(function(){
    $('#dg').datagrid({
        url : 'hoon_01x.asp?',
        singleSelect:true,
        collapsible:true,
        rownumbers:true,
        toolbar:"#searchbar",
        width : '100%'
    });
    $('#sdate').datebox({
      width : 110,
      prompt:'From',
      formatter:myformatter,
      parser:myparser
    });
    $('#edate').datebox({
      width : 110,
      prompt:'To',
      formatter:myformatter,
      parser:myparser
    });
    $('#dept').combobox({
      url : 'hoon_01x.asp?src=option',
      width : 100,
      valueField:'id',
      textField:'text',
      panelHeight:'auto',
      selectOnNavigation:'false',
      prompt : '부서',
      onSelect : function(rec){
        setTimeout(function(){
          change_worker();
        },0);
      }
    });
    $('#worker').combobox({
      url : 'hoon_01x.asp?src=worker',
      width : 100,
      valueField : 'id',
      textField : 'text',
      panelHeight:'auto',
      selectOnNavigation:'false',
      prompt : '작업자'
    });
  });
  function doSearch(){
    var dept = $('#dept').combobox('getValue');
    var sdate = $('#sdate').datebox('getValue');
    var edate = $('#edate').datebox('getValue');
    var worker = $('#worker').combobox('getValue');

    if(dept == "" && sdate == "" && edate == "" && worker == ""){
      myFunction("검색 항목을 하나 이상 입력하세요.");
      return false;
    }

    if(date_diff(sdate,edate) < 0){
      myFunction("검색 시작일이 검색 종료일보다 늦습니다.");
      return false;
    }

    $('#dg').datagrid({
      url : 'hoon_01x.asp?src=load',
      queryParams: {
        sdate : $('#sdate').combobox('getValue'),
        edate : $('#edate').combobox('getValue'),
        dept : $('#dept').combobox('getValue'),
        worker : $('#worker').combobox('getValue')
      }
    });
  }
  function myFunction(msg){
    var x = document.getElementById("snackbar")

    // Add the "show" class to DIV
    x.className = "show";
    x.innerHTML = msg;

    // After 3 seconds, remove the show class from DIV
    setTimeout(function() { x.className = x.className.replace("show", ""); }, 3000);
  }
  function date_diff(sDate, eDate)
  {
      var dateArray = sDate.split("-");
      var dateObj = new Date(dateArray[0], Number(dateArray[1] - 1), dateArray[2]);

      var dateArray1 = eDate.split("-");
      var dateObj1 = new Date(dateArray1[0], Number(dateArray1[1] - 1), dateArray1[2]);
  }
  function myformatter(date) {
      var y = date.getFullYear();
      var m = date.getMonth() + 1;
      var d = date.getDate();
      return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
  }
  function myparser(s) {
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
  function change_worker(){
    $('#worker').combobox({
      url : 'hoon_01x.asp?src=worker',
      queryParams : {
        select_item : $('#dept').combobox('getValue')
      }
    });
  }
</script>
</html>
