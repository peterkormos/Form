package org.msz.servlet.datatype;

import java.util.HashSet;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.annotations.Sort;
import org.hibernate.annotations.SortType;
import org.msz.datatype.Record;

@Entity
@Table(name = "poll_user_role")
public class UserRole extends Record
{
  public static enum Role
  {
	Group, Admin
  };

  @Column(name = "user_id", nullable = false)
  private int userID;

  @Enumerated(EnumType.STRING)
  @Column(name = "role")
  private Role role;
  
  public UserRole()
  {
  }

  public UserRole(int id, int userID, Role role)
  {
	super(id);

	setUserID(userID);
	setRole(role);
  }
  
  public Role getRole()
  {
	return role;
  }
  
  public void setRole(Role role)
  {
	this.role = role;
  }

  public int getUserID()
  {
	return userID;
  }
  
  public void setUserID(int userID)
  {
	this.userID = userID;
  }

  @Override
  public String toString()
  {
	return "UserRole [userID=" + userID + ", role=" + role + ", toString()=" + super.toString() + "]";
  }
  
  
}
