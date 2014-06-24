<%@page import="org.msz.servlet.*"%>
<%@page import="org.msz.servlet.util.MSZPollsServletDAO"%>
<%@page import="org.msz.datatype.Record"%>
<%@page import="org.msz.servlet.datatype.*"%>
<%@page import="java.util.*"%>
<%@page import="org.msz.servlet.datatype.Vote"%>
<%@page import="java.io.File"%>

<%
  MSZPollsServletDAO dao = new MSZPollsServletDAO("");
//  int userID = Integer.parseInt((String) session
//      .getAttribute(MSZPollsServlet.USER_ID));
//  User user = (User) dao.get(userID, User.class);
%>


<%@page import="org.msz.util.WebUtils"%><html>
<head>

<script
	src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAqev4fRnaiSo-XtAyyOdatRRO9qeUkRN7-Fvh2OLBEjwyQcLANhQ0UxuTtSFlxaQksGU210KhsRdkoA"
	type="text/javascript">
</script>

<xscript
	src="http://gmaps-utility-library.googlecode.com/svn/trunk/markermanager/release/src/markermanager.js"
	type="text/javascript">
</xscript>

<script type="text/javascript">

var map = null;
var geocoder = null;
var mgr = null;

function initialize() 
{
 	if (GBrowserIsCompatible()) 
 	{
		map = new GMap2(document.getElementById("map_canvas"));
		map.setCenter(new GLatLng(47.323931, 19.094238), 7);
        map.setUIToDefault();

//		mgr = new MarkerManager(map, {trackMarkers: true});

<%
String pollGroupID = WebUtils.getOptionalParameter(request, MSZPollsServlet.POLL_GROUP_ID);

if(pollGroupID == null )
          for(Record record : dao.getAll(User.class))
          {
            User user = (User)record; 
%>
    			addMarker( new GLatLng(<%= user.lat%>, <%= user.lng%>), "<%=user.emailAddress%> <p> <%=user.address%>");
  			<%
          }
else
  for(int userID : dao.getUsersInGroup(Integer.parseInt(pollGroupID)))
  {
    User user = (User)dao.get(userID, User.class);
    if(user.lat == 0)
      continue;
%>
        addMarker( new GLatLng(<%= user.lat%>, <%= user.lng%>), "<%=user.emailAddress%> <p> <%=user.address%>");
    <%
  }
        %>
	}
}

function addMarker(latlng, info) 
{
   		var marker = new GMarker(latlng);
        map.addOverlay(marker);
//			mgr.addMarker(marker, map.getZoom());
		if(info != '')
			GEvent.addListener(marker, "click", function(overlay, latlng) 
			{
	   			marker.openInfoWindowHtml(info);
			});		
}

    </script>
</head>


<body onload="initialize()" onunload="GUnload()">
<div id="map_canvas" style="width: 800px; height: 600px"></div>
</body>

</html>