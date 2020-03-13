<!--#include Virtual = "/heung.asp" -->

<%
    sYear = year(date)
    sMon = month(date)
%>
<link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/color.css">
<link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/demo/demo.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="https://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>

<html>
<body >
  <div data-options="easy-layout" id="main" style="width: 100%; height: 100%; padding: 0; border: 0;" data-options="fit:true">
      <div id="tb" style="padding: 10px;">
        <!--<input type="text" class="textbox" id="searchStr" style="width: 150px; height: 25px; text-align: center;" placeholder="인덱스 검색" />
        <input type="text" class="textbox" id="searchStr1" style="width: 150px; height: 25px; text-align: center;" placeholder="공장구분 검색" />
        <input type="text" class="textbox" id="searchStr2" style="width: 150px; height: 25px; text-align: center;" placeholder="품번대분류 검색" />-->
        <input class="easyui-combobox" id="combo-gubun1" style="width:125px;" placeholder="공장구분 검색" />
        <input class="easyui-combogrid" id="combo-gubun2" style="width:125px;" placeholder="품번대분류 검색" />
        <input id="sYear" class="easyui-numberspinner" data-options="min:2017,spinAlign:'horizontal',width:100" value="<%=sYear%>">
        <input id="sMon" class="easyui-numberspinner" data-options="min:1,max:12,spinAlign:'horizontal',width:100" value="<%=sMon%>">
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSearch();">검색</a>
      </div>

      <div data-options="region:'north',split:true,border:false" style="height:93%;">
                  <table id="dg">
                      <thead>
                          <tr>
                              <th data-options="field:'idx',width:'10%',sortable:'true',halign:'center'">idx</th>
                              <th data-options="field:'j_date_year',width:'10%',sortable:'true',halign:'center'">year</th>
                              <th data-options="field:'j_date_month',width:'10%',sortable:'true',halign:'center'">month</th>
                              <th data-options="field:'j_gubun',width:'10%',align:'center'">구분1</th>
                              <th data-options="field:'j_gubun1',width:'10%',align:'center'">구분2</th>
                              <th data-options="field:'j_part_code',width:'10%',sortable:'true',halign:'center'">품번</th>
                              <th data-options="field:'j_qty',width:'10%',sortable:'true',halign:'center'">재고</th>
                              <th data-options="field:'j_price',width:'10%',align:'right',sortable:'true',halign:'center'">단가</th>
                              <th data-options="field:'j_remark',width:'20%',align:'right',sortable:'true',halign:'center'">비고</th>
                          </tr>
                      </thead>
                  </table>
      </div>
      <div data-options="region:'center'">

      </div>
      <div data-options="region:'south'">

      </div>
  </div>
</body>
</html>

<script type="text/javascript">
$(document).ready(function(){
  $('#dg').datagrid({
    fit: true,
    rownumbers: true,
    singleSelect: true,
    striped: true,
  });

  $('#combo-gubun1').combobox({
      url: './heung_01x.asp?cDataType=combo&cDatasource=SS',
      valueField: 'id',
      textField: 'text',
      panelHeight: 'auto'
  })
  $('#combo-gubun2').combogrid({
    url: './heung_01x.asp?cDataType=combo&cDatasource=J3',
    valueField: 'id',
    textField: 'text',
    panelHeight: 'auto',
    panelWidth: 220,
    fitColumns: 'true',
    mode: 'remote',
    method: 'get',
    columns: [[
      {field:'id', title:'품번', width:120},
      {field:'text', title:'차종', width:100}
    ]]
  })
});


function doSearch(){
  var y = $("#sYear").numberspinner('getValue');
  var m = $("#sMon").numberspinner('getValue');
  var sch_date00 = y + '-' + (m < 10 ? ('0' + m) : m);
  $('#dg').datagrid({
      url: './heung_01x.asp',
      queryParams : {
      //idx : $("#searchstr").val(),
      //gubun1: $("#searchStr1").val(),
      //gubun2: $("#searchStr2").val(),
      gubun1: $("#combo-gubun1").val(),
      gubun2: $("#combo-gubun2").val(),
      sch_date00: sch_date00,
      cDataType: "",
      cDatasource: ""
      }
  });
}

</script>
<%
conn.Close : Set conn = Nothing
%>
