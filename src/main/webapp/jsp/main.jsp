<%@page import="org.msz.servlet.datatype.UserRole.Role"%>
<%@ page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="org.msz.servlet.datatype.polls.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>

<%@page import="java.io.File"%><html>

<%@include file="util.jsp"%>

<%
  highlightStart = 0xE0E0E0;
  PollsServletDAO dao = PollsServletDAO.getInstance();
  int userID = Integer.parseInt((String) session.getAttribute(HTTPRequestParamNames.USER_ID));
  User user = (User) dao.get(userID, User.class);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript">
	function sendSubmit(currentNode, command) {
		currentNode.getElementsByTagName("input")[0].value = command;
		currentNode.submit();
	}
</script>
</head>
<body>
	<form accept-charset="UTF-8" action="../PollsServlet" method="POST">
		<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
			value="<%=PollsServlet.Command.logout%>"> Bejelentkezett
		felhaszn&aacute;l&oacute;:
		<%=user.emailAddress%>
		- <a href="inputUser.jsp">Felhaszn&aacute;l&oacute;i adatok
			m&oacute;dos&iacute;t&aacute;sa</a> - <input type="submit"
			value="Kijelentkez&eacute;s">
	</form>

	<p>
		<%
		  String message = (String) session.getAttribute(HTTPRequestParamNames.MESSAGE_IN_HTTPSESSION);

		  if (message != null)
		  {
		%>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td bgcolor="#CCFFCC">
				<%
				  out.println(message);
						session.removeAttribute(HTTPRequestParamNames.MESSAGE_IN_HTTPSESSION);
				%>
			</td>
		</tr>
	</table>
	<%
	  }

	  Object[] allVisiblePolls = { user.getOwnedPolls(), dao.getPollsFromGroups(user.getPollGroups()),
			  dao.getAll(PublicPoll.class) };

	  String[] labels = { "Saj&aacute;t szavaz&aacute;saim", "Z&aacute;rt szavaz&aacute;sok",
			  "Nyilv&aacute;nos szavaz&aacute;sok" };
	%>
	<br>
	<table width="100%" border="1" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
						<td width="350"><strong>Szavaz&aacute;s</strong></td>
						<td>&nbsp;</td>
					</tr>
					<tr valign="top">
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr valign="top">
						<td>&Uacute;j szavaz&aacute;s:</td>
						<td>
							<form accept-charset="UTF-8" action="inputPoll.jsp" method="POST">
								<input type="submit"
									value="&Uacute;j szavaz&aacute;s felvitele a rendszerbe">
							</form>
						</td>
					</tr>
					<tr valign="top" bgcolor="<%=highlight()%>">
						<td>Szavaz&aacute;s:</td>
						<td>
							<form accept-charset="UTF-8" action="inputVote.jsp" method="POST">
								<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>">
								Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
									<%
									  for (int i = 0; i < allVisiblePolls.length; i++)
									  {
									%>
									<optgroup label='<%=labels[i]%>'>
										<%
										  for (Record record : (Set<Record>) allVisiblePolls[i])
												{
												  Poll poll = record instanceof Poll ? (Poll) record : ((PublicPoll) record).poll;

												  Vote vote = null;
												  try
												  {
													vote = dao.getVote(userID, poll.id);

													if (vote != null && !poll.userCanResubmit)
													  continue;
												  }
												  catch (Exception ex)
												  {

												  }
										%>
										<option value="<%=poll.id%>"
											onclick="this.parentNode.submit();">
											<%=poll.title + (vote != null ? " - VAN SZAVAZATA" : "")%>
										</option>
										<%
										  }
										%>
									</optgroup>
									<%
									  }
									%>
								</select> <input type="button" onClick="this.parentNode.submit();"
									value="Ugr&aacute;s a szavaz&aacute;sra">
							</form>
						</td>
					</tr>
					<tr valign="top" bgcolor="<%=highlight()%>">
						<td>Szavaz&aacute;s m&oacute;dos&iacute;t&aacute;sa:</td>
						<td>
							<form accept-charset="UTF-8" action="inputPoll.jsp" method="POST">
								Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
									<%
									  for (Record record : user.getOwnedPolls())
									  {
											Poll poll = (Poll) record;

											out.println("<option value='" + poll.id + "' onclick=\"this.parentNode.submit();\">" + poll.title + "</option>");
									  }
									%>
								</select> <input type="button" onClick="this.parentNode.submit();"
									value="Megn&eacute;z">
							</form>
						</td>
					</tr>
					<tr valign="top" bgcolor="<%=highlight()%>">
						<td>Szavaz&aacute;s eredm&eacute;nye:</td>
						<td>
							<form accept-charset="UTF-8" action="statistics.jsp"
								method="POST">
								<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>">
								Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
									<%
									  Set<Record> votedPolls = new HashSet<Record>();
									  votedPolls.addAll(user.getOwnedPolls());
									  votedPolls.addAll(dao.getPollsFromGroups(user.getPollGroups()));
									  votedPolls.addAll(dao.getAll(PublicPoll.class));

									  for (Record record : votedPolls)
									  {
											Poll poll = record instanceof Poll ? (Poll) record : ((PublicPoll) record).poll;

											out.println("<option value='" + poll.id + "' onclick=\"this.parentNode.submit();\">" + poll.title + " </option>");
									  }
									%>
								</select> <input type="button" onClick="this.parentNode.submit();"
									value="Ugr&aacute;s a szavaz&aacute;sra">
							</form>
						</td>
					</tr>
					<tr valign="top" bgcolor="<%=highlight()%>">
						<td>Email &eacute;rtes&iacute;t&otilde; k&eacute;r&eacute;se
							ha v&aacute;lasz &eacute;rkezik:</td>
						<td>
							<form accept-charset="UTF-8" action="../PollsServlet"
								method="POST">
								<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
									value="<%=PollsServlet.Command.subscribeToPoll%>">
								Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
									<%
									  for (int i = 0; i < allVisiblePolls.length; i++)
									  {
									%>
									<optgroup label='<%=labels[i]%>'>
										<%
										  for (Record record : (Set<Record>) allVisiblePolls[i])
												{
												  Poll poll = record instanceof Poll ? (Poll) record : ((PublicPoll) record).poll;

												  Vote vote = null;
												  try
												  {
													vote = dao.getVote(userID, poll.id);

													if (vote != null && !poll.userCanResubmit)
													  continue;
												  }
												  catch (Exception ex)
												  {

												  }
										%>
										<option value="<%=poll.id%>"
											onclick="this.parentNode.submit();">
											<%=poll.title + (vote != null ? " - VAN SZAVAZATA" : "")%>
										</option>
										<%
										  }
										%>
									</optgroup>
									<%
									  }
									%>
								</select> <input type="button" onClick="this.parentNode.submit();"
									value="Feliratkoz&aacute;s">
							</form>
						</td>
					</tr>
					<tr valign="top" bgcolor="<%=highlight()%>">
						<td>Leiratkoz&aacute;s az email
							&eacute;rtes&iacute;t&otilde;r&otilde;l:</td>
						<td>
							<form accept-charset="UTF-8" action="../PollsServlet"
								method="POST">
								<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
									value="<%=PollsServlet.Command.unsubscribeFromPoll%>">
								Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
									<%
									  for (Subscription subscription : dao.getSubscriptionsForUser(userID))
									  {
											Poll poll = (Poll) dao.get(subscription.pollID, Poll.class);
									%>
									<option value="<%=poll.id%>"
										onclick="this.parentNode.submit();">
										<%=poll.title%>
									</option>
									<%
									  }
									%>
								</select> <input type="button" onClick="this.parentNode.submit();"
									value="Feliratkoz&aacute;s">
							</form>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<%
	  for (UserRole role : user.getRole())
	  {
			if (role.getRole() == Role.Admin)
			{
	%>
	<p>
		<jsp:include page="admin/main.jsp" />
		<%
		  }
				else if (role.getRole() == Role.Group)
				{
		%>
	
	<p>
		<jsp:include page="groups.jsp" />
		<%
		  }
		  }
		%>
	
</body>
</html>
