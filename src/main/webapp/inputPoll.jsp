<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="org.msz.util.WebUtils"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script language="javascript" type="text/javascript"
	src="./resources/datetimepicker.js">
//Date Time Picker script- by TengYong Ng of http://www.rainforestnet.com
//Script featured on JavaScript Kit (http://www.javascriptkit.com)
//For this script, visit http://www.javascriptkit.com
</script>
<script type="text/javascript">
function addRow()
{
	document.getElementById('form1').rows.value = parseInt(document.getElementById('form1').rows.value) + 1;

	var mytable = document.getElementById('tableID');
	var newRow = mytable.insertRow(-1);
	newRow.insertCell(-1).innerHTML="N&eacute;v: ";
	newRow.insertCell(-1).innerHTML='<input name="<%=MSZPollsServlet.OPTION_NAME%>' + document.getElementById('form1').rows.value + '" type="text">';
	
	var pollClass = document.getElementById('pollClass').options[document.getElementById('pollClass').selectedIndex].value;
	if(pollClass == "org.msz.servlet.datatype.CustomPoll")
	{
		newRow.insertCell(-1).innerHTML="T&iacute;pusa: <select name=\"<%=MSZPollsServlet.OPTION_TYPE%>"+document.getElementById('form1').rows.value+"\"> \
    <option value=\"<%=MSZPollsServlet.OPTION_TYPE_RADIO%>\" onClick=\"document.getElementById(\'div' + document.getElementById('form1').rows.value + '\').style.visibility = \'visible\'\">R&aacute;dio</option> \
    <option value=\"<%=MSZPollsServlet.OPTION_TYPE_CHECKBOX%>\" onClick=\"document.getElementById(\'div' + document.getElementById('form1').rows.value + '\').style.visibility = \'hidden\'\">Kipip&aacute;l&oacute;s</option> \
    <option value=\"<%=MSZPollsServlet.OPTION_TYPE_TEXT%>\" onClick=\"document.getElementById(\'div' + document.getElementById('form1').rows.value + '\').style.visibility = \'hidden\'\">Sz&ouml;vegmez&ocirc;</option> \
  </select>";

	newRow.insertCell(-1).innerHTML='<div id=\"div' + document.getElementById('form1').rows.value + '\">A lehet&ocirc;s&eacute;gek vessz&ocirc;vel elv&aacute;lasztva <input name="<%=MSZPollsServlet.OPTION_VALUE%>' + document.getElementById('form1').rows.value + '" type="text"><div>';
	}
	
	}
</script>




</head>
<body>
<%
  MSZPollsServletDAO dao = new MSZPollsServletDAO("");
  String pollID = WebUtils.getOptionalParameter(request,
      MSZPollsServlet.POLL_ID);

  Poll poll = null;
  if (pollID != null)
    poll = (Poll) dao.get(Integer.parseInt(pollID), Poll.class);
%><form accept-charset="UTF-8" id="form1" action="MSZPollsServlet"
	method="post">
<input type="hidden"
	name="<%=MSZPollsServlet.COMMAND%>"
id="commandID"
	value="<%=MSZPollsServlet.COMMAND_SAVE_POLL%>"> <%
   if (pollID != null)
     out.println("<input type='hidden' name='" + MSZPollsServlet.POLL_ID
         + "' value='" + pollID + "'>");
 %> <input type="hidden" name="rows" value="0">
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tbody>
		<tr>
			<td>
			<table border="0" width="100%">
				<tbody>
					<tr>
						<td width="451">Szavazás címe:</td>
						<td width="512"><input name="<%=MSZPollsServlet.POLL_TITLE%>"
							value="<%=poll == null ? "" : poll.title%>" type="text" size="50"></td>
					</tr>
					<tr bgcolor="#dddddd">
						<td>Szavazás leírása:</td>
						<td><textarea name="<%=MSZPollsServlet.POLL_DESCRIPTION%>"
							value="<%=poll == null ? "" : poll.description%>" cols="50"></textarea>
						</td>
					</tr>
					<tr>
						<td>Határidõ (Év-hó-nap):</td>
						<td><a href="javascript:NewCal('endData','YYYYMMDD')"> <img
							src="./resources/cal.gif" border="0"></a> <input
							name="<%=MSZPollsServlet.POLL_ENDDATE%>" type="date" id="endData"
							readonly="readonly" size="11"
							value="<%=poll == null ? "" : poll.endDate == Long.MAX_VALUE ? ""
          : WebUtils
              .convertToString(poll.endDate, MSZPollsServlet.DATE_PATTERN)%>">
						<input type="button" value="dátum törlése"
							onClick="document.getElementById('endData').value=''"></td>
					</tr>
					<tr bgcolor="#dddddd">
						<td>Szavazó újra szavazhat:</td>
						<td><input type="checkbox"
							name="<%=MSZPollsServlet.POLL_USER_CAN_RESUBMIT%>"
							<%=poll == null ? ""
          : poll.userCanResubmit ? "checked='checked'" : ""%>></td>
					</tr>
					<tr>
						<td>Szavazó újabb szavazási lehetõséget hozzáadhat:</td>
						<td><input type="checkbox"
							name="<%=MSZPollsServlet.POLL_USER_CAN_ADD_ENTRY%>"
							<%=poll == null ? ""
          : poll.userCanAddEntry ? "checked='checked'" : ""%>></td>
					</tr>
					<tr bgcolor="#dddddd">
						<td>Szavazás típusa:</td>
						<td><select id="<%=MSZPollsServlet.POLL_CLASS%>"
							name="<%=MSZPollsServlet.POLL_CLASS%>" size="5">
							<option value="org.msz.servlet.datatype.SingleDecisionPoll"
								<%=poll == null ? "selected"
          : poll instanceof SingleDecisionPoll ? "selected" : ""%>
		  onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';"
		  >
							Sok lehet&ocirc;s&eacute;gb&ocirc;l egy
							kiv&aacute;laszt&aacute;sa</option>
							<option value="org.msz.servlet.datatype.MultiDecisionPoll"
								<%=poll == null ? ""
          : poll instanceof MultiDecisionPoll ? "selected" : ""%>
		  onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';"
		  >Sok
							lehet&ocirc;s&eacute;gb&ocirc;l t&ouml;bb
							kiv&aacute;laszt&aacute;sa</option>
							<option value="org.msz.servlet.datatype.SplitPointsPoll"
								<%=poll == null ? ""
          : poll instanceof SplitPointsPoll ? "selected" : ""%>
		  onClick="document.getElementById('units').style.visibility = 'visible';document.getElementById('maxAmount').style.visibility = 'visible';"
		  >Pontmennyis&eacute;g
							sz&eacute;toszt&aacute;sa</option>
							<option value="org.msz.servlet.datatype.AwardingPoll"
								<%=poll == null ? ""
          : poll instanceof AwardingPoll ? "selected" : ""%>
		  onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'visible';"
		  >1-x
							pontoz&aacute;s</option>
							<option value="org.msz.servlet.datatype.OrderingPoll"
								<%=poll == null ? ""
          : poll instanceof OrderingPoll ? "selected" : ""%>
		  onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';"
		  >Sorrendi
							szavaz&aacute;s</option>
							<option value="org.msz.servlet.datatype.FormTypePoll"
								<%=poll == null ? ""
          : poll instanceof FormTypePoll ? "selected" : ""%>
		  onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';"
		  >&Ucirc;rlap
							jelleg&ucirc; szavaz&aacute;s</option>
							<option value="org.msz.servlet.datatype.CustomPoll"
								<%=poll == null ? ""
          : poll instanceof CustomPoll ? "selected" : ""%>
		  onClick="document.getElementById('units').style.visibility = 'hidden';document.getElementById('maxAmount').style.visibility = 'hidden';"
		  >Egyedi
							form&aacute;tum&uacute; szavaz&aacute;s</option>
						</select></td>
					</tr>
					<tr>
						<td>Nyilvános szavazás</td>
						<td><input type="checkbox"
							name="<%=MSZPollsServlet.PUBLIC_POLL%>"
							<%=poll == null ? ""
          : dao.getPublicPoll(poll.id) != null ? "checked='checked'" : ""%>></td>
					</tr>
					<tr style='visibility:hidden' id="units">
						
                <td>Mértékegység:</td>
						<td><input name="<%=MSZPollsServlet.UNITS%>" type="text"
							value="<%=poll == null ? ""
          : poll instanceof SplitPointsPoll ? ((SplitPointsPoll) poll).units
              : ""%>"></td>
					</tr>
					<tr bgcolor="#dddddd" style='visibility:hidden'  id="maxAmount">
						
                <td>Szétosztható Mennyiség:</td>
						<td><input name="<%=MSZPollsServlet.MAX_AMOUNT%>" type="text"
							value="<%=poll == null ? ""
              : poll instanceof SplitPointsPoll ? ((SplitPointsPoll) poll).maxAmount
                  : poll instanceof AwardingPoll ? ((AwardingPoll) poll).maxAmount
                      : ""%>"></td>
					</tr>
					<tr>
						<td>Választási lehetõségek:</td>
						<td>
						<table width="100%" border="1" cellspacing="0" cellpadding="0">
							<tr>
								<td>Az eddigi lehet&otilde;s&eacute;gek:<br>
								<%
								  if (poll != null)
								  {
								    for (PollOption option : poll.options)
								    {
								%> <%=option.name%> <input type="checkbox"
									name="<%=MSZPollsServlet.POLL_OPTION_ID%>"
									value="<%=option.id%>">
<input type="submit" value="T&ouml;rl&eacute;s" onClick="document.getElementById('commandID').value='<%=MSZPollsServlet.COMMAND_DELETE_POLL_OPTION %>'">
 <br>
								<%
								  }
								  }
								%>
								</td>
							</tr>
							<tr>
								<td>
								<table border="0" id="tableID">
								</table>
								<p align="center"><input name="button" type="button"
									onClick="addRow()" value="&Uacute;j sor">
								</td>
							</tr>
						</table>
						</td>
					</tr>
					<tr bgcolor="#99ffcc">
						<td colspan="2">
						<div align="center"><input name="submit" value="Mentés"
							type="submit"></div>
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
