package org.msz.servlet.datatype;

import java.util.Set;

import javax.persistence.MappedSuperclass;

import org.msz.datatype.Record;

@MappedSuperclass
public abstract class OptionsBag extends Record
{
    OptionsBag()
    {
    }

    OptionsBag(int id)
    {
	super(id);
    }

    public abstract Set getOptions();
}
