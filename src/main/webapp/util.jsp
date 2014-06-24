<%!
public final String getYesNoImage(final boolean value)
{
	if(value)
		return "<img src='./resources/checkmark.png' alt='igen'>";
	else 
		return "<img src='./resources/crossmark.png' alt='nem'>";
}

public final String getVoteValue(final VoteOption vote)
{
	if("igen".equals(vote.value))
		return "<img src='./resources/checkmark.png' alt='igen'>";
	else if("nem".equals(vote.value))
		return "<img src='./resources/crossmark.png' alt='nem'>";
	else
		return vote.value;
}
%>