<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>

<%@include file="../util.jsp"%>

<%
  highlightStart = 0xFFBFBF;
  PollsServletDAO dao = PollsServletDAO.getInstance();
  int userID = Integer.parseInt((String) session.getAttribute(HTTPRequestParamNames.USER_ID));
  User user = (User) dao.get(userID, User.class);

  List<Record> allUsers = getAllUsers();
%>

<table width="100%" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="350"><strong>T&ouml;rl&eacute;s</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr valign="top">
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Szavaz&aacute;s t&ouml;rl&eacute;se:</td>
					<td>
						<form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.deletePoll%>">
							Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
								<%
								  for (Poll poll : user.getOwnedPolls())
								  {
								%>
								<option value="<%=poll.id%>" onclick="this.parentNode.submit();">
									<%=poll.title%></option>
								<%
								  }
								%>
							</select> <input type="button" onClick="this.parentNode.submit();"
								value="T&ouml;rl&eacute;s">
						</form>
					</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Szavaz&aacute;s hozz&aacute;m rendel&eacute;se:</td>
					<td>
						<form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.assignPoll%>">
							Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
								<%
								  for (Record record : dao.getPolls())
								  {
										Poll poll = (Poll) record;
										if (poll.ownerID == userID)
										  continue;
								%>
								<option value="<%=poll.id%>" onclick="this.parentNode.submit();">
									<%=poll.title%></option>
								<%
								  }
								%>
							</select> <input type="button" onClick="this.parentNode.submit();"
								value="hozz&aacute;m rendel&eacute;s">
						</form>
					</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Saj&aacute;t szavazat t&ouml;rl&eacute;se:</td>
					<td>
						<form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.deleteVote%>">
							Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
								<%
								  for (Poll poll : user.getOwnedPolls())
								  {
								%>
								<option value="<%=poll.id%>" onclick="this.parentNode.submit();">
									<%=poll.title%></option>
								<%
								  }
								%>
							</select> <input type="button" onClick="this.parentNode.submit();"
								value="T&ouml;rl&eacute;s">
						</form>
					</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>M&aacute;s szavaz&aacute;s&aacute;nak t&ouml;rl&eacute;se</td>
					<td><form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.deleteVote%>">
							Felhaszn&aacute;l&oacute;: <select
								name="<%=HTTPRequestParamNames.DELETED_USER_ID%>">
								<%
								  for (Record record : allUsers)
								  {
										User deletedUser = (User) record;
								%>
								<option value="<%=deletedUser.id%>"
									onclick="this.parentNode.submit();"><%=deletedUser.emailAddress%></option>
								<%
								  }
								%>
							</select> Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
								<%
								  for (Poll poll : user.getOwnedPolls())
								  {
								%>
								<option value="<%=poll.id%>" onclick="this.parentNode.submit();">
									<%=poll.title%></option>
								<%
								  }
								%>
							</select> <input type="button" onClick="this.parentNode.submit();"
								value="T&ouml;rl&eacute;s">
						</form></td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Felhaszn&aacute;l&oacute; t&ouml;rl&eacute;se:</td>
					<td>
						<form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.deleteUser%>">
							Felhaszn&aacute;l&oacute;: <select
								name="<%=HTTPRequestParamNames.DELETED_USER_ID%>">
								<%
								  for (Record record : allUsers)
								  {
										User deletedUser = (User) record;
								%>
								<option value="<%=deletedUser.id%>"
									onclick="this.parentNode.submit();"><%=deletedUser.emailAddress%></option>
								<%
								  }
								%>
							</select> <input type="button" onClick="this.parentNode.submit();"
								value="T&ouml;rl&eacute;s">
						</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
