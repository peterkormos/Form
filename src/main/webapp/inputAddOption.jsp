<%@page import="org.msz.servlet.*"%>

<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="org.msz.util.WebUtils"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script type="text/javascript">
function addRow()
{
	document.input.rows.value = parseInt(document.input.rows.value) + 1;

	var mytable = document.getElementById('tableID')
	var newRow = mytable.insertRow(-1);
	newRow.insertCell(-1).innerHTML="N&eacute;v: ";
	newRow.insertCell(-1).innerHTML='<input name="<%=MSZPollsServlet.OPTION_NAME %>'+document.input.rows.value+'" type="text">';
}

</script>

</head>
<body>
<form name="input" action="MSZPollsServlet" method="post"><input
	type="hidden" name="<%=MSZPollsServlet.COMMAND %>"
	value="<%=MSZPollsServlet.COMMAND_ADD_OPTION %>"> <input
	type="hidden" name="rows" value="0"> <%
     MSZPollsServletDAO dao = new MSZPollsServletDAO("");
     Poll poll = (Poll) dao.get(Integer.parseInt((String) session
 		    .getAttribute(MSZPollsServlet.POLL_ID)), Poll.class);
 %>

<table width="77%" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<td>
		<table width="100%" border="0">
			<tr>
				<td width="355">Szavaz&aacute;s c&iacute;me:</td>
				<td width="375"><%=poll.title%></td>
			</tr>
			<tr bgcolor="#DDDDDD">
				<td>Szavaz&aacute;s le&iacute;r&aacute;sa:</td>
				<td><%=poll.description%></td>
			</tr>
			<tr>
				<td>Hat&aacute;rid&otilde; (&Eacute;v-h&oacute;-nap):</td>
				<td><%=poll.endDate == Long.MAX_VALUE ? "-"
		    : WebUtils.convertToString(poll.endDate,
			    MSZPollsServlet.DATE_PATTERN)%></td>
			</tr>
			<tr bgcolor="#DDDDDD">
				<td>Szavaz&oacute; &uacute;jra szavazhat:</td>
				<td><%=poll.userCanResubmit ? "igen" : "nem"%></td>
			</tr>
			<tr>
				<td>Szavaz&oacute; &uacute;jabb szavaz&aacute;si
				lehet&otilde;s&eacute;get hozz&aacute;adhat:</td>
				<td><%=poll.userCanAddEntry ? "igen" : "nem"%></td>
			</tr>
			<%
			    if (poll instanceof SplitPointsPoll)
			    {
					SplitPointsPoll splitPointsPoll = (SplitPointsPoll) poll;
			%>
			<tr>
				<td>M&eacute;rt&eacute;kegys&eacute;g:</td>
				<td><%=splitPointsPoll.units%></td>
			</tr>
			<tr bgcolor="#DDDDDD">

				<td>Sz&eacute;toszthat&oacute; mennyis&eacute;g:</td>
				<td><%=splitPointsPoll.maxAmount%></td>
			</tr>
			<%
			    }
			%>
			<tr>
				<td>V&aacute;laszt&aacute;si lehet&otilde;s&eacute;gek:</td>
				<td>
				<table width="33%" border="1" cellspacing="0" cellpadding="0">
					<tr>

						<td>Az eddigi lehet&otilde;s&eacute;gek:<br> 
						<%
						    for (PollOption option : poll.options)
								out.print(option.name + "<br>");
						%>
						</td>
					</tr>
					<tr>
						<td>
						<table border="0" id="tableID">
						</table>
						<p align="center"><script type="text/javascript">
	document.input.rows.value = 0;
		addRow();
</script> <input name="button" type="button" onClick="addRow()"
							value="&Uacute;j sor">
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr bgcolor="#99FFCC">
				<td colspan="2">
				<div align="center"><input name="submit" type="submit"
					value="Ment&eacute;s"></div>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>

