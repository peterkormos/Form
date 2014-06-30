<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>

<%
  PollsServletDAO dao = new PollsServletDAO(null);
  int userID = Integer.parseInt((String) session
      .getAttribute(PollsServlet.USER_ID));
  User user = (User) dao.get(userID, User.class);
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
        <tr valign="top" bgcolor="#FFCC00"> 
          <td>Felhaszn&aacute;l&oacute; aktivit&aacute;s&aacute;nak lek&eacute;rdez&eacute;se:</td>
          <td> <form accept-charset="UTF-8" action="userActivity.jsp" method="POST">
              Felhaszn&aacute;l&oacute;: 
              <select
					name="<%=PollsServlet.USER_ID%>">
                <%
					  List<Record> list = new LinkedList<Record>(dao.getAll(User.class));
					  Collections.sort(list, new Comparator<Record>()
					  {
					    public int compare(Record arg0, Record arg1)
					    {
					      return ((User) arg0).emailAddress
					          .compareTo(((User) arg1).emailAddress);
					    }
					  });

					  for (Record record : list)
					  {
					    User selectedUser = (User) record;
					%>
                <option value="<%=selectedUser.id%>"
						onclick="this.parentNode.submit();"><%=selectedUser.emailAddress%></option>
                <%
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="Megn&eacute;z">
            </form></td>
        </tr>
        <tr valign="top" bgcolor="#D2A800"> 
          <td>Az &ouml;sszes felhaszn&aacute;l&oacute; ter&uuml;leti elrendez&eacute;se</td>
          <td><form accept-charset="UTF-8" action="showUsersOnGoogleMap.jsp" method="POST">
              <input type="submit" value="Mutasd Google t&eacute;rk&eacute;pen">
            </form></td>
        </tr>
      </table>
		</td>
	</tr>
</table>
