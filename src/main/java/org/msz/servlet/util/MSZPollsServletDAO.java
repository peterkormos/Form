package org.msz.servlet.util;

import java.net.URL;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.msz.datatype.Record;
import org.msz.servlet.PollsServlet;
import org.msz.servlet.datatype.Poll;
import org.msz.servlet.datatype.PollGroup;
import org.msz.servlet.datatype.PublicPoll;
import org.msz.servlet.datatype.Subscription;
import org.msz.servlet.datatype.User;
import org.msz.servlet.datatype.Vote;
import org.msz.util.HibernateDAO;

public class MSZPollsServletDAO extends HibernateDAO
{
  public MSZPollsServletDAO(URL hibernateConfig)
  {
    super(hibernateConfig);
  }

  public Vote getVote(int userID, int pollID) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      Vote vote = (Vote) session.createQuery(
          "From Vote as p where p.userID = ? and p.pollID = ?").setInteger(0,
          userID).setInteger(1, pollID).uniqueResult();

      if (vote == null)
        throw new Exception("No vote can be found for userID: " + userID
            + " pollID: " + pollID);

      return vote;
    }
    finally
    {
      closeSession(session);
    }

  }

  public List<Vote> getVotesForUser(int userID) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      List<Vote> returned = (List<Vote>) session.createQuery(
          "From Vote where userID = ? order by id asc").setInteger(0, userID).list();

      if (returned == null)
        throw new Exception("No record is found");
      else
        return returned;
    }
    finally
    {
      closeSession(session);
    }

  }

  public List<Subscription> getSubscriptionsForPoll(int pollID) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      List<Subscription> returned = (List<Subscription>) session.createQuery(
          "From Subscription where pollID = ? order by id asc").setInteger(0, pollID).list();

      if (returned == null)
        return new LinkedList<Subscription>();
      else
        return returned;
    }
    finally
    {
      closeSession(session);
    }

  }

  public List<Subscription> getSubscriptionsForUser(int userID) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      List<Subscription> returned = (List<Subscription>) session.createQuery(
          "From Subscription where user.id = ? order by id asc").setInteger(0, userID).list();

      if (returned == null)
        return new LinkedList<Subscription>();
      else
        return returned;
    }
    finally
    {
      closeSession(session);
    }

  }

  public List<Vote> getVotesForPoll(int pollID) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      List<Vote> returned = (List<Vote>) session.createQuery(
          "From Vote where pollID = ?  order by id asc").setInteger(0, pollID).list();

      if (returned == null)
        throw new Exception("No record is found");
      else
        return returned;
    }
    finally
    {
      closeSession(session);
    }
  }

  public List<Record> getPolls() throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      List<Record> returned = (List<Record>) session.createQuery(
          "From Poll order by id asc").list();

      if (returned == null)
        throw new Exception("No record is found");
      else
        return returned;
    }
    finally
    {
      closeSession(session);
    }
  }

  public User login(String emailAddress, String password) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      User user = null;
      if (PollsServlet.NO_PASSWORD.equals(password))
        user = (User) session.createQuery("From User where emailAddress = ?")
            .setString(0, emailAddress).uniqueResult();
      else
        user = (User) session.createQuery(
            "From User where emailAddress = ? and password = ?").setString(0,
            emailAddress).setString(1, password).uniqueResult();

      if (user == null)
        throw new Exception(PollsServlet.messages
            .getProperty("user.not.found"));
      return user;
    }
    finally
    {
      closeSession(session);
    }

  }

  public boolean isUserRegistered(String emailAddress) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      User user = (User) session
          .createQuery("From User where emailAddress = ?").setString(0,
              emailAddress).uniqueResult();

      return user != null;
    }
    finally
    {
      closeSession(session);
    }

  }

  public void deletePublicFlag(int pollID) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      session.createQuery("delete PublicPoll where poll.id = ?").setInteger(0,
          pollID).executeUpdate();
      session.getTransaction().commit();

    }
    finally
    {
      closeSession(session);
    }

  }

  public PublicPoll getPublicPoll(int pollID)
  {
    Session session = null;
    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      PublicPoll publicPoll = (PublicPoll) session.createQuery(
          "From PublicPoll where poll.id = ?").setInteger(0, pollID).uniqueResult();

      return publicPoll;
    }
    finally
    {
      closeSession(session);
    }

  }

  public Set<Record> getPollsFromGroups(Set<PollGroup> groups)
  {
    Set<Record> polls = new HashSet<Record>();

    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      for (PollGroup pollGroup : groups)
      {
        polls.addAll((List<Record>) session.createQuery(
            "From Poll where groupID = ?").setInteger(0, pollGroup.id).list());
      }
    }
    finally
    {
      closeSession(session);
    }

    return polls;
  }

  public List<Integer> getUsersInGroup(int groupID) throws Exception
  {
    Session session = null;

    try
    {
      session = getHibernateSession();

      session.beginTransaction();

      List<Integer> list = (List<Integer>) session.createSQLQuery(
          "select user_id From poll_binding where group_ID = ?").setInteger(0,
          groupID).list();

      return list;
    }
    finally
    {
      closeSession(session);
    }

  }
}
