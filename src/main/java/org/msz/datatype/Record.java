package org.msz.datatype;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;

import org.msz.servlet.datatype.User;

@MappedSuperclass
public class Record implements Comparable<Record>
{
  @Id
  @Column(name = "record_id")
  public int id;
  
  public Record()
  {
    
  }

  public Record(int id)
  {
    this.id = id;
  }

  public void update(Record record)
  {
    this.id = record.id;
  }
  
  @Override
  public String toString()
  {
   
    return "id: " + id;
  }
  
  public int getId()
  {
    return id;
  }

  public void setId(int id)
  {
    this.id = id;
  }

  @Override
  public int compareTo(Record o)
  {
    return new Integer(id).compareTo(o.id);
  }
}
