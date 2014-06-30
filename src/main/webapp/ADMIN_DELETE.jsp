<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>

<%
  MSZPollsServletDAO dao = new MSZPollsServletDAO(null);
  int userID = Integer.parseInt((String) session
      .getAttribute(MSZPollsServlet.USER_ID));
  User user = (User) dao.get(userID, User.class);
  
  List<Record> allUsers = new LinkedList<Record>(dao.getAll(User.class));
  Collections.sort(allUsers, new Comparator<Record>()
  {
    public int compare(Record arg0, Record arg1)
    {
      return ((User)arg0).emailAddress.compareTo(((User)arg1).emailAddress);
    }
  });
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
        <tr valign="top"> 
          <td bgcolor="#FFBFBF">Szavaz&aacute;s t&ouml;rl&eacute;se:</td>
          <td bgcolor="#FFBFBF"> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_DELETE_POLL%>">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  for (Poll poll : user.getOwnedPolls())
					  {
					%>
                <option value="<%=poll.id%>" onclick="this.parentNode.submit();"> 
                <%=poll.title%></option>
                <%
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="T&ouml;rl&eacute;s">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td bgcolor="#FF9797">Szavaz&aacute;s hozz&aacute;m rendel&eacute;se:</td>
          <td bgcolor="#FF9797"> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_ASSIGN_POLL%>">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
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
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="hozz&aacute;m rendel&eacute;s">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td bgcolor="#FFBFBF">Saj&aacute;t szavazat t&ouml;rl&eacute;se:</td>
          <td bgcolor="#FFBFBF"> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_DELETE_VOTE%>">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  for (Poll poll : user.getOwnedPolls())
					  {
					%>
                <option value="<%=poll.id%>" onclick="this.parentNode.submit();"> 
                <%=poll.title%></option>
                <%
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="T&ouml;rl&eacute;s">
            </form></td>
        </tr>
        <tr valign="top">
          <td bgcolor="#FF9797">M&aacute;s szavaz&aacute;s&aacute;nak t&ouml;rl&eacute;se</td>
          <td bgcolor="#FF9797"><form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_DELETE_VOTE%>">
					Felhaszn&aacute;l&oacute;: 
              <select
					name="<%=MSZPollsServlet.DELETED_USER_ID%>">
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
              </select>
			  
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  for (Poll poll : user.getOwnedPolls())
					  {
					%>
                <option value="<%=poll.id%>" onclick="this.parentNode.submit();"> 
                <%=poll.title%></option>
                <%
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="T&ouml;rl&eacute;s">
            </form></td>
        </tr>
        <tr valign="top" bgcolor="#FFBFBF"> 
          <td>Felhaszn&aacute;l&oacute; t&ouml;rl&eacute;se:</td>
          <td> 
            <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_DELETE_USER%>">
              Felhaszn&aacute;l&oacute;: 
              <select
					name="<%=MSZPollsServlet.DELETED_USER_ID%>">
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
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="T&ouml;rl&eacute;s">
            </form></td>
        </tr>
      </table>
		</td>
	</tr>
</table>
