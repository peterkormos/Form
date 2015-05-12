<%@ page import="org.msz.servlet.*"%>

<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.util.WebUtils"%>

<%@include file="util.jsp"%>

<link rel="stylesheet" href="base.css" media="screen" />

<html>
<body>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">

		<jsp:include page="pollHeader.jsp" />

		<jsp:include page="statisticsDetails.jsp" />

		<jsp:include page="voteList.jsp" />

	</table>

</body>
</html>

