package org.msz.servlet.util;

import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.persistence.OrderColumn;

import junit.framework.*;

import org.apache.log4j.Logger;
import org.junit.Ignore;
import org.msz.servlet.datatype.PollGroup;
import org.msz.servlet.datatype.PollOption;
import org.msz.servlet.datatype.Poll;
import org.msz.servlet.datatype.User;
import org.msz.servlet.datatype.Vote;
import org.msz.servlet.datatype.VoteOption;
import org.msz.servlet.datatype.polls.SingleDecisionPoll;

@Ignore
public class TestDAO extends TestCase
{
    public static String hibernateConfig = 
//	"/Dev/javaprojects/MSZ_Szavazas/WebContent/WEB-INF/conf/hibernate.cfg.xml"
     "/hibernate.cfg.xml"
    ;

    public void xtestUser() throws Exception
    {
	PollsServletDAO dao = new PollsServletDAO(getClass().getResource(hibernateConfig));

	int userID = dao.getNextID(User.class);

	try
	{
	    dao.get(userID, User.class);
	    fail();
	} catch (Exception e)
	{
	}

	User user = new User(userID, "e", "p", false, "a", 1, 2);
	PollGroup group = new PollGroup(1, "1", null);
	
	Set<Poll> polls = new TreeSet<Poll>();
	polls.add(new Poll(1, "t", "d", 2, true, true, new TreeSet(), user.id, group.id));

	user.setOwnedPolls(polls);
	dao.save(user);

	assertEquals(user.toString(), dao.get(user.getId(), User.class)
		.toString());

	user.enabled = true;
	dao.update(user);

	assertEquals(user.toString(), dao.get(user.getId(), User.class)
		.toString());

	dao.delete(user.getId(), User.class);
	try
	{
	    dao.get(userID, User.class);
	    fail();
	} catch (Exception e)
	{
	}
    }

    public void xtestOption() throws Exception
    {
	PollsServletDAO dao = new PollsServletDAO(getClass().getResource(hibernateConfig));

	int id = dao.getNextID(PollOption.class);

	try
	{
	    dao.get(id, PollOption.class);
	    fail();
	} catch (Exception e)
	{
	}

	PollOption option = new PollOption(id, "e", "p", id, null);
	dao.save(option);

	assertEquals(option.toString(), dao.get(option.getId(),
		PollOption.class).toString());

	option.name = "e2";
	option.value = "p2";
	dao.update(option);

	assertEquals(option.toString(), dao.get(option.getId(),
		PollOption.class).toString());

	dao.delete(option.getId(), PollOption.class);
	try
	{
	    dao.get(id, PollOption.class);
	    fail();
	} catch (Exception e)
	{
	}
    }

    public void xtestPoll() throws Exception
    {
	PollsServletDAO dao = new PollsServletDAO(getClass().getResource(hibernateConfig));

	int id = dao.getNextID(Poll.class);

	try
	{
	    dao.get(id, Poll.class);
	    fail();
	} catch (Exception e)
	{
	}

	SortedSet<PollOption> options = new TreeSet<PollOption>();

	PollOption o1 = new PollOption(1, "n", "v", id, null);
	PollOption o2 = new PollOption(2, "n2", "v2", id, null);
	PollOption o3 = new PollOption(3, "n3", "v3", id, null);

	options.add(o1);
	options.add(o2);
	options.add(o3);
	User user = (User)dao.get(1, User.class);
  PollGroup group = new PollGroup(1, "1", null);

	Poll poll = new Poll(id, "t", "d", 1, true, true, options, user.id, group.id);
	dao.save(poll);
	// dao.store(o1);
	// dao.store(o2);
	// dao.store(o3);

	// System.exit(-1);

	System.out.println("....................................... "
		+ ((Poll) dao.get(poll.getId(), Poll.class)));

	assertEquals(poll.getOptions().size(), ((Poll) dao.get(poll.getId(),
		Poll.class)).getOptions().size());

	poll.title = "t2";
	poll.description = "d2";
	poll.getOptions().remove(0);
	poll.getOptions().add(new PollOption(4, "n4", "v4", poll.getId(), null));
	poll.getOptions().add(new PollOption(5, "n5", "v5", poll.getId(), null));

	dao.update(poll);

	assertEquals(poll.getOptions().size(), ((Poll) dao.get(poll.getId(),
		Poll.class)).getOptions().size());

	dao.delete(poll.getId(), Poll.class);
	try
	{
	    dao.get(id, Poll.class);
	    fail();
	} catch (Exception e)
	{
	}
    }

    public void xtestVote() throws Exception
    {
	PollsServletDAO dao = new PollsServletDAO(getClass().getResource(hibernateConfig));

	int id = dao.getNextID(Vote.class);

	try
	{
	    dao.get(id, Vote.class);
	    fail();
	} catch (Exception e)
	{
	}

	User user = new User(dao.getNextID(User.class) + 1, "e", "p", false, "a", 1, 2);
  PollGroup group = new PollGroup(1, "1", null);

	SortedSet<Poll> polls = new TreeSet<Poll>();

	Poll poll = new Poll(1, "t", "d", 2, true, true, new TreeSet(), user.id, group.id);
	polls.add(poll);

	user.setOwnedPolls(polls);
	dao.save(user);

	SortedSet<VoteOption> options = new TreeSet<VoteOption>();

	VoteOption o1 = new VoteOption(dao.getNextID(VoteOption.class) + 1,
		"n", "v", id);
	VoteOption o2 = new VoteOption(o1.id + 1, "n2", "v2", id);
	VoteOption o3 = new VoteOption(o2.id + 1, "n3", "v3", id);

	options.add(o1);
	options.add(o2);
	options.add(o3);

	Vote vote = new Vote(id, user.id, poll.id, options);
	dao.save(vote);
	// dao.store(o1);
	// dao.store(o2);
	// dao.store(o3);

	// System.exit(-1);

	System.out.println("....................................... "
		+ ((Vote) dao.get(vote.getId(), Vote.class)));

	assertEquals(vote.getOptions().size(), ((Vote) dao.get(vote.getId(),
		Vote.class)).getOptions().size());

	// vote.getOptions().remove(0);

	VoteOption o4 = new VoteOption(o3.id + 1, "n4", "v4", vote.id);
	vote.getOptions().add(o4);
	VoteOption o5 = new VoteOption(o4.id + 1, "n5", "v5", vote.id);
	vote.getOptions().add(o5);

	dao.update(vote);

	assertEquals(vote.getOptions().size(), ((Vote) dao.get(vote.getId(),
		Vote.class)).getOptions().size());

	dao.delete(user.getId(), User.class);
	dao.delete(vote.getId(), Vote.class);
	try
	{
	    dao.get(id, Vote.class);
	    fail();
	} catch (Exception e)
	{
	}
    }

    public void testSingleDecisionPoll() throws Exception
    {
	PollsServletDAO dao = new PollsServletDAO(getClass().getResource(hibernateConfig));

	int id = dao.getNextID(SingleDecisionPoll.class);

	try
	{
	    dao.get(id, SingleDecisionPoll.class);
	    fail();
	} catch (Exception e)
	{
	}

	SortedSet<PollOption> options = new TreeSet<PollOption>();

	PollOption o1 = new PollOption(1, "n", "v", id, null);
	PollOption o2 = new PollOption(2, "n2", "v2", id, null);
	PollOption o3 = new PollOption(3, "n3", "v3", id, null);

	options.add(o1);
	options.add(o2);
	options.add(o3);
	
	try
    {
	  dao.save(new User(1, "e", "p", true, "a", 1, 1));
    }
    catch (Exception e1)
    {
    }

	User user = (User)dao.get(1, User.class);
  PollGroup group = new PollGroup(1, "1", null);

	SingleDecisionPoll poll = new SingleDecisionPoll(id, 
		new Poll(dao.getNextID(Poll.class), 
			"tsdp", "d", 1, true,
			true, options, user.id, group.id), group);
	dao.save(poll);

	
	dao.delete(poll.getId(), SingleDecisionPoll.class);
	try
	{
	    dao.get(id, SingleDecisionPoll.class);
	    fail();
	} catch (Exception e)
	{
	}
    }
}
