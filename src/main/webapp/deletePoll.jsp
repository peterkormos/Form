<%@ page import="org.msz.servlet.*"%>

<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.Poll"%>
<%@page import="java.util.List"%>
<%@page import="org.msz.servlet.datatype.User"%>
<%@page import="java.util.Set"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

</head>
<body>
<%
    MSZPollsServletDAO dao = new MSZPollsServletDAO("");

    Set<Record> polls = (Set<Record>) dao.getAll(Poll.class);
%>

<form accept-charset="UTF-8" action="MSZPollsServlet" method="POST" accept-charset="UTF-8">
<input type="hidden"
	id="command" name="<%=MSZPollsServlet.COMMAND %>"
	value="<%=MSZPollsServlet.COMMAND_DELETE_POLL %>"> <select
	name="<%=MSZPollsServlet.POLL_ID %>">
	<%
	    for (Record record : polls)
	    {
			Poll poll = (Poll) record;

			out.println("<option value='" + poll.id + "'>" + poll.title
				+ " </option>");
	    }
	%>
</select> 
  <input type="submit" value="T&ouml;r&ouml;l">
</form>
</body>
</html>

