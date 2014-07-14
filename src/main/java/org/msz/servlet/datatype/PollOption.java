package org.msz.servlet.datatype;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

import org.msz.datatype.Record;

@Entity
@Table(name = "poll_poll_option")
public class PollOption extends Record
{
    @Column(name = "name")
    public String name;
    
    @Column(name = "option_type")
    public String type;

    @Column(name = "value")
    public String value;

    @Column(name = "poll_id")
    public int pollId;


    public PollOption()
    {
	
    }
    
    public PollOption(int id, String name, String value, int refId, String type)
    {
	super(id);

	this.name = name;
	this.value = value;
	this.pollId = refId;
	this.type = type;
    }

    @Override
    public void update(Record record)
    {
	// super.update(record);

	PollOption option = (PollOption) record;
	this.name = option.name;
	this.value = option.value;
	this.pollId = option.pollId;
	this.type = option.type;
    }

    @Override
    public String toString()
    {
	return super.toString() + " name: " + name + " value: " + value
		+ " refId: " + pollId + " type: " + type;
    }

    // @Override
    // public boolean equals(Object obj)
    // {
    // return id == ((PollOption)obj).id;
    // }
    //  
    // @Override
    // public int hashCode()
    // {
    // return (getClass().getName()+id).hashCode();
    // }

    public int getPollId()
    {
	return pollId;
    }
    
    public void setPollId(int refId)
    {
	this.pollId = refId;
    }
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


    public String getType()
    {
        return type;
    }

    public void setType(String type)
    {
        this.type = type;
    }

}
