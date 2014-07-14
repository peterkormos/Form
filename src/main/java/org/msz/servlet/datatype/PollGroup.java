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
  @Column(name = "name")
  public String groupName;

  public PollGroup()
  {
  }

  public PollGroup(int id, String groupName)
  {
	super(id);

	this.groupName = groupName;
  }

  @Override
  public String toString()
  {
	return super.toString() + " groupName: " + groupName;
  }

  public String getGroupName()
  {
	return groupName;
  }

  public void setGroupName(String groupName)
  {
	this.groupName = groupName;
  }
}
