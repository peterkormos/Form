<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>
<%@page import="org.msz.util.WebUtils"%>

<%
  PollsServletDAO dao = new PollsServletDAO(null);
  int userID = Integer.parseInt(WebUtils.getParameter(request,
      PollsServlet.USER_ID));
  User user = (User) dao.get(userID, User.class);
%>

<jsp:include page="inputUser.jsp" />
<hr>

<p><strong>Szavazati csoportok:</strong></p>
<ul>
	<%
	  for (PollGroup pollGroup : user.pollGroups)
	  {
	%>
	<li><%=pollGroup.groupName%></li>
	<%
	  }
	%>
</ul>

<p><strong>Saj&aacute;t szavaz&aacute;sok:</strong></p>
<ul>
	<%
	  for (Poll poll : user.ownedPolls)
	  {
	%>
	<li><%=poll.title%> <br>
	<%=poll.description%></li>
	<%
	  }
	%>
</ul>

<p><strong>Szavazatok:</strong></p>
	<%
	  for (Vote vote : dao.getVotesForUser(user.id))
	  {
	    Poll poll = (Poll) dao.get(vote.pollID, Poll.class);
	%>
	<br>
	<table width="100%" border="1">
		<tr>
			
        <td><%=poll.title%> <br>
			<%=poll.description%></td>
			
        <td> 
            <table width="100%" border="0">
                <tr>
                    <th>
                    <div align="left">Lehet&otilde;s&eacute;g</div>
                    </th>
                    <th>
                    <div align="left">V&aacute;lasz</div>
                    </th>
                </tr>
                <%
                  int cnt = 0;
                    for (VoteOption voteOption : vote.options)
                    {
                      String key = voteOption.name + " - " + voteOption.value;
                %>
                <tr <%=cnt %2 == 0 ? "" : "bgcolor='#DDDDDD'" %>>

                    <td><%=voteOption.name%></td>
                    <td><%=voteOption.value%></td>
                </tr>
                <%
                    cnt++;                  
                  }
                %>
            </table>
            </td>
        </tr>
    </table>



	<%
	  }
	%>
