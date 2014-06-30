<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="org.msz.util.WebUtils"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript">
	function recalculateFreeAmount() {
		var sumAmount = 0;
		var options = document.getElementById('options').value;

		for ( var i = 1; i <= options; i++) {
			//		alert("["+ document.getElementById('optionValue'+i).value + "]");

			var currentValue = document.getElementById('optionValue' + i).value;
			if (isNaN(currentValue))
				alert("Rossz adat: [" + currentValue + "]");
			else if (currentValue != '')
				sumAmount += parseInt(currentValue);
		}

		//	alert(sumAmount + " " + document.getElementById('maxAmount').innerHTML);	

		document.getElementById('freeAmount').innerHTML = document
				.getElementById('maxAmount').innerHTML
				- sumAmount;
	}

	function moveUp(currentDiv) {
		//	alert(currentDiv.id);

		var parentDiv = document.getElementById("containerDiv");

		if (currentDiv.id > 1) {
			var next = document.getElementById(parseInt(currentDiv.id) - 1);
			parentDiv.insertBefore(currentDiv, next);
		}

		reindex(parentDiv);
	}

	function moveDown(currentDiv) {
		var parentDiv = document.getElementById("containerDiv");

		if (currentDiv.id < parentDiv.getElementsByTagName("div").length) {
			var next = document.getElementById(parseInt(currentDiv.id) + 2);
			parentDiv.insertBefore(currentDiv, next);

		}
		reindex(parentDiv);
	}

	function reindex(parentDiv) {
		var divs = parentDiv.getElementsByTagName("div");
		//	alert("divs: "  + divs.length);

		for (i = 0; i < divs.length; i++) {
			var childs = divs[i].getElementsByTagName("input");
			divs[i].id = i + 1;
			//				alert(childs + " " + childs.length);

			//	alert("div: "  + divs.length);
			if (childs == null)
				continue;

			for (j = 0; j < childs.length; j++) {
				if (childs[j].name == null)
					continue;
				//*	
				if (childs[j].name.indexOf("optionName") != -1) {
					//				alert("div: " + divs[i].id + " " + childs[j].name + " " + ("optionName"+(i+1)));
					childs[j].name = "optionName" + (i + 1);
				}

				if (childs[j].name.indexOf("optionValue") != -1) {
					//				alert("div: " + divs[i].id + " " + childs[j].name + " " + ("optionValue"+(i+1)));
					childs[j].name = "optionValue" + (i + 1);
					childs[j].value = (i + 1);
				}
				//*/			
			}
			//		alert("done: " + parentDiv.childNodes[i].id);
		}
	}
</script>
</head>
<body>

<%
  PollsServletDAO dao = new PollsServletDAO(null);

  int pollID = Integer.parseInt(WebUtils.getParameter(request,
      PollsServlet.POLL_ID));
  Poll poll = (Poll) dao.get(pollID, Poll.class);
%>


<%
  String pollURL = PollsServlet.getPollURL(pollID);
%>
<a href="<%=pollURL%>">Webc&iacute;m anon&iacute;m
szavaz&aacute;shoz:</a>
<br>
<input size="100" type="text" value="<%=pollURL%>">
<p>
<form accept-charset="UTF-8" name="input" action="../PollsServlet"
	method="post"><input type="hidden"
	name="<%=PollsServlet.COMMAND%>"
	value="<%=PollsServlet.COMMAND_SAVE_VOTE%>"> <input
	type="hidden" name="<%=PollsServlet.POLL_ID%>" value="<%=pollID%>">

<%
  if (session.getAttribute(PollsServlet.USER_ID) == null)
  {
%> Szavaz&oacute; email c&iacute;me: <input type="text"
	name="<%=PollsServlet.ANONYMOUS_VOTE%>">
<p>
<%
  }
%>

<table width="100%" border="1" cellspacing="0" cellpadding="0">

	<jsp:include page="pollHeader.jsp" />

<%
  if (session.getAttribute(PollsServlet.USER_ID) != null)
  {
%> 
    <jsp:include page="statisticsDetails.jsp" />
<%
  }
%>


	<tr>
		<td>V&aacute;laszt&aacute;si lehet&otilde;s&eacute;gek:</td>
		<td><!-- SplitPointsPoll --> <%
   if (poll instanceof SplitPointsPoll)
   {
     SplitPointsPoll splitPointsPoll = (SplitPointsPoll) poll;
 %> <input type="hidden" id="options" value="<%=poll.options.size()%>">
		<table width="100%" border="0">
			<tr>
				<td width="70%">Felhaszn&aacute;lhat&oacute; &ouml;sszeg:</td>
				<td width="30%"><label id="maxAmount"><%=splitPointsPoll.maxAmount%></label>
				<%=splitPointsPoll.units%></td>
			</tr>
			<tr>
				<td>M&eacute;g rendelkez&eacute;sre &aacute;ll&oacute;
				&ouml;sszeg:</td>
				<td><label id="freeAmount"><%=splitPointsPoll.maxAmount%></label>
				<%=splitPointsPoll.units%></td>
			</tr>
		</table>
		<%
		  }
		%> <!-- SplitPointsPoll --> <!-- OrderingPoll --> <%
   if (poll instanceof OrderingPoll)
   {
 %>
		<div id="containerDiv">
		<%
		  }
   List<PollOption> list = new LinkedList<PollOption>(poll.options);
   Collections.sort(list, new Comparator<PollOption>()
   {
     public int compare(PollOption arg0, PollOption arg1)
     {
       return new Integer(arg0.id).compareTo(new Integer(arg1.id));
     }
   });
		%> <!-- OrderingPoll --> 
		<table width="100%" border="0">
		<%
		  int httpIndex = 1;
		  for (PollOption option : list)
		  {
 %>
			<tr>
		<%
		    if (poll instanceof SingleDecisionPoll)
		    {
		      if (httpIndex == 1)
		        %> 
		        <input type='hidden' name='<%=PollsServlet.OPTION_VALUE + 1 %>' value='igen' >

				<td>
                    <%=option.name %>
                </td>
                <td>
 		             <input type='radio' name='<%=PollsServlet.OPTION_NAME + 1 %>' value='<%=option.name %>' >
                </td>
		        <%
		    }
		    else if (poll instanceof MultiDecisionPoll)
		    {
		      %>
		      <input type='hidden' name='<%=PollsServlet.OPTION_NAME + httpIndex %>' value='<%=option.name %>' >
                <td>
                    <%=option.name %>
                </td>
                <td>
              <input type='checkbox' name='<%=PollsServlet.OPTION_VALUE + httpIndex %>' value='igen' >
                </td>
              <%
		    }
		    else if (poll instanceof SplitPointsPoll)
		    {
		      %>
                <td>
                    <%=option.name %>
                </td>
                <td>
                   <input type='hidden' name='<%=PollsServlet.OPTION_NAME + httpIndex %>' value='<%=option.name %>' >
	       	       <input type='text' name='<%=PollsServlet.OPTION_VALUE + httpIndex %>' id='<%=PollsServlet.OPTION_VALUE + httpIndex %>'  onChange='recalculateFreeAmount()'>
                </td>
            <%
		    }
		    else if (poll instanceof AwardingPoll)
		    {
		      AwardingPoll awardingPoll = (AwardingPoll) poll;
		%> 
                <td>
                    <%=option.name %>
                </td>
                <td>
<input type='hidden'
			name='<%=PollsServlet.OPTION_NAME + httpIndex%>'
			value='<%=option.name%>'> 
			<%
   for (int i = 1; i <= awardingPoll.maxAmount; i++)
       {
 %> <input type='radio'
			name='<%=PollsServlet.OPTION_VALUE + httpIndex%>' value='<%=i%>'>
		<%=i%> <%
   }
 %>                 
</td>

		<%
		  }
		    else if (poll instanceof OrderingPoll)
		    {
		%>
		<div id="<%=httpIndex%>">

<input type="text"
			name="<%=PollsServlet.OPTION_VALUE + httpIndex%>"
			value="<%=httpIndex%>" readonly="readonly" size="4"> 
			
			<%=option.name%>

		<input type="hidden"
			name="<%=PollsServlet.OPTION_NAME + httpIndex%>"
			value="<%=option.name%>"> 
<input type="button" value="^"
			onClick="moveUp(this.parentNode)"> 
<input type="button"
			value="v" onClick="moveDown(this.parentNode)"></div>
		<%
		  }
		    else if (poll instanceof FormTypePoll)
		    {
		%> 
		
                <td>
		<%=option.name%> 
                </td>
                <td>
<input type="hidden"
			name="<%=PollsServlet.OPTION_NAME + httpIndex%>"
			value="<%=option.name%>"> 
<input type="text"
			name="<%=PollsServlet.OPTION_VALUE + httpIndex%>"> 
                </td>
		<%
		  }
		    else if (poll instanceof CustomPoll)
		    {
		%> 
                <td>
		<%=option.name%> 
                </td>
                <td>
<input type="hidden"
			name="<%=PollsServlet.OPTION_NAME + httpIndex%>"
			value="<%=option.name%>"> 
			<%
   if (PollsServlet.OPTION_TYPE_TEXT.equals(option.type))
       {
 %> <input type="text"
			name="<%=PollsServlet.OPTION_VALUE + httpIndex%>"> <br>
		<%
		  }
		      else if (PollsServlet.OPTION_TYPE_CHECKBOX.equals(option.type))
		      {
		%> <input type="checkbox"
			name="<%=PollsServlet.OPTION_VALUE + httpIndex%>"  value='igen'> <br>
		<%
		  }
		      else if (PollsServlet.OPTION_TYPE_RADIO.equals(option.type))
		      {
		        if (option.value != null)
		        {
		          StringTokenizer st = new StringTokenizer(option.value, ",");
		          while (st.hasMoreTokens())
		          {
		            String radioOption = st.nextToken().trim();
		%> <%=radioOption%> <input type="radio"
			name="<%=PollsServlet.OPTION_VALUE + httpIndex%>"
			value="<%=radioOption%>"> <%
   }
         }
 %> 
                </td>

		<%
		  }
		    }
		    else
		      out.println(poll.getClass().getName());

		    httpIndex++;
		    %>

            </tr>
<%
		  }
		%> 
		        </table>
		<!-- OrderingPoll --> <%
   if (poll instanceof OrderingPoll)
   {
 %>
		</div>
		<%
		  }
		%> <!-- OrderingPoll --></td>
	</tr>
	<tr bgcolor="#99FFCC">
		<td colspan="2">
		<div align="center"><input name="submit" type="submit"
			value="Ment&eacute;s"></div>
		</td>
	</tr>
</table>
</td>
</tr>
</table>
</form>
</body>
</html>
