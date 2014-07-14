package org.msz.servlet.datatype;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.msz.datatype.Record;

@Entity
@Table(name = "poll_subscription")
public class Subscription extends Record
{
  @OneToOne(fetch = FetchType.EAGER)
  @JoinColumn(name = "user_id")
  public User user;

  @Column(name = "poll_id")
  public int pollID;

  public Subscription()
  {
  }

  public Subscription(int id, int pollID, User user)
  {
    super(id);
    
    this.pollID = pollID;
    this.user = user;
  }

  public String toString()
  {
    return " pollID: " + pollID + " user: " + user;
  }

  public User getUser()
  {
    return user;
  }

  public void setUser(User user)
  {
    this.user = user;
  }

  public int getPollID()
  {
    return pollID;
  }

  public void setPollID(int pollID)
  {
    this.pollID = pollID;
  }
  

}
