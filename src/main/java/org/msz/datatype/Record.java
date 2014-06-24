package org.msz.datatype;

import java.io.Serializable;

import javax.persistence.*;

@MappedSuperclass
public class Record implements Serializable, Comparable
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
  public int compareTo(Object o)
  {
    return new Integer(id).compareTo(((Record)o).id);
  }

}
