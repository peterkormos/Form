package org.msz.servlet.util;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.msz.datatype.Record;
import org.msz.servlet.datatype.Poll;
import org.msz.servlet.datatype.PollGroup;
import org.msz.servlet.datatype.PollOption;
import org.msz.servlet.datatype.PublicPoll;
import org.msz.servlet.datatype.User;
import org.msz.servlet.datatype.polls.SingleDecisionPoll;

public class testbed
{
  public final static String getYesNoImage(final boolean value)
  {
	return "<img src='./resources/" + (value ? "check" : "cross") + "mark.png'>";
  }

  public static void main(String[] args) throws Exception
  {
	System.out.println( 
	getYesNoImage(true));
	
	
//	PollsServletDAO dao = new PollsServletDAO(TestDAO.hibernateConfig);

	//	Poll poll = (Poll)dao.get(1, Poll.class);	
	//	System.out.println(poll.owner);
	//	dao.save(new PublicPoll(dao.getNextID(PublicPoll.class), poll));
	//	System.out.println(dao.get(1, PublicPoll.class));
	//	
	//	dao.deletePublicFlag(poll.id);

	//	User poll = (User)dao.get(1, User.class);	
	//	System.out.println(poll.ownedPolls);

	//	System.out.println(dao.isPublic(1));
	//	System.out.println(dao.isPublic(2));

	//	Set<PollOption> options = new HashSet<PollOption>();
	//	options.add(new PollOption(dao.getNextID(PollOption.class), "2", null, 2, "text"));
	//  Poll poll = new Poll(dao.getNextID(Poll.class), "2", "2", Long.MAX_VALUE, true, true, options , 1, 1);
	//  SingleDecisionPoll sdp = new SingleDecisionPoll(dao.getNextID(SingleDecisionPoll.class), poll, new PollGroup(1, "g1", null));

	//  User user = (User)dao.get(1, User.class);
	//  user.getOwnedPolls().remove(1);
	//  dao.update(user);

	//	dao.delete(2, SingleDecisionPoll.class);

	//	Collection<Record> users = (Collection<Record>) (null == null ? dao.getAll(User.class) :
	//	  dao.getUsersInGroup(1));

//	System.out.println(dao.get(2, User.class)
	//	    users
	//	    dao.getVote(1, 4)
	//	  dao.getPolls()
	//	  dao.getVotes(1)
	//	    dao.getUsersInGroup(1)
	//	    dao.get(1, PollGroup.class)
//	    );
  }
}
