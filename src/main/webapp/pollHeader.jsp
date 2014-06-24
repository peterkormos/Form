<%@ page import="org.msz.servlet.*"%>

<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.util.WebUtils"%>

<%@include file="util.jsp" %>

<%
  MSZPollsServletDAO dao = new MSZPollsServletDAO("");

  int pollID = Integer.parseInt(WebUtils.getParameter(request, MSZPollsServlet.POLL_ID));
  
  Poll poll = (Poll) dao.get(pollID, Poll.class);
%>

	<tr>
		<td>
		<table width="100%" border="0">
			<tr>
				<td >Szavaz&aacute;s c&iacute;me:</td>
				<td >
				<b><%=poll.title%></b>
				<br>
				<%=poll.description%>
				</td>
			</tr>
			<tr>
				<td>Hat&aacute;rid&otilde; (&Eacute;v-h&oacute;-nap):</td>
				<td><%=poll.endDate == Long.MAX_VALUE ? "-" : WebUtils
          .convertToString(poll.endDate, MSZPollsServlet.DATE_PATTERN)%></td>
			</tr>
			<tr bgcolor="#DDDDDD">
				<td>Regisztr&aacute;lt szavaz&oacute; &uacute;jra szavazhat:</td>
				<td><%=getYesNoImage(poll.userCanResubmit)%></td>
			</tr>
			<tr>
				<td>Regisztr&aacute;lt szavaz&oacute; &uacute;jabb lehet&otilde;s&eacute;get 
                    adhat a szavaz&aacute;shoz:</td>
				<td><%=getYesNoImage(poll.userCanAddEntry)%>
				</td>
			</tr>
            <tr bgcolor="#DDDDDD">
                <td>Nyilv&aacute;nos szavaz&aacute;s:</td>
                <td><%=getYesNoImage(dao.getPublicPoll(poll.id) != null)%>
                </td>
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

			<%
              try
              {
                int userID = Integer.parseInt((String) session
                    .getAttribute(MSZPollsServlet.USER_ID));
                Vote vote = dao.getVote(userID, poll.id);
            %>
            <tr>
                <td>Jelenlegi szavazata:</td>
                <td>
                <table width="100%" border="1">
                    <tr>
                        <td>
                        <table width="100%" border="0">
                            <tr>
                                <th width="50%">
                                <div align="left">Lehet&otilde;s&eacute;g</div>
                                </th>
                                <th width="50%">
                                <div align="left">V&aacute;lasz</div>
                                </th>
                            </tr>
                            <%
                              for (VoteOption option : vote.options)
                                {
                            %>
                            <tr>
                                <td><%=option.name%></td>
                                <td><%=getVoteValue(option)%></td>
                            </tr>
                            <%
                              }
                            %>
                        </table>
                        </td>
                    </tr>
                </table>
                </td>
            </tr>
            <%
              }
              catch (Exception e)
              {

              }
            %>