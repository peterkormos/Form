package org.msz.servlet.datatype.polls;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.msz.datatype.Record;
import org.msz.servlet.datatype.Poll;

@Entity
@Table(name = "poll_public_polls")
public class PublicPoll extends Record
{
  @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
  @JoinColumn(name = "poll_id")
  public Poll poll;

  public PublicPoll()
  {

  }

  public PublicPoll(int id, Poll poll)
  {
    super(id);
    this.poll = poll;
  }

  public Poll getPoll()
  {
    return poll;
  }

  public void setPoll(Poll poll)
  {
    this.poll = poll;
  }

  @Override
  public String toString()
  {
    return " poll: " + poll;
  }
}
