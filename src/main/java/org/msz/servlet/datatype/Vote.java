package org.msz.servlet.datatype;

import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Sort;
import org.hibernate.annotations.SortType;

@Entity
@Table(name = "poll_vote")
public class Vote extends OptionsBag
{
  @Column(name = "user_id")
  public int userID;

  @Column(name = "poll_id")
  public int pollID;

  @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
  @JoinColumn(name = "vote_id")
  @Sort(type=SortType.NATURAL)
  public SortedSet<VoteOption> options;

  public Vote()
  {
  }

  public Vote(int id, int userID, int pollID, SortedSet<VoteOption> options)
  {
    super(id);

    this.userID = userID;
    this.pollID = pollID;
    this.options = options;
  }

  @Override
  public String toString()
  {
    return super.toString() + " userID: " + userID + " pollID: " + pollID
        + " options: " + options;
  }

  public int getUserID()
  {
    return userID;
  }

  public void setUserID(int userID)
  {
    this.userID = userID;
  }

  public int getPollID()
  {
    return pollID;
  }

  public void setPollID(int pollID)
  {
    this.pollID = pollID;
  }

  public Set<VoteOption> getOptions()
  {
    if (options == null)
      options = new TreeSet<VoteOption>();

    return options;
  }

  public void setOptions(SortedSet<VoteOption> options)
  {
    this.options = options;
  }
}
