<%@ page import="org.msz.servlet.*"%>

<%@include file="util.jsp"%>

<%
  highlightStart = 0xEAEAEA;
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>

<link rel="stylesheet" href="base.css" media="screen" />

<body>
	<table border="0" height="100%" width="100%">
		<tr>
			<td align="center" valign="middle">

				<form accept-charset="UTF-8" action="../PollsServlet" method="post">
					<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
						value="<%=PollsServlet.Command.login%>">

					<table border="0">
						<tr bgcolor="<%=highlight(request)%>">
							<td>Email c&iacute;m:</td>
							<td><input type="email"
								name="<%=HTTPRequestParamNames.USER_EMAIL_ADDRESS%>"></td>
						</tr>
						<tr bgcolor="<%=highlight(request)%>">
							<td>Jelsz&oacute;:</td>
							<td><input type="password"
								name="<%=HTTPRequestParamNames.USER_PASSWORD%>"></td>
						</tr>
						<tr>
							<td colspan="2"><div align="center">
									<p>
										<input type="submit" value="Bejelentkez&eacute;s">
									</p>
								</div></td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
	</table>
</body>
</html>

