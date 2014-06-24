<%@ page import="org.msz.servlet.*"%>

<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.util.WebUtils"%>

<%
  MSZPollsServletDAO dao = new MSZPollsServletDAO("");

  int pollID = Integer.parseInt(WebUtils.getParameter(request,
      MSZPollsServlet.POLL_ID));

  Poll poll = (Poll)dao.get(pollID, Poll.class);
  
  List<Vote> votes = dao.getVotesForPoll(pollID);

  SortedMap<String, StatsEntry> stats = new TreeMap<String, StatsEntry>();

  for (Vote vote : votes)
  {
    for (VoteOption voteOption : vote.options)
    {
      String key = voteOption.name + " - " + voteOption.value;
      StatsEntry entry = stats.get(key);

      if (entry == null)
        entry = new StatsEntry(voteOption, 1);
      else
        entry.count++;

      stats.put(key, entry);
    }
  }

  int min = 0, max = 0, avg = 0;
  for (String key : stats.keySet())
  {
    StatsEntry entry = stats.get(key);
    if (min == 0)
      min = entry.count;

    if (entry.count < min)
      min = entry.count;

    if (entry.count > max)
      max = entry.count;

    avg += entry.count;
  }

  if (!stats.isEmpty())
    avg = avg / stats.size();

%>

<tr>
  <td>Eddigi szavazatok sz&aacute;ma:</td>
	<td><%=votes.size() %></td>
</tr>

<tr bgcolor="#DDDDDD">
	<td>Szavazati statisztika:</td>
	<td>
	<table width="100%" border="1">
		<tr>
			<td>

			
			<table width="100%" border="0">
				<tr>
					<th width="38%">
					<div align="left">Lehet&otilde;s&eacute;g</div>
					</th>
					<th width="100">
					<div align="left">V&aacute;lasz</div>
					</th>
					<th width="150">
					<div align="left">Szavaztok sz&aacute;ma</div>
					</th>
					<th width="180">
					<div align="left">Eloszl&aacute;s (
min: <img src='./resources/red.jpg' width='10' height='10'>
max: <img src='./resources/green.jpg' width='10' height='10'>
avg: <img src='./resources/grey.jpg' width='10' height='10'> ) 
					</div>
					</th>
				</tr>
				<%
				
				  for (String key : stats.keySet())
				  {
				    StatsEntry entry = stats.get(key);
				%>
				<tr>
					<td><%=entry.option.name%></td>
					<td><%=entry.option.value%></td>
					<td><%=entry.count%></td>
					<td>
					<%
					  if (min*1.1 >= entry.count)
					      out
					          .println("<img src='./resources/red.jpg' width='"+Math.max(1, (int)(entry.count*100/votes.size()))+"' height='10'>");

					    else if (max*0.9 <= entry.count)
					      out
					          .println("<img src='./resources/green.jpg' width='"+Math.max(1, (int)(entry.count*100/votes.size()))+"' height='10'>");

					    else if (avg*0.9 <= entry.count &&
					        avg*1.1 >= entry.count)
					      out
					          .println("<img src='./resources/grey.jpg' width='"+Math.max(1, (int)(entry.count*100/votes.size()))+"' height='10'>");
					%>
					</td>
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

<tr>
  <td>Szavazat specifikus statisztika:</td>
	<td>
	<%
  if(poll instanceof OrderingPoll)
  {
    Map<String, String> pollStats = ((OrderingPoll)poll).getPollSpecificStatistics(votes);
    
    %>
<table width="100%" border="1">
<%
    for(String key : pollStats.keySet())
    {
      %>
  <tr>
    <td><%= key %></td>
    <td><%= pollStats.get(key) %></td>
  </tr>
    <%
    }
%>
</table>
<%
  }
%>
</td>
</tr>
