package org.msz.servlet.datatype.polls;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.msz.servlet.datatype.Poll;
import org.msz.servlet.datatype.PollGroup;

@Entity
@Table(name = "poll_awarding_poll")
@PrimaryKeyJoinColumn(name = "poll_id")
public class AwardingPoll extends Poll
{
  @Column(name = "poll_id", insertable = false, updatable = false)
  public int pollID;

  @Column(name = "maxAmount")
  public int maxAmount;

  public AwardingPoll()
  {

  }

  public AwardingPoll(int id, Poll poll, int maxAmount, PollGroup group)
  {
    super(id,

    poll.title, poll.description, poll.endDate, poll.userCanAddEntry,
        poll.userCanResubmit, poll.options, poll.ownerID, group.id);

    this.pollID = poll.id;
    this.maxAmount = maxAmount;
  }

  public int getPollID()
  {
    return pollID;
  }

  public void setPollID(int pollID)
  {
    this.pollID = pollID;
  }

  public int getMaxAmount()
  {
    return maxAmount;
  }

  public void setMaxAmount(int maxAmount)
  {
    this.maxAmount = maxAmount;
  }

  @Override
  public String toString()
  {
    return super.toString() + " pollID: " + pollID + " maxAmount: " + maxAmount;
  }

}
