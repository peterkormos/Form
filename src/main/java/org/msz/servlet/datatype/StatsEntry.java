package org.msz.servlet.datatype;

public class StatsEntry
{
  public VoteOption option;
  public int count;

  public StatsEntry(VoteOption option, int count)
  {
    this.option = option;
    this.count = count;
  }
}
