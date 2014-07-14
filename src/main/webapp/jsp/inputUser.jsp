<%@ page import="org.msz.servlet.*"%>


<%@page import="org.msz.util.WebUtils"%>
<%@page import="org.msz.servlet.datatype.User"%>
<%@page import="org.msz.servlet.util.PollsServletDAO"%><html>

<%
  String userID = WebUtils.getOptionalParameter(request,
					HTTPRequestParamNames.USER_ID);
			User user = null;
			if (userID != null) {
				PollsServletDAO dao = PollsServletDAO.getInstance();
				user = (User) dao.get(Integer.parseInt(userID), User.class);
			}
%>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script
	src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAqev4fRnaiSo-XtAyyOdatRRO9qeUkRN7-Fvh2OLBEjwyQcLANhQ0UxuTtSFlxaQksGU210KhsRdkoA"
	type="text/javascript">
</script>

<script type="text/javascript">

var map = null;
var geocoder = null;
var mgr = null;

function initialize() 
{
 	if (GBrowserIsCompatible()) 
 	{
 		map = new GMap2(document.getElementById("map_canvas"));
<%if (user != null && user.lat != 0d) {%> 		
        map.setCenter(new GLatLng(<%=user.lat%>, <%=user.lng%>), 13);
        <%} else {%>
        map.setCenter(new GLatLng(47.323931, 19.094238), 7);
        <%}%>
        
        map.setUIToDefault();


//    var mgr = new MarkerManager(map, {trackMarkers: true});

<%if (user != null && user.lat != 0d) {%>         
    addMarker(map.getCenter());
    <%}%>
//    var marker = new GMarker(point, {draggable: true, bouncy:true});
    //mgr.addMarker(marker, map.getZoom());

//    mgr.refresh();

    
		geocoder = new GClientGeocoder();
		
		GEvent.addListener(map, "click", function(overlay, latlng) 
		{
			addMarker(latlng);
		});		
	}
}

function showAddress(address) 
{	
	geocoder.getLatLng(
    	address,
    	function(latlng) 
	{
      		if (!latlng) 
        		alert(address + " c&iacute;m nem tal&aacute;lhat&oacute;!");
      		else 
				addMarker(latlng);
    });
}

function addMarker(latlng) 
{
	 	map.clearOverlays();

		map.setZoom(13);
  		map.panTo(latlng);
   		var marker = new GMarker(latlng, {draggable: true, bouncy:true});
        map.addOverlay(marker);
//			mgr.addMarker(marker, map.getZoom());
//		if(info != '')
//	   		marker.openInfoWindowHtml(info);
			
		document.getElementById("pointLat").value = latlng.lat();
		document.getElementById("pointLng").value = latlng.lng();
}

function checkData()
{
	var submitAllowed = document.getElementById("pointLat").value != '';
	
	if(!submitAllowed)
		alert('Valassz egy pontot mielott mentenel a szerverre!');
	else
		alert(document.getElementById("pointLat").value  +  ' ' +
			document.getElementById("pointLng").value);
		
	return document.getElementById("pointLat").value != '';
	
}
    </script>

</head>

<body onload="initialize()" onunload="GUnload()">
	<form accept-charset="UTF-8" action="../PollsServlet" method="post">

		<input type="hidden" name="<%=HTTPRequestParamNames.COMMAND%>"
			value="<%=PollsServlet.Command.saveUser%>">

		<table border="0">
			<tr>
				<td>Email c&iacute;m:</td>
				<td><input type="email"
					name="<%=HTTPRequestParamNames.USER_EMAIL_ADDRESS%>"
					value="<%=user != null ? user.emailAddress : ""%>"> <font
					color="#FF0000" size="+2">&#8226;</font></td>
			</tr>
			<tr>
				<td>Jelsz&oacute;:</td>
				<td><input type="password"
					name="<%=HTTPRequestParamNames.USER_PASSWORD%>"
					value="<%=user != null ? user.password : ""%>"> <font
					color="#FF0000" size="+2">&#8226;</font></td>
			</tr>
			<tr>
				<td>C&iacute;m:</td>
				<td>



					<p>
						<strong>Add meg a felvivend&otilde; pont
							c&iacute;m&eacute;t, vagy kattints a t&eacute;rk&eacute;pre....</strong>
					</p>
					<p>
						C&iacute;m: <input type="text" size="60"
							name="<%=HTTPRequestParamNames.USER_ADDRESS%>"
							value="<%=user != null ? user.address != null
					? user.address
					: "" : ""%>"
							id="addressID" onChange="showAddress(this.value);" /> <input
							type="button" value="Cím megmutatása a térképen"
							onClick="showAddress(document.getElementById('addressID').value);">
						<input type="hidden" name="<%=HTTPRequestParamNames.USER_ADDRESS_LAT%>"
							value="<%=user != null ? user.lat : ""%>" id="pointLat" /> <input
							type="hidden" name="<%=HTTPRequestParamNames.USER_ADDRESS_LNG%>"
							value="<%=user != null ? user.lng : ""%>" id="pointLng" />
					</p>

					<div id="map_canvas" style="width: 400px; height: 300px"></div>





				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div align="center">
						<p>
							<input type="submit"
								value="<%=user != null
					? "M&oacute;dos&iacute;t&aacute;s"
					: "Regisztr&aacute;ci&oacute;"%>">
						</p>
					</div>
				</td>
			</tr>
		</table>
		<p>
			<font color="#FF0000" size="+2">&#8226;</font> k&ouml;telez&otilde;
			megadni
		</p>
	</form>


</body>
</html>

