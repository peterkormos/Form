package org.msz.servlet.datatype;

import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.servlet.http.HttpServletRequest;

@Entity
@Table(name = "poll_single_decision_poll")
@PrimaryKeyJoinColumn(name = "poll_id")
public class SingleDecisionPoll extends Poll
{

  @Column(name = "poll_id", insertable = false, updatable = false)
  public int pollID;

  public SingleDecisionPoll()
  {

  }

  public SingleDecisionPoll(int id, Poll poll, PollGroup group)
  {
    super(id,

    poll.title, poll.description, poll.endDate, poll.userCanAddEntry,
        poll.userCanResubmit, poll.options, poll.ownerID, group.id);

    this.pollID = poll.id;
  }

  public int getPollID()
  {
    return pollID;
  }

  public void setPollID(int pollID)
  {
    this.pollID = pollID;
  }

  @Override
  public String toString()
  {
    return super.toString() + " pollID: " + pollID;
  }
}
