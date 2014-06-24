package org.msz.servlet.datatype;

import java.util.HashSet;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.persistence.*;

import org.hibernate.annotations.Sort;
import org.hibernate.annotations.SortType;
import org.msz.datatype.Record;

@Entity
@Table(name = "poll_user")
public class User extends Record
{
  @Column(name = "email_address")
  public String emailAddress;

  @Column(name = "user_password")
  public String password;

  @Column(name = "user_enabled")
  public boolean enabled;

  @Column(name = "user_address")
  public String address;

  @Column(name = "user_address_lat")
  public double lat;

  @Column(name = "user_address_lng")
  public double lng;

  @ManyToMany(targetEntity = PollGroup.class, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
  @JoinTable(name = "poll_binding", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "group_id"))
  @Sort(type = SortType.NATURAL)
  public SortedSet<PollGroup> pollGroups;

  @OneToMany(targetEntity = Poll.class, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
  @JoinColumn(name = "owner_id")
  public Set<Poll> ownedPolls;

  public Set<Poll> getOwnedPolls()
  {
    if (ownedPolls == null)
      ownedPolls = new HashSet<Poll>();

    return ownedPolls;
  }

  public void setOwnedPolls(Set<Poll> polls)
  {
    this.ownedPolls = polls;
  }

  public Set<PollGroup> getPollGroups()
  {
    if (pollGroups == null)
      pollGroups = new TreeSet<PollGroup>();

    return pollGroups;
  }

  public void setPollsGroups(SortedSet<PollGroup> pollGroups)
  {
    this.pollGroups = pollGroups;
  }

  public User()
  {
  }

  public User(int id, String emailAddress, String password, boolean enabled,
      String address, double lat, double lng)
  {
    super(id);

    this.emailAddress = emailAddress;
    this.password = password;
    this.enabled = enabled;
    this.address = address;
    this.lat = lat;
    this.lng = lng;
  }

  public void update(Record record)
  {
    // super.update(record);

    User user = (User) record;

    this.emailAddress = user.emailAddress;
    this.password = user.password;
    this.enabled = user.enabled;
    this.address = user.address;
    this.lat = user.lat;
    this.lng = user.lng;
  }

  @Override
  public String toString()
  {
    return super.toString() + " emailAddress: " + emailAddress + " password: "
        + password + " enabled: " + enabled + " address: " + address + " lat: "
        + lat + " lng: " + lng + " polls: " + pollGroups;
  }

  public String getEmailAddress()
  {
    return emailAddress;
  }

  public void setEmailAddress(String emailAddress)
  {
    this.emailAddress = emailAddress;
  }

  public String getPassword()
  {
    return password;
  }

  public void setPassword(String password)
  {
    this.password = password;
  }

  public boolean isEnabled()
  {
    return enabled;
  }

  public void setEnabled(boolean enabled)
  {
    this.enabled = enabled;
  }

  public String getAddress()
  {
    return address;
  }

  public void setAddress(String address)
  {
    this.address = address;
  }

  public double getLat()
  {
    return lat;
  }

  public void setLat(double lat)
  {
    this.lat = lat;
  }

  public double getLng()
  {
    return lng;
  }

  public void setLng(double lng)
  {
    this.lng = lng;
  }

}
