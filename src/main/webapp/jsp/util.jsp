<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.util.*"%>
<%@page import="java.util.*"%>

<%!public final String getYesNoImage(final boolean value)
  {
	if (value)
	  return "<img src='../images/checkmark.png' alt='igen'>";
	else
	  return "<img src='../images/crossmark.png' alt='nem'>";
  }

  public final String getVoteValue(final VoteOption vote)
  {
	if ("igen".equals(vote.value))
	  return "<img src='../images/checkmark.png' alt='igen'>";
	else if ("nem".equals(vote.value))
	  return "<img src='../images/crossmark.png' alt='nem'>";
	else
	  return vote.value;
  }

  boolean highlightFlag;
  long highlightStart;

  public final String highlight()
  {
	try
	{
	  if (highlightFlag)
		return Long.toHexString(highlightStart);
	  else
	  {
		return Long.toHexString(Math.min(highlightStart + 0x111111, 0xffffff));
	  }
	}
	finally
	{
	  highlightFlag = !highlightFlag;
	}
  }

  public final List<Record> getAllUsers() throws Exception
  {
	List<Record> allUsers = new LinkedList<Record>(PollsServletDAO.getInstance().getAll(User.class));
	Collections.sort(allUsers, new Comparator<Record>()
	{
	  public int compare(Record arg0, Record arg1)
	  {
		return ((User) arg0).emailAddress.compareTo(((User) arg1).emailAddress);
	  }
	});
	
	return allUsers;
  }

  public final String getAllUsersDropdown() throws Exception
  {
	StringBuilder returned = new StringBuilder();

	returned.append("Felhaszn&aacute;l&oacute;:\n");
	returned.append("<select name='" + HTTPRequestParamNames.USER_ID + "'>\n");

	for (Record record : getAllUsers())
	{
	  User selectedUser = (User) record;
	  returned.append("<option value='" + selectedUser.id + "' onclick='this.parentNode.submit();'>" + selectedUser.emailAddress
		  + "</option>");
	}
	returned.append("</select>\n");

	return returned.toString();
  }%>