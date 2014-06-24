package org.msz.util;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.Date;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Utils
{
  public void sendMessage(String smtpServer, String from, String to,
      String subject, String message, boolean debugSMTP) throws Exception
  {

    // create some properties and get the default Session
    Properties props = new Properties();
    props.put("mail.smtp.host", smtpServer);
    props.put("mail.debug", debugSMTP);

    if (from == null)
      throw new Exception("!!! Utils.sendMessage(): FROM address is null!");

    if (from.indexOf("@") == -1)
      throw new Exception(
          "!!! Utils.sendMessage(): invalid FROM e-mail address: " + from);

    if (to == null)
      throw new Exception("!!! Utils.sendMessage(): TO address is null !");

    if (to.indexOf("@") == -1)
      throw new Exception(
          "!!! Utils.sendMessage(): invalid TO e-mail address: " + to);

    Session session = Session.getDefaultInstance(props, null);
    session.setDebug(debugSMTP);

    // create a message
    Message msg = new MimeMessage(session);
    msg.setFrom(new InternetAddress(from));

    InternetAddress[] address = new InternetAddress[]
    { new InternetAddress(to) };

    msg.setRecipients(Message.RecipientType.TO, address);
    msg.setSubject(subject);
    msg.setSentDate(new Date());
    // If the desired charset is known, you can use setText(text, charset)
    msg.setText(message);
    msg.setHeader("Content-Type", "text/html");

    Transport.send(msg);
  }

  public StringBuffer loadFile(String file) throws FileNotFoundException,
      IOException
  {
    BufferedReader br = new BufferedReader(new FileReader(file));
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

  public String readURL(String reqURL) throws Exception
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

    BufferedReader in = new BufferedReader(new InputStreamReader(urlconn
        .getInputStream()));
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
