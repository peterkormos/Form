<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="org.msz.servlet.datatype.polls.*"%>
<%@page import="org.msz.util.WebUtils"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script type="text/javascript">
function addRow()
{
	document.getElementById('form1').rows.value = parseInt(document.getElementById('form1').rows.value) + 1;

	var mytable = document.getElementById('tableID');
	var newRow = mytable.insertRow(-1);
	newRow.insertCell(-1).innerHTML="N&eacute;v: ";
	newRow.insertCell(-1).innerHTML='<input name="<%=HTTPRequestParamNames.OPTION_NAME%>' + document.getElementById('form1').rows.value + '" type="text">';
	
	var pollClass = document.getElementById('pollClass').options[document.getElementById('pollClass').selectedIndex].value;
	if(pollClass == "org.msz.servlet.datatype.polls.CustomPoll")
	{
		newRow.insertCell(-1).innerHTML="T&iacute;pusa: <select name=\"<%=HTTPRequestParamNames.OPTION_TYPE%>"+document.getElementById('form1').rows.value+"\"> \
    <option value=\"<%=HTTPRequestParamNames.OPTION_TYPE_RADIO%>\" onClick=\"document.getElementById(\'div' + document.getElementById('form1').rows.value + '\').style.visibility = \'visible\'\">R&aacute;dio</option> \
    <option value=\"<%=HTTPRequestParamNames.OPTION_TYPE_CHECKBOX%>\" onClick=\"document.getElementById(\'div' + document.getElementById('form1').rows.value + '\').style.visibility = \'hidden\'\">Kipip&aacute;l&oacute;s</option> \
    <option value=\"<%=HTTPRequestParamNames.OPTION_TYPE_TEXT%>\" onClick=\"document.getElementById(\'div' + document.getElementById('form1').rows.value + '\').style.visibility = \'hidden\'\">Sz&ouml;vegmez&ocirc;</option> \
  </select>";

	newRow.insertCell(-1).innerHTML='<div id=\"div' + 
		document.getElementById('form1').rows.value + 
		'\">A lehet&ocirc;s&eacute;gek vessz&ocirc;vel elv&aacute;lasztva <input name="<%=HTTPRequestParamNames.OPTION_VALUE%>' + 
		document.getElementById('form1').rows.value + 
		'" type="text"><div>';
		}

	}
</script>




</head>
<body>
	<%
	  PollsServletDAO dao = PollsServletDAO.getInstance();
	  String pollID = WebUtils.getOptionalParameter(request, HTTPRequestParamNames.POLL_ID);

	  Poll poll = null;
	  if (pollID != null)
			poll = (Poll) dao.get(Integer.parseInt(pollID), Poll.class);
	%><form accept-charset="UTF-8" id="form1" action="../PollsServlet"
		method="post">
		<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
			id="commandID" value="<%=PollsServlet.Command.savePoll%>">
		<%
		  if (pollID != null)
				out.println("<input type='hidden' name='" + HTTPRequestParamNames.POLL_ID + "' value='" + pollID + "'>");
		%>
		<input type="hidden" name="rows" value="0">
		<table border="1" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr>
					<td>
						<table border="0" width="100%">
							<tbody>
								<tr>
									<td width="451">Szavaz&aacute;s c&iacute;me:</td>
									<td width="512"><input
										name="<%=HTTPRequestParamNames.POLL_TITLE%>"
										value="<%=poll == null ? "" : poll.title%>" type="text"
										size="50"></td>
								</tr>
								<tr bgcolor="#dddddd">
									<td>Szavaz&aacute;s le&iacute;r&aacute;sa:</td>
									<td><textarea
											name="<%=HTTPRequestParamNames.POLL_DESCRIPTION%>"
											value="<%=poll == null ? "" : poll.description%>" cols="50"></textarea>
									</td>
								</tr>
								<tr>
									<td>Hat&aacute;rid&otilde; (&Eacute;v-h&oacute;-nap):</td>
									<td><img src="../images/cal.gif" border="0"> <input
										name="<%=HTTPRequestParamNames.POLL_ENDDATE%>" type="date"
										id="endData" size="11"
										value="<%=poll == null ? "" : poll.endDate == Long.MAX_VALUE ? "" : WebUtils.convertToString(poll.endDate,
		  PollsServlet.DATE_PATTERN)%>">
										<input type="button" value="d&aacute;tum t&ouml;rl&eacute;se"
										onClick="document.getElementById('endData').value=''"></td>
								</tr>
								<tr bgcolor="#dddddd">
									<td>Szavaz&oacute; &uacute;jra szavazhat:</td>
									<td><input type="checkbox"
										name="<%=HTTPRequestParamNames.POLL_USER_CAN_RESUBMIT%>"
										<%=poll == null ? "" : poll.userCanResubmit ? "checked='checked'" : ""%>></td>
								</tr>
								<tr>
									<td>Szavaz&oacute; &uacute;jabb szavaz&aacute;si
										lehet&otilde;s&eacute;get hozz&aacute;adhat:</td>
									<td><input type="checkbox"
										name="<%=HTTPRequestParamNames.POLL_USER_CAN_ADD_ENTRY%>"
										<%=poll == null ? "" : poll.userCanAddEntry ? "checked='checked'" : ""%>></td>
								</tr>
								<tr bgcolor="#dddddd">
									<td>Szavaz&aacute;s t&iacute;pusa:</td>
									<td><select id="<%=HTTPRequestParamNames.POLL_CLASS%>"
										name="<%=HTTPRequestParamNames.POLL_CLASS%>" size="5">
											<option
												value="org.msz.servlet.datatype.polls.SingleDecisionPoll"
												<%=poll == null ? "selected" : poll instanceof SingleDecisionPoll ? "selected" : ""%>
												onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';">
												Sok lehet&ocirc;s&eacute;gb&ocirc;l egy
												kiv&aacute;laszt&aacute;sa</option>
											<option
												value="org.msz.servlet.datatype.polls.MultiDecisionPoll"
												<%=poll == null ? "" : poll instanceof MultiDecisionPoll ? "selected" : ""%>
												onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';">Sok
												lehet&ocirc;s&eacute;gb&ocirc;l t&ouml;bb
												kiv&aacute;laszt&aacute;sa</option>
											<option
												value="org.msz.servlet.datatype.polls.SplitPointsPoll"
												<%=poll == null ? "" : poll instanceof SplitPointsPoll ? "selected" : ""%>
												onClick="document.getElementById('units').style.visibility = 'visible';document.getElementById('maxAmount').style.visibility = 'visible';">Pontmennyis&eacute;g
												sz&eacute;toszt&aacute;sa</option>
											<option value="org.msz.servlet.datatype.polls.AwardingPoll"
												<%=poll == null ? "" : poll instanceof AwardingPoll ? "selected" : ""%>
												onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'visible';">1-x
												pontoz&aacute;s</option>
											<option value="org.msz.servlet.datatype.polls.OrderingPoll"
												<%=poll == null ? "" : poll instanceof OrderingPoll ? "selected" : ""%>
												onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';">Sorrendi
												szavaz&aacute;s</option>
											<option value="org.msz.servlet.datatype.polls.FormTypePoll"
												<%=poll == null ? "" : poll instanceof FormTypePoll ? "selected" : ""%>
												onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';">&Ucirc;rlap
												jelleg&ucirc; szavaz&aacute;s</option>
											<option value="org.msz.servlet.datatype.polls.CustomPoll"
												<%=poll == null ? "" : poll instanceof CustomPoll ? "selected" : ""%>
												onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';">Egyedi
												form&aacute;tum&uacute; szavaz&aacute;s</option>
									</select></td>
								</tr>
								<tr>
									<td>Nyilv&aacute;nos szavaz&aacute;s</td>
									<td><input type="checkbox"
										name="<%=HTTPRequestParamNames.PUBLIC_POLL%>"
										<%=poll == null ? "" : dao.getPublicPoll(poll.id) != null ? "checked='checked'" : ""%>></td>
								</tr>
								<tr style='visibility: hidden' id="units">

									<td>M&eacute;rt&eacute;kegys&eacute;g:</td>
									<td><input name="<%=HTTPRequestParamNames.UNITS%>"
										type="text"
										value="<%=poll == null ? "" : poll instanceof SplitPointsPoll ? ((SplitPointsPoll) poll).units : ""%>"></td>
								</tr>
								<tr bgcolor="#dddddd" style='visibility: hidden' id="maxAmount">

									<td>Sz&eacute;toszthat&oacute; Mennyis&eacute;g:</td>
									<td><input name="<%=HTTPRequestParamNames.MAX_AMOUNT%>"
										type="text"
										value="<%=poll == null ? "" : poll instanceof SplitPointsPoll ? ((SplitPointsPoll) poll).maxAmount
		  : poll instanceof AwardingPoll ? ((AwardingPoll) poll).maxAmount : ""%>"></td>
								</tr>
								<tr>
									<td>V&aacute;laszt&aacute;si lehet&otilde;s&eacute;gek:</td>
									<td>
										<table width="100%" border="1" cellspacing="0" cellpadding="0">
											<tr>
												<td>Az eddigi lehet&otilde;s&eacute;gek:<br> <%
   if (poll != null)
   {
 		for (PollOption option : poll.options)
 		{
 %> <%=option.name%> <input type="checkbox"
													name="<%=HTTPRequestParamNames.POLL_OPTION_ID%>"
													value="<%=option.id%>"> <input type="submit"
													value="T&ouml;rl&eacute;s"
													onClick="document.getElementById('commandID').value='<%=PollsServlet.Command.deletePollOption%>'">
													<br> <%
   }
   }
 %>
												</td>
											</tr>
											<tr>
												<td>
													<table border="0" id="tableID">
													</table>
													<p align="center">
														<input name="button" type="button" onClick="addRow()"
															value="&Uacute;j sor">
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr bgcolor="#99ffcc">
									<td colspan="2">
										<div align="center">
											<input name="submit" value="Ment&eacute;s" type="submit">
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</body>
</html>
