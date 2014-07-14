package org.msz.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

public class WebUtils
{
  private static Logger logger = Logger.getLogger(WebUtils.class);

  private static Map<Integer, String> charEncodeMap;

  static
  {
	charEncodeMap = new HashMap<Integer, String>();
	charEncodeMap.put(192, "&Agrave;");
	charEncodeMap.put(193, "&Aacute;");
	charEncodeMap.put(194, "&Acirc;");
	charEncodeMap.put(195, "&Atilde;");
	charEncodeMap.put(196, "&Auml;");
	charEncodeMap.put(197, "&Aring;");
	charEncodeMap.put(198, "&AElig;");
	charEncodeMap.put(199, "&Ccedil;");
	charEncodeMap.put(200, "&Egrave;");
	charEncodeMap.put(201, "&Eacute;");
	charEncodeMap.put(202, "&Ecirc;");
	charEncodeMap.put(203, "&Euml;");
	charEncodeMap.put(204, "&Igrave;");
	charEncodeMap.put(205, "&Iacute;");
	charEncodeMap.put(206, "&Icirc;");
	charEncodeMap.put(207, "&Iuml;");
	charEncodeMap.put(208, "&ETH;");
	charEncodeMap.put(209, "&Ntilde;");
	charEncodeMap.put(210, "&Ograve;");
	charEncodeMap.put(211, "&Oacute;");
	charEncodeMap.put(212, "&Ocirc;");
	charEncodeMap.put(213, "&Otilde;");
	charEncodeMap.put(214, "&Ouml;");
	charEncodeMap.put(215, "&times;");
	charEncodeMap.put(216, "&Oslash;");
	charEncodeMap.put(217, "&Ugrave;");
	charEncodeMap.put(218, "&Uacute;");
	charEncodeMap.put(219, "&Ucirc;");
	charEncodeMap.put(220, "&Uuml;");
	charEncodeMap.put(221, "&Yacute;");
	charEncodeMap.put(222, "&THORN;");
	charEncodeMap.put(223, "&szlig;");
	charEncodeMap.put(224, "&agrave;");
	charEncodeMap.put(225, "&aacute;");
	charEncodeMap.put(226, "&acirc;");
	charEncodeMap.put(227, "&atilde;");
	charEncodeMap.put(228, "&auml;");
	charEncodeMap.put(229, "&aring;");
	charEncodeMap.put(230, "&aelig;");
	charEncodeMap.put(231, "&ccedil;");
	charEncodeMap.put(232, "&egrave;");
	charEncodeMap.put(233, "&eacute;");
	charEncodeMap.put(234, "&ecirc;");
	charEncodeMap.put(235, "&euml;");
	charEncodeMap.put(236, "&igrave;");
	charEncodeMap.put(237, "&iacute;");
	charEncodeMap.put(238, "&icirc;");
	charEncodeMap.put(239, "&iuml;");
	charEncodeMap.put(240, "&eth;");
	charEncodeMap.put(241, "&ntilde;");
	charEncodeMap.put(242, "&ograve;");
	charEncodeMap.put(243, "&oacute;");
	charEncodeMap.put(244, "&ocirc;");
	charEncodeMap.put(245, "&otilde;");
	charEncodeMap.put(246, "&ouml;");
	charEncodeMap.put(247, "&divide;");
	charEncodeMap.put(248, "&oslash;");
	charEncodeMap.put(249, "&ugrave;");
	charEncodeMap.put(250, "&uacute;");
	charEncodeMap.put(251, "&ucirc;");
	charEncodeMap.put(252, "&uuml;");
	charEncodeMap.put(253, "&yacute;");
	charEncodeMap.put(254, "&thorn;");
	charEncodeMap.put(255, "&yuml;");

	for (int i = 336; i < 400; i++)
	  charEncodeMap.put(i, "&#" + i + ";");
  }

  public static Long convertToDate(String parameter, String pattern) throws Exception
  {
	if (parameter == null || parameter.isEmpty())
	  return 0l;

	try
	{
	  SimpleDateFormat format = new SimpleDateFormat(pattern);

	  return format.parse(parameter).getTime();
	}
	catch (Exception e)
	{
	  throw new Exception("Rossz d&aacute;tum form&aacute;tum! <b>yyyy-MM-dd</b>", e);
	}
  }

  public static String convertToString(long date, String pattern) throws Exception
  {
	SimpleDateFormat format = new SimpleDateFormat(pattern);

	return format.format(new Date(date));
  }

  public static boolean convertToBoolean(String httpParameter)
  {
	return "on".equals(httpParameter) ? true : false;
  }

  public static HttpSession getHttpSession(HttpServletRequest request, boolean createSession) throws Exception
  {
	HttpSession session = request.getSession(createSession);
	if (session == null)
	  throw new Exception("A felhaszn&aacute;l&oacute; nincs bel&eacute;pve!");

	return session;
  }

  public static String getOptionalParameter(HttpServletRequest request, String parameter)
  {
	try
	{
	  return getParameter(request, parameter);
	}
	catch (Exception e)
	{
	  return null;
	}
  }

  public static String getParameter(HttpServletRequest request, String parameter) throws Exception
  {
	String value = request.getParameter(parameter);
	if (value == null)
	{
	  HttpSession session = request.getSession(false);

	  if (session != null)
	  {
		value = (String) session.getAttribute(parameter);
		logger.debug("Read parameter: " + parameter + " from HttpSession. value: " + value);
	  }

	  if (value == null)
	  {
		throw new Exception(parameter + " is not found in HTTP request or in HTTP session! HTTP keys: "
		    + request.getParameterMap().keySet());
	  }

	  return value;
	}
	else
	  logger.debug("Read parameter: " + parameter + " from HttpServletRequest. value: " + value);

	return encodeString(value);
  }

  public static String encodeString(String value) throws Exception
  {

	if (value == null)
	  return "";

	value = value.replaceAll("\"", "'");

	//    return value;

	//    value = new String(value.getBytes("ISO-8859-1"), "UTF-8");

	// registrationServlet.logger.trace("encodeString(): " + value);
	StringBuffer buff = new StringBuffer();
	//    logDebug("encodeString(): " + value);

	char ch;
	for (int i = 0; i < value.length(); i++)
	{
	  ch = value.charAt(i);
	  if (!charEncodeMap.containsKey((int) ch))
	  {
		buff.append(ch);
		//        logDebug("encodeString(): " + ch + " " + (int) ch + " length: " + value.length());
	  }
	  else
		buff.append(charEncodeMap.get((int) ch));
	}

	return buff.toString();
	// return URLEncoder.encode(value, "ISO-8859-2");
  }

}
