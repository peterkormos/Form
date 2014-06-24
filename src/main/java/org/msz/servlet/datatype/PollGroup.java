package org.msz.servlet.datatype;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.msz.datatype.Record;

@Entity
@Table(name = "poll_group")
public class PollGroup extends Record
{
  @Column(name="name")
  public String groupName;
  
  @OneToMany(targetEntity = Poll.class, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
  @JoinColumn(name = "group_id", referencedColumnName="record_id")
  public Set<Poll> polls;

  public PollGroup()
  {
  }

  public PollGroup(int id, String groupName, Set<Poll> polls)
  {
    super(id);

    this.groupName = groupName;
    this.polls = polls;
  }

  @Override
  public String toString()
  {
    return super.toString() + " groupName: " + groupName + " polls: " + polls;
  }

  public String getGroupName()
  {
    return groupName;
  }

  public void setGroupName(String groupName)
  {
    this.groupName = groupName;
  }

  public Set<Poll> getPolls()
  {
    if (polls == null)
      polls = new HashSet<Poll>();

    return polls;
  }

  public void setPolls(Set<Poll> polls)
  {
    this.polls = polls;
  }
  
  
}
