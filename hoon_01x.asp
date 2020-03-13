<!-- #include virtual="config_db.asp" -->
<%
  src = request("src")
  select case src

  '<초기 데이터 로드>'
    case ""
      sql = "SELECT * FROM balju "
      sql = sql & "left join gubun1 on gubun1.unique_cd = balju.b_buseo "
      sql = sql & "left join insamst on b_sabun = insa_sabun "
      sql = sql & "where gubun1.gubun_code = 'ZS'"

      set rs = dbcon.Execute(sql)
      dbRecord.Open sql, dbcon

      json_data = "["
      while not rs.Eof
        json_data = json_data & "{""s_date"":"""& trim(rs("b_date")) &""", ""f_date"":""" & trim(rs("b_date1")) & """,""b_buseo"":"""& trim(rs("gubun_name"))
        json_data = json_data & """,""w_name"":""" & trim(rs("insa_name")) & """,""b_pcode"":"""& trim(rs("b_pcode")) & """}"

        rs.MoveNext
        if not rs.EOF then
          json_data = json_data & ","
        End if

      wend
      json_data =  json_data & "]"
      response.write json_data
      rs.close :  set rs = nothing

  '<검색 값에 맞게 데이터 로드>'
    case "load"
      sdate = trim(request("sdate"))
      edate = trim(request("edate"))
      dept = trim(request("dept"))
      worker = trim(request("worker"))

      sql = "SELECT b_date, b_date1, gubun_name, insa_name, insa_sabun, b_pcode FROM balju"
      sql = sql & " left join gubun1 on unique_cd = b_buseo"
      sql = sql & " left join insamst on b_sabun = insa_sabun"
      sql = sql & " where 1=1"

      '<검색 조건에 맞게 쿼리 추가>'

      if sdate <> "" then '검색 시작일(sdate)이 있는 경우'
        sql = sql & " and b_date >= '" & sdate & "'"
      end if

      if edate <> "" then '검색 종료일(edate)이 있는 경우'
        sql = sql & " and b_date1 <= '" & edate & "'"
      end if

      if dept <> "" then '부서(dept)가 있는 경우'
        sql = sql & " and unique_cd = '" & dept & "'"
      end if

      if worker <> "" then '발주자(worker)가 있는 경우'
        sql = sql & " and insa_sabun = '" & worker & "'"
      end if
      '--------------------------------------------'

      '<검색 시작일과 검색 종료일이 오름차순으로 정렬>'

      if sdate <> "" and edate <> "" then
        sql = sql & " order by b_date, b_date1"
      elseIf sdate <> "" then
        sql = sql & " order by b_date"
      else
        sql = sql & " order by b_date1"
      end if
      '-------------------------------------------'

      set rs = dbcon.Execute(sql)
      dbRecord.Open sql, dbcon

      json_data = "["
      while not rs.Eof
        json_data = json_data & "{""s_date"":"""& trim(rs("b_date")) &""", ""f_date"":""" & trim(rs("b_date1")) & """,""b_buseo"":"""& trim(rs("gubun_name"))
        json_data = json_data & """,""w_name"":""" & trim(rs("insa_name")) & """,""b_pcode"":"""& trim(rs("b_pcode")) & """}"

        rs.MoveNext
        if not rs.Eof then
          json_data = json_data & ","
        End if
      wend
      json_data = json_data & "]"
      response.write json_data
      rs.close : set rs = nothing

  '<select option 항목 불러오기>'
    case "option"

      sql = "SELECT unique_cd, gubun_name FROM gubun1 WHERE gubun_code = 'ZS'"
      set rs = dbcon.Execute(sql)
      dbRecord.Open sql, dbcon

      json_data = "["
      while not rs.EOF
        json_data = json_data & "{""id"":""" & trim(rs("unique_cd")) & """,""text"":""" & trim(rs("gubun_name")) & """}"

        rs.MoveNext
        if not rs.Eof then
          json_data = json_data & ","
        End If
      wend
      json_data = json_data & "]"
      response.write json_data
      rs.close : set rs = nothing

    '<작업자 항목 불러오기>'
    case "worker"
      select_item = trim(request("select_item"))

      sql = "SELECT insa_sabun, insa_name from insamst"

      if not select_item = "" then
        sql = sql & " where insa_buseo = '" & select_item & "'"
      End if

      set rs = dbcon.Execute(sql)
      dbRecord.Open sql, dbcon

      json_data = "["
      while not rs.EOF
        json_data = json_data & "{""id"" : """ & trim(rs("insa_sabun")) & """,""text"" : """ & trim(rs("insa_name")) & """}"
        rs.MoveNext
        if not rs.Eof then
          json_data = json_data & ","
        End if
      wend
      json_data = json_data & "]"
      response.write json_data
      rs.close : set rs = nothing
  end select
%>
