<!--#include Virtual = "/heung.asp" -->
<%
cDataType = request("cDataType")
cDatasource = request("cDatasource")
select case cDataType
case ""
    gubun1 = trim(request("gubun1"))
    gubun2 = trim(request("gubun2"))
    'idx = request("idx")
    sch_date00 = trim(request("sch_date00"))

    sql = "exec viser_xerp ..practice 'view', '"&gubun1&"', '"&gubun2&"', '"&sch_date00&"'"
    set  rs  =  conn.execute(sql)

    row_count = 0

    while not rs.eof
        idx           = rs("idx")
        j_date_year   = rs("j_date_year")
        j_date_month  = rs("j_date_month")
        j_gubun       = rs("gubun_name1")
        j_gubun1      = rs("gubun_name2")
        j_part_code   = rs("j_part_code")
        j_qty         = rs("j_qty")
        j_price       = rs("j_price")
        j_remark      = rs("j_remark")

        json_data = json_data & "{""idx"":"""& idx &""", ""j_date_year"":"""& j_date_year &""", ""j_date_month"":"""& j_date_month &""",""j_gubun"":"""& j_gubun &""", ""j_gubun1"":"""& j_gubun1 &""", "
        json_data = json_data & " ""j_part_code"":"""& j_part_code &""",""j_qty"":"& j_qty&",""j_price"":"""& j_price &""",""j_remark"":"""& j_remark &"""} "

        row_count = row_count + 1
        rs.movenext

        if not rs.eof then
          json_data = json_data & ","
        end if
    wend

    json_fdata  = "{""total"":"""& row_count &""",""rows"":["
    json_mdata   = "]}"
    json_data   = json_fdata & json_data & json_mdata

    response.write json_data
    rs.close : set rs = nothing

case "combo"
  sql = "select gubun_name, gubun_seq from gubun1 where gubun_code = '"& cDatasource &"'"
  set rs = conn.execute(sql)
  json_data = "["
  while not rs.eof
    j_id        = cDatasource & rs("gubun_seq")
    j_text      = rs("gubun_name")
    json_data = json_data & "{""id"":""" & j_id & """, ""text"":""" & j_text & """}"
    rs.movenext
    if not rs.eof then
      json_data = json_data & ","
    end if
  wend
  json_data = json_data & "]"
  response.write json_data
  rs.close : set rs = nothing
end select
%>
