package org.msz.servlet.datatype;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Sort;
import org.hibernate.annotations.SortType;
import org.msz.datatype.Record;

@Entity
@Table(name = "poll_poll")
@Inheritance(strategy = InheritanceType.JOINED)
public class Poll extends OptionsBag
{
  @Column(name = "title")
  public String title;

  @Column(name = "description")
  public String description;

  @Column(name = "end_date")
  public long endDate;

  @Column(name = "user_Can_Resubmit")
  public boolean userCanResubmit;

  @Column(name = "user_Can_Add_Entry")
  public boolean userCanAddEntry;

  @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
  @JoinColumn(name = "poll_id")
  @Sort(type=SortType.NATURAL)
  public SortedSet<PollOption> options;

  @Column(name = "owner_id")
  public int ownerID;

  @Column(name = "group_id")
  public int groupID;

  @Override
  public String toString()
  {
    return super.toString() + " title: " + title + " description: "
        + description + " endDate: " + endDate + "(" + new Date(endDate) + ")"
        + " userCanResubmit: " + userCanResubmit + " userCanAddEntry: "
        + userCanAddEntry + " options: " + options + " owner.id: " + ownerID + 
        " groupID: " + groupID;
  }

  public Poll(int id, String title, String description, long endDate,
      boolean userCanAddEntry, boolean userCanResubmit,
      SortedSet<PollOption> options, int ownerID, int groupID)
  {
    super(id);
    
    this.title = title;
    this.description = description;
    this.endDate = endDate;
    this.userCanAddEntry = userCanAddEntry;
    this.userCanResubmit = userCanResubmit;
    this.options = options;
    this.ownerID = ownerID;
    this.groupID = groupID;
  }
  
//  @OneToOne(fetch = FetchType.EAGER)
//  @JoinColumn(name = "owner_id")
//  public User owner;
//  public User getOwner()
//  {
//    return owner;
//  }
//
//  public void setOwner(User owner)
//  {
//    this.owner = owner;
//  }

  // @ManyToMany(targetEntity = User.class, cascade = CascadeType.ALL, fetch =
  // FetchType.EAGER)
  // @JoinTable(name = "poll_binding",
  // joinColumns = @JoinColumn(name = "poll_id"),
  // inverseJoinColumns = @JoinColumn(name = "user_id"))
  // public Set<User> users;
  //
  // public Set<User> getUsers()
  // {
  // if (users == null)
  // users = new HashSet<User>();
  //
  // return users;
  // }
  //
  // public void setUsers(Set<User> users)
  // {
  // this.users = users;
  // }

  public Set<PollOption> getOptions()
  {
    if (options == null)
      options = new TreeSet<PollOption>();

    return options;
  }

  public void setOptions(SortedSet<PollOption> options)
  {
    this.options = options;
  }

  // public int maxDistributableAmount;
  // public String units;

  public Poll()
  {
  }


  @Override
  public void update(Record record)
  {
    // super.update(record);

    Poll poll = (Poll) record;

    this.title = poll.title;
    this.description = poll.description;
    this.endDate = poll.endDate;
    this.userCanAddEntry = poll.userCanAddEntry;
    this.userCanResubmit = poll.userCanResubmit;
    this.options.clear();
    this.options = poll.options;
    this.ownerID = poll.ownerID;
    this.groupID = poll.groupID;
  }

  public String getTitle()
  {
    return title;
  }

  public void setTitle(String title)
  {
    this.title = title;
  }

  public String getDescription()
  {
    return description;
  }

  public void setDescription(String description)
  {
    this.description = description;
  }

  public long getEndDate()
  {
    return endDate;
  }

  public void setEndDate(long endDate)
  {
    this.endDate = endDate;
  }

  public boolean isUserCanResubmit()
  {
    return userCanResubmit;
  }

  public void setUserCanResubmit(boolean userCanResubmit)
  {
    this.userCanResubmit = userCanResubmit;
  }

  public boolean isUserCanAddEntry()
  {
    return userCanAddEntry;
  }

  public void setUserCanAddEntry(boolean userCanAddEntry)
  {
    this.userCanAddEntry = userCanAddEntry;
  }

  public int getGroupID()
  {
    return groupID;
  }

  public void setGroupID(int groupID)
  {
    this.groupID = groupID;
  }

  public int getOwnerID()
  {
    return ownerID;
  }

  public void setOwnerID(int ownerID)
  {
    this.ownerID = ownerID;
  }

  public SortedMap<String, String> getPollSpecificStatistics(List<Vote> votes)
  {
    return new TreeMap<String, String>();
  }
}
