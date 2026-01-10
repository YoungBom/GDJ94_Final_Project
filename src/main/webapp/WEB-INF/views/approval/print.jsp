<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String bg = (String) request.getAttribute("bgImageUrl");
  String fields = (String) request.getAttribute("fieldsJspf");

  // fieldsJspf가 "/WEB-INF/views/approval/print/..."로 오면 "print/..."로 정규화
  if (fields != null && fields.startsWith("/WEB-INF/views/approval/")) {
      fields = fields.substring("/WEB-INF/views/approval/".length());
  }
%>

<div style="position:relative; width:1250px; margin:0 auto; background:#fff;">
  <img src="<%= bg %>" style="width:100%; height:auto; display:block;" />

  <div style="position:absolute; left:0; top:0; width:100%; height:100%;">
    <%
      if (fields != null) {
          request.getRequestDispatcher("/WEB-INF/views/approval/" + fields).include(request, response);
      } else {
          out.print("fieldsJspf is null");
      }
    %>
  </div>
</div>
