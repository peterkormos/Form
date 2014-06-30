<%@ page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>

<%
  MSZPollsServletDAO dao = new MSZPollsServletDAO(null);
%>


<%@page import="org.msz.util.WebUtils"%><html>

<body>
<%
//  int userID = Integer.parseInt((String) session
//      .getAttribute(MSZPollsServlet.USER_ID));
//  User user = (User) dao.get(userID, User.class);
  
  Integer pollGroupID = Integer.parseInt(WebUtils.getParameter(request,
      MSZPollsServlet.POLL_GROUP_ID));

  for (int userID : dao.getUsersInGroup(pollGroupID))
  {
    %>
    <%=((User) dao.get(userID, User.class)).emailAddress %>
    <br>
<%
  }

%>
<p>
<jsp:include page="showUsersOnGoogleMap.jsp"/>

</body>
</html>
