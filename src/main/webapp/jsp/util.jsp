<%!
public final String getYesNoImage(final boolean value)
{
	if(value)
		return "<img src='./images/checkmark.png' alt='igen'>";
	else 
		return "<img src='./images/crossmark.png' alt='nem'>";
}

public final String getVoteValue(final VoteOption vote)
{
	if("igen".equals(vote.value))
		return "<img src='./images/checkmark.png' alt='igen'>";
	else if("nem".equals(vote.value))
		return "<img src='./images/crossmark.png' alt='nem'>";
	else
		return vote.value;
}
%>