<%@ page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
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

<p>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="350"><strong>Z&aacute;rt szavaz&aacute;sok</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr valign="top">
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Z&aacute;rt szavaz&aacute;shoz szavaz&oacute;-csoport
						l&eacute;trehoz&aacute;sa:</td>
					<td>
						<form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.saveGroup%>"> Csoport: <input
								type="text" name="<%=HTTPRequestParamNames.GROUP_NAME%>"> <input
								type="button" onClick="this.parentNode.submit();"
								value="Csoport ment&eacute;se">
						</form>
					</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Szavaz&oacute;-csoporthoz szavazat
						hozz&aacute;rendel&eacute;se:</td>
					<td>
						<form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.addPollToGroup%>">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="23%">Csoport:</td>
									<td width="77%"><select
										name="<%=HTTPRequestParamNames.POLL_GROUP_ID%>">
											<%
											  for (PollGroup pollGroup : user.getPollGroups())
													out.println("<option value='" + pollGroup.id + "'>" + pollGroup.groupName + " </option>");
											%>
									</select></td>
								</tr>
								<tr>
									<td width="23%">Szavaz&aacute;s:</td>
									<td width="77%"><select name="<%=HTTPRequestParamNames.POLL_ID%>">

											<%
											  for (Record record : user.getOwnedPolls())
											  {
													Poll poll = (Poll) record;

													out.println("<option value='" + poll.id + "'>" + poll.title + " </option>");
											  }
											%>
									</select></td>
								</tr>
							</table>
							<input type="button" onClick="this.parentNode.submit();"
								value="Ment&eacute;s">
						</form>
					</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Szavaz&oacute;-csoporthoz emberekek
						hozz&aacute;rendel&eacute;se:</td>
					<td>
						<form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.addUserToGroup%>">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="23%">Csoport:</td>
									<td width="77%"><select
										name="<%=HTTPRequestParamNames.POLL_GROUP_ID%>">
											<%
											  for (PollGroup pollGroup : user.getPollGroups())
													out.println("<option value='" + pollGroup.id + "'>" + pollGroup.groupName + " </option>");
											%>
									</select></td>
								</tr>
								<tr>
									<td valign="top">Szavaz&oacute;k email c&iacute;me<br>
										(vessz&otilde;vel elv&aacute;lasztva):
									</td>
									<td><textarea name="<%=HTTPRequestParamNames.SUBSCRIBE_USER_ID%>"
											cols="50"></textarea></td>
								</tr>
							</table>
							<input type="button" onClick="this.parentNode.submit();"
								value="Megh&iacute;vottak hozz&aacute;rendel&eacute;se">
						</form>
					</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Eddig a szavaz&oacute;-csoporthoz rendelt emberek:</td>
					<td><form accept-charset="UTF-8" action="usersInGroup.jsp"
							method="POST">
							Szavaz&oacute;-csoport: <select
								name="<%=HTTPRequestParamNames.POLL_GROUP_ID%>">
								<%
								  for (PollGroup pollGroup : user.getPollGroups())
										out.println("<option value='" + pollGroup.id + "'>" + pollGroup.groupName + " </option>");
								%>
							</select> <input type="button" onClick="this.parentNode.submit();"
								value="Megn&eacute;z">
						</form></td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Z&aacute;rt szavaz&aacute;sn&aacute;l email
						&eacute;rtes&iacute;t&otilde; kik&uuml;ld&eacute;se a
						szavaz&oacute;knak</td>
					<td>
						<form accept-charset="UTF-8" action="../PollsServlet"
							method="POST">
							<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
								value="<%=PollsServlet.Command.sendEmails%>">
							Szavaz&aacute;s: <select name="<%=HTTPRequestParamNames.POLL_ID%>">
								<%
								  for (Record record : dao.getPollsFromGroups(user.getPollGroups()))
								  {
										Poll poll = (Poll) record;

										out.println("<option value='" + poll.id + "' onclick=\"this.parentNode.submit();"
										    + PollsServlet.Command.sendEmails + "' )\">" + poll.title + "</option>");
								  }
								%>
							</select> <input type="button" onClick="this.parentNode.submit();"
								value="Email-ek elk&uuml;ld&eacute;se">
						</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<%
  for (PollGroup group : user.getPollGroups())
  {
		String file = config.getServletContext().getRealPath("") + File.separator + group.groupName + ".jsp";

		//out.println(file + "<br>");

		if (new File(file).exists())
		{
		  String jspFile = group.groupName + ".jsp";
%>
<br>
<jsp:include page="<%=jspFile%>" />
<%
  }
  }
%>