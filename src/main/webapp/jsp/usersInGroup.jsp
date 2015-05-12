<%@ page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>

<%
  PollsServletDAO dao = PollsServletDAO.getInstance();
%>


<%@page import="org.msz.util.WebUtils"%><html>

<body>
	<%
	  Integer pollGroupID = Integer.parseInt(WebUtils.getParameter(request, HTTPRequestParamNames.POLL_GROUP_ID));

	  for (int userID : dao.getUsersInGroup(pollGroupID))
	  {
	%>
	<%=((User) dao.get(userID, User.class)).emailAddress%>
	<br>
	<%
	  }
	%>
	<p>
		<jsp:include page="admin/showUsersOnGoogleMap.jsp" />
</body>
</html>
