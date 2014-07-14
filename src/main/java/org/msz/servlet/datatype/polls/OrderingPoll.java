package org.msz.servlet.datatype.polls;

import java.util.List;
import java.util.SortedMap;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.msz.servlet.datatype.Poll;
import org.msz.servlet.datatype.PollGroup;
import org.msz.servlet.datatype.PollOption;
import org.msz.servlet.datatype.Vote;
import org.msz.servlet.datatype.VoteOption;

@Entity
@Table(name = "poll_ordering_poll")
@PrimaryKeyJoinColumn(name = "poll_id")
public class OrderingPoll extends Poll
{
  @Column(name = "poll_id", insertable = false, updatable = false, nullable = false)
  public int pollID;

  public OrderingPoll()
  {

  }

  public OrderingPoll(int id, Poll poll, PollGroup group)
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

  public SortedMap<String, String> getPollSpecificStatistics(List<Vote> votes)
  {
    SortedMap<String, String> map = super.getPollSpecificStatistics(votes);

    if (!votes.isEmpty())
      for (PollOption pollOption : options)
      {
        double avg = 0;
        for (Vote vote : votes)
        {
          for (VoteOption voteoption : vote.options)
          {
            if (voteoption.name.equals(pollOption.name))
              avg += Integer.parseInt(voteoption.value);
          }
        }
        avg /= votes.size();
        map.put("&Aacute;tlag pontsz&aacute;m ( avg = &sum;vote / # ): ",
            "");
        map.put("&Aacute;tlag pontsz&aacute;m [" + pollOption.name + "]: ",
            String.valueOf(avg));

        double distribution = 0;
        for (Vote vote : votes)
        {
          for (VoteOption voteoption : vote.options)
          {
            if (voteoption.name.equals(pollOption.name))
            {
              distribution += Math
                  .abs(Integer.parseInt(voteoption.value) - avg);
              
//              System.out.println(
//                  " pollOption.name: " + pollOption.name +
//                  " voteoption.name: " + voteoption.name + 
//                  " distribution: " + distribution
//                  + 
//                  " voteoption.value: " + voteoption.value + 
//                  " avg: " + avg
//                  );
            }
          }
        }
        distribution /= votes.size();
        map.put("Megoszt&aacute;si mutat&oacute; ( distribution = &sum; |vote| - avg  / # ): ",
            "");
        map.put("Megoszt&aacute;si mutat&oacute; [" + pollOption.name + "]: ",
            String.valueOf(distribution));

        map.put("V&eacute;geredm&eacute;ny ( avg + distribution ): ",
            "");
        map.put("V&eacute;geredm&eacute;ny [" + pollOption.name + "]: ",
            String.valueOf(avg+distribution));
      }

    return map;
  }
}
