package org.msz.servlet.datatype;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.msz.datatype.Record;

@Entity
@Table(name = "poll_vote_option")
public class VoteOption extends Record
{
  @Column(name = "name")
  public String name;
  @Column(name = "value")
  public String value;
  
  @Column(name = "vote_id")
  public int voteId;

  public int getVoteId()
  {
    return voteId;
  }

  public void setVoteId(int refId)
  {
    this.voteId = refId;
  }

  public VoteOption(int id, String name, String value, int refId)
  {
    super(id);

    this.name = name;
    this.value = value;
    this.voteId = refId;
  }

  @Override
  public void update(Record record)
  {
    // super.update(record);

    VoteOption option = (VoteOption) record;
    this.name = option.name;
    this.value = option.value;
    this.voteId = option.voteId;
  }

  @Override
  public String toString()
  {
    return super.toString() + " name: " + name + " value: " + value
        + " refId: " + voteId
        ;
  }
  
//  @Override
//  public boolean equals(Object obj)
//  {
//    return id == ((VoteOption)obj).id;
//  }
//  
//  @Override
//  public int hashCode()
//  {
//    return (getClass().getName()+id).hashCode();
//  }

  public String getName()
  {
    return name;
  }

  public void setName(String name)
  {
    this.name = name;
  }

  public String getValue()
  {
    return value;
  }

  public void setValue(String value)
  {
    this.value = value;
  }

  public VoteOption()
  {

  }

}
