package org.msz.servlet.datatype;

public class Option<E>
{
    public String name;
    public E value;
    
    public Option(String name, E value)
    {
      this.name = name;
      this.value = value;
    }
    
    @Override
    public String toString()
    {
        return "name: " + name + " value: " + value;
    }
}
