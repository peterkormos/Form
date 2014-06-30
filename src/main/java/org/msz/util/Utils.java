package org.msz.util;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.Date;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class Utils
{
  public static void sendMessage(String smtpServer, final String from, String to, String subject, String htmlMessage, boolean debugSMTP, final String password)
	  throws Exception
  {
	if (from == null)
	  throw new Exception("!!! Utils.sendMessage(): FROM address is null!");

	if (from.indexOf("@") == -1)
	  throw new Exception("!!! Utils.sendMessage(): invalid FROM e-mail address: " + from);

	if (to == null)
	  throw new Exception("!!! Utils.sendMessage(): TO address is null !");

	if (to.indexOf("@") == -1)
	  throw new Exception("!!! Utils.sendMessage(): invalid TO e-mail address: " + to);

	Properties props = new Properties();
	props.put("mail.smtp.host", smtpServer);
	props.put("mail.debug", debugSMTP);
	props.put("mail.smtp.socketFactory.port", "465");
	props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	props.put("mail.smtp.auth", "true");
	props.put("mail.smtp.port", "465");

	Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator()
	{
	  protected PasswordAuthentication getPasswordAuthentication()
	  {
		return new PasswordAuthentication(from, password);
	  }
	});

	Message message = new MimeMessage(session);
	message.setFrom(new InternetAddress(from));
	message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
	message.setSubject(subject);

	// Create a multi-part to combine the parts
	Multipart multipart = new MimeMultipart("alternative");

	// Create your text message part
	BodyPart messageBodyPart = new MimeBodyPart();
	messageBodyPart.setText("Ha ezt latod, akkor a levelezod nem jol jeleniti meg az emailt. Kerlek valaszolj a feladonak a hibaval kapcsolatban.");

	// Add the text part to the multipart
	multipart.addBodyPart(messageBodyPart);

	// Create the html part
	messageBodyPart = new MimeBodyPart();
	messageBodyPart.setContent(htmlMessage, "text/html");

	// Add html part to multi part
	multipart.addBodyPart(messageBodyPart);

	// Associate multi-part with message
	message.setContent(multipart);

	Transport.send(message);
  }

  public static StringBuffer loadFile(InputStream stream) throws FileNotFoundException, IOException
  {
	BufferedReader br = new BufferedReader(new InputStreamReader(stream));
	StringBuffer buffer = new StringBuffer();

	String line = null;
	while ((line = br.readLine()) != null)
	{
	  buffer.append("\r\n");
	  buffer.append(line);
	}

	br.close();

	return buffer;
  }

  public static String readURL(String reqURL) throws Exception
  {
	URL url = null;
	if (reqURL != null)
	  url = new URL(reqURL);

	URLConnection urlconn = url.openConnection();
	((HttpURLConnection) urlconn).setRequestMethod("POST");

	urlconn.setRequestProperty("Content-Type", "text/HTML");

	urlconn.setDoOutput(true);

	// urlconn.getOutputStream().write(command.getBytes());
	// System.out.println("ResponseCode: "
	// + ((HttpURLConnection) urlconn).getResponseCode());

	BufferedReader in = new BufferedReader(new InputStreamReader(urlconn.getInputStream()));
	String inputLine;

	StringBuffer buff = new StringBuffer();
	while ((inputLine = in.readLine()) != null)
	{
	  // System.out.println(inputLine);
	  buff.append(inputLine);
	  buff.append("\n\r");
	}
	in.close();

	return buff.toString();
  }
}
