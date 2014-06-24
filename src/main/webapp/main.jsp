<%@ page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>

<%@page import="java.io.File"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript">
function sendSubmit(currentNode, command) 
{
    currentNode.getElementsByTagName("input")[0].value = command;
    currentNode.submit();
}
</script>
</head>
<body>
<%
  MSZPollsServletDAO dao = new MSZPollsServletDAO("");
  int userID = Integer.parseInt((String) session
      .getAttribute(MSZPollsServlet.USER_ID));
  User user = (User) dao.get(userID, User.class);
%>
<form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
<input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
	value="<%=MSZPollsServlet.COMMAND_LOGOUT%>"> Bejelentkezett
felhaszn&aacute;l&oacute;: <%=user.emailAddress%> - <a
	href="inputUser.jsp">Felhaszn&aacute;l&oacute;i adatok
m&oacute;dos&iacute;t&aacute;sa</a> - <input type="submit"
	value="Kijelentkez&eacute;s"></form>

<p>
<%
  String message = (String) session
      .getAttribute(MSZPollsServlet.MESSAGE_IN_HTTPSESSION);

  if (message != null)
  {
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td bgcolor="#CCFFCC">
		<%
		  out.println(message);
		    session.removeAttribute(MSZPollsServlet.MESSAGE_IN_HTTPSESSION);
		%>
		</td>
	</tr>
</table>
<%
  }

  Object[] allVisiblePolls =
  { user.getOwnedPolls(), dao.getPollsFromGroups(user.getPollGroups()),
      dao.getAll(PublicPoll.class) };

  String[] labels =
  { "Saj&aacute;t szavaz&aacute;saim", "Z&aacute;rt szavaz&aacute;sok",
      "Nyilv&aacute;nos szavaz&aacute;sok" };
%>
<br>
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
          <td>&Uacute;j szavaz&aacute;s:</td>
          <td> <form accept-charset="UTF-8" action="inputPoll.jsp" method="POST">
              <input type="submit" value="&Uacute;j szavaz&aacute;s felvitele a rendszerbe">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td bgcolor="#E0E0E0">Szavaz&aacute;s:</td>
          <td bgcolor="#E0E0E0"> <form accept-charset="UTF-8" action="inputVote.jsp" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  for (int i = 0; i < allVisiblePolls.length; i++)
					  {
					%>
                <optgroup label='<%=labels[i]%>'> 
                <%
						  for (Record record : (Set<Record>) allVisiblePolls[i])
						    {
						      Poll poll = record instanceof Poll ? (Poll) record
						          : ((PublicPoll) record).poll;

						      Vote vote = null;
						      try
						      {
						        vote = dao.getVote(userID, poll.id);

						        if (vote != null && !poll.userCanResubmit)
						          continue;
						      }
						      catch (Exception ex)
						      {

						      }
						%>
                <option value="<%=poll.id%>" onclick="this.parentNode.submit();"> 
                <%=poll.title + (vote != null ? " - VAN SZAVAZATA" : "")%>
                </option>
                <%
						  }
						%>
                </optgroup>
                <%
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="Ugr&aacute;s a szavaz&aacute;sra">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td>Szavaz&aacute;s m&oacute;dos&iacute;t&aacute;sa:</td>
          <td> <form accept-charset="UTF-8" action="inputPoll.jsp" method="POST">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  for (Record record : user.getOwnedPolls())
					  {
					    Poll poll = (Poll) record;

					    out.println("<option value='" + poll.id
					        + "' onclick=\"this.parentNode.submit();\">" + poll.title
					        + "</option>");
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="Megn&eacute;z">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td bgcolor="#E0E0E0">Szavaz&aacute;s eredm&eacute;nye:</td>
          <td bgcolor="#E0E0E0"> <form accept-charset="UTF-8" action="statistics.jsp" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  Set<Record> votedPolls = new HashSet<Record>();
					  votedPolls.addAll(user.getOwnedPolls());
					  votedPolls.addAll(dao.getPollsFromGroups(user.getPollGroups()));
					  votedPolls.addAll(dao.getAll(PublicPoll.class));

					  for (Record record : votedPolls)
					  {
					    Poll poll = record instanceof Poll ? (Poll) record
					        : ((PublicPoll) record).poll;

					    out.println("<option value='" + poll.id
					        + "' onclick=\"this.parentNode.submit();\">" + poll.title
					        + " </option>");
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="Ugr&aacute;s a szavaz&aacute;sra">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td>Email értesítő kérése ha v&aacute;lasz &eacute;rkezik:</td>
          <td> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_SUBSCRIBE_TO_POLL%>">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  for (int i = 0; i < allVisiblePolls.length; i++)
					  {
					%>
                <optgroup label='<%=labels[i]%>'> 
                <%
						  for (Record record : (Set<Record>) allVisiblePolls[i])
						    {
						      Poll poll = record instanceof Poll ? (Poll) record
						          : ((PublicPoll) record).poll;

						      Vote vote = null;
						      try
						      {
						        vote = dao.getVote(userID, poll.id);

						        if (vote != null && !poll.userCanResubmit)
						          continue;
						      }
						      catch (Exception ex)
						      {

						      }
						%>
                <option value="<%=poll.id%>" onclick="this.parentNode.submit();"> 
                <%=poll.title + (vote != null ? " - VAN SZAVAZATA" : "")%>
                </option>
                <%
						  }
						%>
                </optgroup>
                <%
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="Feliratkozás">
            </form></td>
        </tr>
        <tr valign="top"> 
          <td>Leiratkozás az email értesítőről:</td>
          <td> <form accept-charset="UTF-8" action="MSZPollsServlet" method="POST">
              <input type="hidden" name="<%=MSZPollsServlet.COMMAND%>"
					value="<%=MSZPollsServlet.COMMAND_UNSUBSCRIBE_FROM_POLL%>">
              Szavaz&aacute;s: 
              <select name="<%=MSZPollsServlet.POLL_ID%>">
                <%
					  for (Subscription subscription : dao.getSubscriptionsForUser(userID))
					  {
					    Poll poll = (Poll) dao.get(subscription.pollID, Poll.class);
					%>
                <option value="<%=poll.id%>" onclick="this.parentNode.submit();"> 
                <%=poll.title%>
                </option>
                <%
					  }
					%>
              </select>
              <input type="button" onClick="this.parentNode.submit();"
					value="Feliratkozás">
            </form></td>
        </tr>
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

<%
  for (PollGroup group : user.getPollGroups())
  {
    String file = config.getServletContext().getRealPath("")
        + File.separator + group.groupName + ".jsp";

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

</body>
</html>
