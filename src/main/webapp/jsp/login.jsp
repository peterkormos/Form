<%@ page import="org.msz.servlet.*"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>

<body>
<form accept-charset="UTF-8" action="../PollsServlet" method="post">
  <input type="hidden" name="<%=PollsServlet.COMMAND %>" value="<%=PollsServlet.COMMAND_LOGIN_USER %>">

  <table  border="0">
    <tr> 
      <td>Email c&iacute;m: </td>
      <td><input type="email" name="<%=PollsServlet.USER_EMAIL_ADDRESS %>"> </td>
    </tr>
    <tr> 
      <td>Jelsz&oacute;:</td>
      <td><input type="password" name="<%=PollsServlet.USER_PASSWORD %>"></td>
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
</body></html>

