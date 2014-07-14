<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>

<%@include file="../util.jsp"%>

<%
  highlightStart = 0xFFE000;
  PollsServletDAO dao = PollsServletDAO.getInstance();
%>

<table width="100%" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="350"><strong>Fel&uuml;gyelet</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr valign="top">
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Szavaz&aacute;s m&oacute;dos&iacute;t&aacute;sa:</td>
					<td>
						<form accept-charset="UTF-8" action="inputPoll.jsp" method="POST">
							Szavaz&aacute;s: <select
								name="<%=HTTPRequestParamNames.POLL_ID%>">
								<%
								  for (Record record : dao.getPolls())
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
					<td>Felhaszn&aacute;l&oacute; aktivit&aacute;s&aacute;nak
						lek&eacute;rdez&eacute;se:</td>
					<td>
						<form accept-charset="UTF-8" action="admin/userActivity.jsp"
							method="POST">
							<%=getAllUsersDropdown()%>
							<input type="button" onClick="this.parentNode.submit();"
								value="Megn&eacute;z">
						</form>
					</td>
				</tr>
				<tr valign="top" bgcolor="<%=highlight()%>">
					<td>Az &ouml;sszes felhaszn&aacute;l&oacute; ter&uuml;leti
						elrendez&eacute;se</td>
					<td><form accept-charset="UTF-8"
							action="admin/showUsersOnGoogleMap.jsp" method="POST">
							<input type="submit" value="Mutasd Google t&eacute;rk&eacute;pen">
						</form></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
