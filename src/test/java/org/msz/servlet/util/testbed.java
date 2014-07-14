package org.msz.servlet.util;


public class testbed
{

  public static void main(String[] args) throws Exception
  {
	highlight(0XEEEEEE, true);
	highlight(0XEEEEEE, false);
  }
  
  static boolean highlight(long start, boolean flag)
  {
	if(flag)
	  System.out.println(Long.toHexString(start));
	else
	  System.out.println(Long.toHexString(start+1118481));
	
	return !flag;
  }
}
