<%@ page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>

<%
  MSZPollsServletDAO dao = new MSZPollsServletDAO("");
  int userID = Integer.parseInt((String) session
      .getAttribute(MSZPollsServlet.USER_ID));
  User user = (User) dao.get(userID, User.class);
%>
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
          <td>&Uacute;j szavaz&aacute;s</td>
          <td> <form accept-charset="UTF-8" action="inputPoll.jsp" method="POST">
              <input type="submit" value="&Uacute;j szavaz&aacute;s felvitele a rendszerbe">
            </form></tr>
      </table>
		</td>
	</tr>
</table>

<br>
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
        <tr valign="top"> 
          <td>Z&aacute;rt szavaz&aacute;shoz szavaz&oacute;-csoport l&eacute;trehoz&aacute;sa:</td>
          <td> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_SAVE_GROUP%>">
              Csoport: 
              <input
					type="text" name="<%=MSZPollsServlet.GROUP_NAME%>">
              <input
					type="button" onClick="this.parentNode.submit();"
					value="Csoport ment&eacute;se">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td bgcolor="#E0E0E0">Szavaz&oacute;-csoporthoz szavazat hozz&aacute;rendel&eacute;se:</td>
          <td bgcolor="#E0E0E0"> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_ADD_POLL_TO_GROUP%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="23%">Csoport:</td>
                  <td width="77%"><select
							name="<%=MSZPollsServlet.POLL_GROUP_ID%>">
                      <%
							  for (PollGroup pollGroup : user.getPollGroups())
							    out.println("<option value='" + pollGroup.id + "'>"
							        + pollGroup.groupName + " </option>");
							%>
                    </select></td>
                </tr>
                <tr> 
                  <td width="23%">Szavaz&aacute;s:</td>
                  <td width="77%"><select name="<%=MSZPollsServlet.POLL_ID%>">
                      <%
							  for (Record record : user.getOwnedPolls())
							  {
							    Poll poll = (Poll) record;

							    out.println("<option value='" + poll.id + "'>" + poll.title
							        + " </option>");
							  }
							%>
                    </select> </td>
                </tr>
              </table>
<input type="button" onClick="this.parentNode.submit();"
					value="Ment&eacute;s">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td>Szavaz&oacute;-csoporthoz emberekek hozz&aacute;rendel&eacute;se:</td>
          <td> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_ADD_USER_TO_GROUP%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="23%">Csoport:</td>
                  <td width="77%"><select
							name="<%=MSZPollsServlet.POLL_GROUP_ID%>">
                      <%
							  for (PollGroup pollGroup : user.getPollGroups())
							    out.println("<option value='" + pollGroup.id + "'>"
							        + pollGroup.groupName + " </option>");
							%>
                    </select></td>
                </tr>
                <tr> 
                  <td valign="top">Szavaz&oacute;k email c&iacute;me<br>
                    (vessz&otilde;vel elv&aacute;lasztva):</td>
                  <td><textarea name="<%=MSZPollsServlet.SUBSCRIBE_USER_ID%>"
							cols="50"></textarea></td>
                </tr>
              </table>
               <input type="button" onClick="this.parentNode.submit();"
					value="Megh&iacute;vottak hozz&aacute;rendel&eacute;se">
            </form></td>
        </tr>
        <tr valign="top">
          <td bgcolor="#E0E0E0">Eddig a szavaz&oacute;-csoporthoz rendelt emberek:</td>
          <td bgcolor="#E0E0E0"><form accept-charset="UTF-8" action="usersInGroup.jsp" method="POST">
              Szavaz&oacute;-csoport: 
             <select
							name="<%=MSZPollsServlet.POLL_GROUP_ID%>">
                      <%
							  for (PollGroup pollGroup : user.getPollGroups())
							    out.println("<option value='" + pollGroup.id + "'>"
							        + pollGroup.groupName + " </option>");
							%>
                    </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="Megn&eacute;z"></form></td>
        </tr>
        <tr valign="top"> 
          <td bgcolor="#E0E0E0">Z&aacute;rt szavaz&aacute;sn&aacute;l email &eacute;rtes&iacute;t&otilde; 
            kik&uuml;ld&eacute;se a szavaz&oacute;knak</td>
          <td bgcolor="#E0E0E0"> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_SEND_EMAILS_TO_GROUP%>">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  for (Record record : dao.getPollsFromGroups(user.getPollGroups()))
					  {
					    Poll poll = (Poll) record;

					    out.println("<option value='" + poll.id
					        + "' onclick=\"this.parentNode.submit();"
					        + MSZPollsServlet.COMMAND_SEND_EMAILS_TO_GROUP + "' )\">" + poll.title
					        + "</option>");
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="Email-ek elk&uuml;ld&eacute;se">
            </form></td>
        </tr>
      </table>
		</td>
	</tr>
</table>
