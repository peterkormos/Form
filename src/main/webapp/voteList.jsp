<%@ page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="org.msz.util.WebUtils"%>
<%@page import="java.util.List"%>

<%@include file="util.jsp" %>

<tr>
	<td>V&aacute;laszok:</td>
	<td>
	<table width="100%" border="1">
		<tr>
			<td>
			<table width="100%" border="0">
				<tr>
					<th>
					<div align="left">Szavaz&oacute;</div>
					</th>
					<th>
					<div align="left">Lehet&otilde;s&eacute;g</div>
					</th>
					<th>
					<div align="left">V&aacute;lasz</div>
					</th>
				</tr>
				<%
				  MSZPollsServletDAO dao = new MSZPollsServletDAO("");

				  int pollID = Integer.parseInt(WebUtils.getParameter(request,
				      MSZPollsServlet.POLL_ID));

				  List<Vote> votes = dao.getVotesForPoll(pollID);

				  int cnt = 0;
				  for (Vote vote : votes)
				  {
				    cnt++;
				    
				    for (VoteOption voteOption : vote.options)
				    {
				      String key = voteOption.name + " - " + voteOption.value;
				%>
				<tr <%=cnt %2 == 0 ? "" : "bgcolor='#DDDDDD'" %>>

					<td><%=((User) dao.get(vote.userID, User.class)).emailAddress%></td>
					<td><%=voteOption.name%></td>
					<td><%=getVoteValue(voteOption)%></td>
				</tr>
				<%
				  }
				  }
				%>
			</table>
			</td>
		</tr>
	</table>
	</td>
</tr>



