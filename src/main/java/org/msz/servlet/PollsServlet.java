package org.msz.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.StringTokenizer;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.UnavailableException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpUtils;

import org.apache.log4j.Logger;
import org.apache.log4j.xml.DOMConfigurator;
import org.msz.datatype.Record;
import org.msz.servlet.datatype.OptionsBag;
import org.msz.servlet.datatype.Poll;
import org.msz.servlet.datatype.PollGroup;
import org.msz.servlet.datatype.PollOption;
import org.msz.servlet.datatype.PublicPoll;
import org.msz.servlet.datatype.Subscription;
import org.msz.servlet.datatype.User;
import org.msz.servlet.datatype.Vote;
import org.msz.servlet.datatype.VoteOption;
import org.msz.servlet.datatype.polls.AwardingPoll;
import org.msz.servlet.datatype.polls.SplitPointsPoll;
import org.msz.servlet.util.PollsServletDAO;
import org.msz.util.Utils;
import org.msz.util.WebUtils;

public class PollsServlet extends HttpServlet
{
  private Logger logger;
  PollsServletDAO dao;
  WebUtils webUtils;
  static Utils utils;
  public static Properties servletConfig;
  public static Properties messages;
  private String emailBody;

  // HTTP request parameters
  public static final String USER_ID = "userID";
  public static final String USER_EMAIL_ADDRESS = "emailAddress";
  public static final String ANONYMOUS_VOTE = "anonymousVote";
  public static final String USER_PASSWORD = "password";
  public static final String USER_ADDRESS = "address";
  public static final String USER_ADDRESS_LAT = "addressLat";
  public static final String USER_ADDRESS_LNG = "addressLng";
  public static final String POLL_ID = "pollID";
  public static final String POLL_GROUP_ID = "pollGroupID";
  public static final String POLL_OPTION_ID = "pollOptionID";
  public static final String DELETED_USER_ID = "deletedUserID";

  public static final String OPTION_NAME = "optionName";
  public static final String OPTION_VALUE = "optionValue";
  public static final String OPTION_TYPE = "optionType";
  public static final String OPTION_TYPE_RADIO = "radio";
  public static final String OPTION_TYPE_CHECKBOX = "checkbox";
  public static final String OPTION_TYPE_TEXT = "text";

  public static final String MAX_AMOUNT = "maxAmount";
  public static final String UNITS = "units";

  public static final String COMMAND = "command";

  public static final String COMMAND_SAVE_USER = "saveUser";
  public static final String COMMAND_LOGIN_USER = "login";
  public static final String COMMAND_LOGOUT = "logout";
  public static final String COMMAND_ACTIVATE_USER = "activate";
  public static final String COMMAND_SAVE_POLL = "savePoll";
  public static final String COMMAND_SAVE_VOTE = "saveVote";
  public static final String COMMAND_ADD_OPTION = "addOption";
  public static final String COMMAND_ADD_USER_TO_GROUP = "addUserToGroup";
  public static final String COMMAND_ADD_POLL_TO_GROUP = "addPollToGroup";
  public static final String COMMAND_SAVE_GROUP = "saveGroup";
  public static final String COMMAND_DELETE_POLL = "deletePoll";
  public static final String COMMAND_DELETE_VOTE = "deleteVote";
  public static final String COMMAND_DELETE_USER = "deleteUser";
  public static final String COMMAND_DELETE_POLL_OPTION = "deletePollOption";
  public static final String COMMAND_ASSIGN_POLL = "assignPoll";
  public static final String COMMAND_SEND_EMAILS_TO_GROUP = "sendEmails";
  public static final String COMMAND_USERS_IN_GROUP = "usersInGroup";
  public static final String COMMAND_SUBSCRIBE_TO_POLL = "subscribeToPoll";
  public static final String COMMAND_UNSUBSCRIBE_FROM_POLL = "unsubscribeFromPoll";

  public static final String POLL_CLASS = "pollClass";
  public static final String POLL_TITLE = "title";
  public static final String POLL_DESCRIPTION = "description";
  public static final String POLL_ENDDATE = "endDate";
  public static final String POLL_USER_CAN_RESUBMIT = "userCanResubmit";
  public static final String POLL_USER_CAN_ADD_ENTRY = "userCanAddEntry";
  public static final String SUBSCRIBE_USER_ID = "subscribeUser";
  public static final String PUBLIC_POLL = "publicPoll";
  public static final String GROUP_NAME = "groupName";

  public static final String MESSAGE_IN_HTTPSESSION = "message";

  // HTML page constants
  public static final String DATE_PATTERN = "yyyy-MM-dd";
  public static final String NO_PASSWORD = "-";

  public void init(ServletConfig config) throws ServletException
  {
    try
    {
      logger = Logger.getLogger(getClass());
      
      
      
      DOMConfigurator.configure(config.getServletContext().getResource("/WEB-INF/conf/log4j.xml"));
      logger
          .fatal("************************ Logging restarted ************************");

      utils = new Utils();
      webUtils = new WebUtils(logger);

      servletConfig = new Properties();
      servletConfig.load(config.getServletContext().getResourceAsStream("/WEB-INF/conf/servletConfig.ini"));

      messages = new Properties();
      messages.load(config.getServletContext().getResourceAsStream("/WEB-INF/conf/messages.html"));

      emailBody = utils.loadFile(config.getServletContext().getResourceAsStream("/WEB-INF/conf/emailBody.html")).toString();
      
      dao = new PollsServletDAO(
    	  config.getServletContext().getResource("/WEB-INF/conf/hibernate.cfg.xml"));
    }
    catch (Exception e)
    {
      if (logger != null)
        logger.fatal("init(): ", e);
      else
        e.printStackTrace();

      throw new UnavailableException(e.getMessage() + " " + e.toString());
    }
  }

  private void saveVote(HttpServletRequest request, HttpServletResponse response)
      throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));

    int userID;
    try
    {
      userID = Integer.parseInt(webUtils.getParameter(request, USER_ID));
    }
    catch (Exception e1)
    {
      // anonymous vote
      String anonymousUser = webUtils.getOptionalParameter(request,
          ANONYMOUS_VOTE);
      if (anonymousUser == null || anonymousUser.trim().length() == 0)
        anonymousUser = ANONYMOUS_VOTE + System.currentTimeMillis();
      try
      {
        User user = dao.login(anonymousUser, NO_PASSWORD);
        userID = user.id;
      }
      catch (Exception e)
      {
        userID = dao.getNextID(User.class);
        dao.save(new User(userID, anonymousUser, NO_PASSWORD, true, null, 0, 0));
      }
    }

    Poll poll = getPoll(pollID);
    checkPollRequest(request, poll, userID);

    // String voteClass = webUtils.getParameter(request, VOTE_CLASS);
    Vote vote = null;
    try
    {
      vote = dao.getVote(userID, pollID);
      vote.options.clear();
    }
    catch (Exception e)
    {
      vote = new Vote();
      vote.id = dao.getNextID(Vote.class);
      vote.pollID = poll.id;
      vote.userID = userID;
    }
    // (Vote) Class.forName(voteClass).newInstance();

    addOptions(request, vote);

    dao.save(vote);

    List<Subscription> subscriptions = dao.getSubscriptionsForPoll(poll.id);
    if (!subscriptions.isEmpty())
    {
      String message = readURL(request, poll.id);
      
      for (Subscription subscription : subscriptions)
      {
        sendEmail(subscription.user.id,
            messages.getProperty("email.type.saveVote"), 
            messages.getProperty("new.vote") + "<p>" + message);
      }
    }

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null && session.getAttribute(USER_ID) != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("save.vote"));
      session.removeAttribute(POLL_ID);
      redirectToMainPage(response);
    }
    else
    {
      // anonymous vote
      writeResponse(response, messages.getProperty("anonymous.vote"));
    }
  }

  private void redirectToMainPage(HttpServletResponse response) throws IOException
  {
	response.sendRedirect("jsp/main.jsp");
  }

  private String readURL(HttpServletRequest request, int pollID) throws Exception
  {
    String url = getPollURL(request, pollID);
    String message;
    try
    {
      message = utils.readURL(url);
    }
    catch (Exception e)
    {
      logger.error("!!! readURL(): ", e);
      message = messages.getProperty("url.error") + url;   
    }

    return message;
  }

  private void savePoll(HttpServletRequest request, HttpServletResponse response)
      throws Exception
  {
    Poll poll = null;
    int pollID = 0;
    try
    {
      // modify
      pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));
      poll = (Poll) dao.get(pollID, Poll.class);

      if (!poll.getClass().equals(
          Class.forName(webUtils.getParameter(request, POLL_CLASS))))
      {
        Poll newPoll = (Poll) Class.forName(
            webUtils.getParameter(request, POLL_CLASS)).newInstance();
        newPoll.id = pollID;

        newPoll.update(poll);
        poll = newPoll;

        dao.delete(pollID, poll.getClass());
        dao.save(poll);
      }
    }
    catch (Exception e)
    {
      // new
      poll = (Poll) Class.forName(webUtils.getParameter(request, POLL_CLASS))
          .newInstance();
      poll.id = dao.getNextID(Poll.class);
    }

    int userID = Integer.parseInt(webUtils.getParameter(request, USER_ID));
    checkPollRequest(request, poll, userID);

    addDetails(request, poll);

    PublicPoll publicPoll = dao.getPublicPoll(poll.id);

    if (webUtils.convertToBoolean(webUtils.getOptionalParameter(request,
        PUBLIC_POLL)))
    {
      if (publicPoll == null)
        dao.save(new PublicPoll(dao.getNextID(PublicPoll.class), poll));
    }
    else if (publicPoll != null)
      dao.delete(publicPoll.id, PublicPoll.class);

    if (pollID == 0)
    {
      User user = (User) dao.get(userID, User.class);
      user.getOwnedPolls().add(poll);
      logger.debug("savePoll(): " + user);
      dao.save(user);

    }
    else
    {
      logger.debug("savePoll(): " + poll);
      dao.merge(poll);
    }

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("save.vote"));
      session.removeAttribute(POLL_ID);
    }
    redirectToMainPage(response);
  }

  private void addDetails(HttpServletRequest request, Poll poll)
      throws Exception
  {
    poll.title = webUtils.getParameter(request, POLL_TITLE);
    poll.description = webUtils.getParameter(request, POLL_DESCRIPTION);
    try
    {
      poll.endDate = webUtils.convertToDate(webUtils.getParameter(request,
          POLL_ENDDATE), DATE_PATTERN);
      if (poll.endDate == 0)
        poll.endDate = Long.MAX_VALUE;
    }
    catch (Exception e)
    {
      poll.endDate = Long.MAX_VALUE;
    }

    poll.userCanResubmit = webUtils.convertToBoolean(webUtils
        .getOptionalParameter(request, POLL_USER_CAN_RESUBMIT));
    poll.userCanAddEntry = webUtils.convertToBoolean(webUtils
        .getOptionalParameter(request, POLL_USER_CAN_ADD_ENTRY));

    if (poll instanceof SplitPointsPoll)
    {
      SplitPointsPoll splitPointsPoll = (SplitPointsPoll) poll;
      try
      {
        splitPointsPoll.maxAmount = Integer.parseInt(webUtils.getParameter(
            request, MAX_AMOUNT));
      }
      catch (Exception e)
      {
        logger.info("addDetail(): ", e);
        throw new Exception(messages.getProperty("max.amount.not.set"));
      }

      splitPointsPoll.units = webUtils.getParameter(request, UNITS);
    }
    else if (poll instanceof AwardingPoll)
    {
      AwardingPoll awardingPoll = (AwardingPoll) poll;
      try
      {
        awardingPoll.maxAmount = Integer.parseInt(webUtils.getParameter(
            request, MAX_AMOUNT));
      }
      catch (Exception e)
      {
        logger.info("addDetail(): ", e);
        throw new Exception(messages.getProperty("max.amount.not.set"));
      }
    }

    addOptions(request, poll);
  }

  private void addOptions(HttpServletRequest request, OptionsBag optionsBag)
      throws Exception
  {
    logger.debug("addOptions(): original options: " + optionsBag.getOptions());

    int index = dao.getNextID(optionsBag instanceof Poll ? PollOption.class
        : VoteOption.class);
    try
    {
      int httpIndex = 1;
      while (true)
      {
        String paramName = webUtils.getParameter(request, OPTION_NAME
            + httpIndex);

        // System.out.println("paramName: " + paramName + " paramValue:
        // "
        // + paramValue + " httpIndex: " + httpIndex);

        if (!paramName.isEmpty())
          try
          {
            Record option;

            if (optionsBag instanceof Poll)
              option = new PollOption(index++, paramName, webUtils
                  .getOptionalParameter(request, OPTION_VALUE + httpIndex),
                  optionsBag.getId(), webUtils.getOptionalParameter(request,
                      OPTION_TYPE + httpIndex));
            else
              option = new VoteOption(index++, paramName, webUtils
                  .getParameter(request, OPTION_VALUE + httpIndex), optionsBag
                  .getId());

            optionsBag.getOptions().add(option);

          }
          catch (Exception e)
          {
            e.printStackTrace();
            // checkbox eseten nem biztos hogy megjon a
            // optionvalue parameter.
          }

        httpIndex++;
      }
    }
    catch (Exception e)
    {

    }

    logger.debug("addOptions(): updated options: " + optionsBag.getOptions());
  }

  private void addPollToGroup(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));
    Poll poll = getPoll(pollID);

    Integer pollGroupID = Integer.parseInt(webUtils.getParameter(request,
        POLL_GROUP_ID));
    PollGroup pollGroup = (PollGroup) dao.get(pollGroupID, PollGroup.class);

    dao.deletePublicFlag(pollID);
    pollGroup.getPolls().add(poll);

    dao.merge(pollGroup);

    String message = readURL(request, pollID); 

    for (int userID : dao.getUsersInGroup(pollGroupID))
      sendEmail(userID, messages.getProperty("email.type.addPollToGroup"),message);

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("added.poll.to.group"));
    redirectToMainPage(response);
  }

  private void addUserToGroup(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {

    List<Integer> userIDs = new LinkedList<Integer>();

    StringTokenizer st = new StringTokenizer(webUtils.getParameter(request,
        SUBSCRIBE_USER_ID), ",");

    Set<Record> users = dao.getAll(User.class);
    List<String> notFoundUsers = new LinkedList<String>();
    while (st.hasMoreTokens())
    {
      String emailAddress = st.nextToken().trim();

      boolean found = false;
      for (Record user : users)
      {
        if (emailAddress.equals(((User) user).emailAddress))
        {
          userIDs.add(user.id);
          found = true;
          break;
        }
      }
      if (!found)
        notFoundUsers.add(emailAddress);
    }

    Integer pollGroupID = Integer.parseInt(webUtils.getParameter(request,
        POLL_GROUP_ID));
    PollGroup pollGroup = (PollGroup) dao.get(pollGroupID, PollGroup.class);

    List<String> addedEmails = new LinkedList<String>();
    for (int userID : userIDs)
    {
      User user = (User) dao.get(userID, User.class);

      boolean found = false;
      for (PollGroup usersPollGroup : user.getPollGroups())
      {
        if (usersPollGroup.id == pollGroupID)
        {
          found = true;
          break;
        }
      }

      if (!found)
        user.getPollGroups().add(pollGroup);

      logger.debug("addUserToPoll(): " + user);
      dao.merge(user);
      addedEmails.add(user.emailAddress);
    }

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("added.users.to.group")
          + addedEmails

          + (notFoundUsers.isEmpty() ? "" : "<p>"
              + messages.getProperty("not.found.users") + notFoundUsers));
    redirectToMainPage(response);
  }

  private void usersInGroup(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    Integer pollGroupID = Integer.parseInt(webUtils.getParameter(request,
        POLL_GROUP_ID));

    LinkedList<String> addedEmails = new LinkedList<String>();

    for (int userID : dao.getUsersInGroup(pollGroupID))
      addedEmails.add(((User) dao.get(userID, User.class)).emailAddress);

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("added.users.to.group")
          + addedEmails);
    redirectToMainPage(response);
  }

  public static String getPollURL(HttpServletRequest request, int pollID) throws Exception
  {
    return request.getRequestURL() + "/jsp/inputVote.jsp?pollID="
        + pollID;
  }

  private void addOption(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));

    Poll poll = getPoll(pollID);
    int userID = Integer.parseInt(webUtils.getParameter(request, USER_ID));
    checkPollRequest(request, poll, userID);

    addOptions(request, poll);

    dao.save(poll);

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("save.option"));
    redirectToMainPage(response);
  }

  private void login(HttpServletRequest request, HttpServletResponse response)
      throws Exception
  {
    String emailAddress = webUtils.getParameter(request, USER_EMAIL_ADDRESS);
    String password = webUtils.getParameter(request, USER_PASSWORD);

    User user = dao.login(emailAddress, password);

    if (!user.enabled)
      throw new Exception(messages.getProperty("user.not.enabled"));

    HttpSession session = webUtils.getHttpSession(request, true);
    session.setAttribute(USER_ID, String.valueOf(user.id));
    session.removeAttribute(POLL_ID);
    session.removeAttribute(MESSAGE_IN_HTTPSESSION);

    redirectToMainPage(response);
  }

  private void saveUser(HttpServletRequest request, HttpServletResponse response)
      throws Exception
  {
    String emailAddress = webUtils.getParameter(request, USER_EMAIL_ADDRESS);
    String password = webUtils.getParameter(request, USER_PASSWORD);
    String address = webUtils.getParameter(request, USER_ADDRESS);
    double lat  = Double.parseDouble(webUtils.getParameter(request, USER_ADDRESS_LAT));
    double lng  = Double.parseDouble(webUtils.getParameter(request, USER_ADDRESS_LNG));

    String userID = webUtils.getOptionalParameter(request, USER_ID);

    // register
    if (userID == null)
    {
      if (dao.isUserRegistered(emailAddress))
      {
        writeResponse(response, messages.getProperty("user.already.registered"));
        return;
      }
      else
      {
        User user = new User(dao.getNextID(User.class), emailAddress, password,
            false, address, lat, lng);

        dao.save(user);

        sendEmail(user.id,
            messages.getProperty("email.type.saveUser"), 
            emailBody.replaceAll("__USERID__", String.valueOf(user.id)).replaceAll("__URL__", request.getRequestURL().toString())
            );

        writeResponse(response, messages.getProperty("registration.successful"));
      }
    }
    else
    {
      User user = (User) dao.get(Integer.parseInt(userID), User.class);
      user.update(new User(user.id, emailAddress, password, user.enabled, address, lat, lng));
      dao.merge(user);

      HttpSession session = webUtils.getHttpSession(request, false);
      if (session != null)
      {
        session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
            .getProperty("modify.user.data"));
      }
      redirectToMainPage(response);
    }
  }

  private void writeResponse(HttpServletResponse response, String message)
      throws IOException
  {
    response.setContentType("text/html");
    response.getOutputStream().write(
        message == null ? "null".getBytes() : message.getBytes());
  }

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException
  {
    try
    {
      if (request.getCharacterEncoding() == null)
        request.setCharacterEncoding("UTF-8");

      long startTime = System.currentTimeMillis();
      String command = webUtils.getParameter(request, COMMAND);

      logger.debug("doPost(): request arrived. command: " + command
          + " request.getCharacterEncoding: " + request.getCharacterEncoding()
          + " request paramters: " + request.getParameterMap().keySet()
          + " IP: " + request.getRemoteAddr());

      if (COMMAND_SAVE_VOTE.equals(command))
        saveVote(request, response);
      else if (COMMAND_SAVE_POLL.equals(command))
        savePoll(request, response);
      else if (COMMAND_SAVE_USER.equals(command))
        saveUser(request, response);
      else if (COMMAND_LOGIN_USER.equals(command))
        login(request, response);
      else if (COMMAND_ACTIVATE_USER.equals(command))
        activate(request, response);
      else if (COMMAND_ADD_OPTION.equals(command))
        addOption(request, response);
      else if (COMMAND_ADD_USER_TO_GROUP.equals(command))
        addUserToGroup(request, response);
      else if (COMMAND_ADD_POLL_TO_GROUP.equals(command))
        addPollToGroup(request, response);
      else if (COMMAND_SEND_EMAILS_TO_GROUP.equals(command))
        sendEmailsToGroup(request, response);
      else if (COMMAND_SAVE_GROUP.equals(command))
        saveGroup(request, response);
      else if (COMMAND_DELETE_POLL.equals(command))
        deletePoll(request, response);
      else if (COMMAND_DELETE_POLL_OPTION.equals(command))
        deletePollOption(request, response);
      else if (COMMAND_DELETE_VOTE.equals(command))
        deleteVote(request, response);
      else if (COMMAND_DELETE_USER.equals(command))
        deleteUser(request, response);
      else if (COMMAND_ASSIGN_POLL.equals(command))
        assignPoll(request, response);
      else if (COMMAND_USERS_IN_GROUP.equals(command))
        usersInGroup(request, response);
      else if (COMMAND_LOGOUT.equals(command))
        logout(request, response);
      else if (COMMAND_SUBSCRIBE_TO_POLL.equals(command))
        subscribeToPoll(request, response);
      else if (COMMAND_UNSUBSCRIBE_FROM_POLL.equals(command))
        unsubscribeFromPoll(request, response);
      else
        writeResponse(response, "Unknown command: [" + command + "]");

      logger.debug("doPost(): command: " + command + " IP: "
          + request.getRemoteAddr() + " processTime: "
          + (System.currentTimeMillis() - startTime));

    }
    catch (Exception e)
    {
      logger.error("doPost(): ", e);
      writeResponse(response, e.getMessage());
    }
  }

  private void subscribeToPoll(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));

    int userID = Integer.parseInt(webUtils.getParameter(request, USER_ID));
    User user = ((User) dao.get(userID, User.class));

    dao.save(new Subscription(dao.getNextID(Subscription.class), pollID, user));

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("subscribe.to.poll"));
    }
    redirectToMainPage(response);
  }

  private void unsubscribeFromPoll(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));

    int userID = Integer.parseInt(webUtils.getParameter(request, USER_ID));
    User user = ((User) dao.get(userID, User.class));

    List<Subscription> subscriptions = dao.getSubscriptionsForUser(userID);

    for (Subscription subscription : subscriptions)
    {
      if (subscription.pollID == pollID)
      {
        dao.delete(subscription.id, Subscription.class);
        break;
      }
    }

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("unsubscribe.from.poll"));
    }
    redirectToMainPage(response);
  }

  private void logout(HttpServletRequest request, HttpServletResponse response)
      throws Exception
  {
    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
      session.invalidate();
    response.sendRedirect("index.html");
  }

  private void saveGroup(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int userID = Integer.parseInt(webUtils.getParameter(request, USER_ID));
    User user = ((User) dao.get(userID, User.class));

    PollGroup pollGroup = new PollGroup(dao.getNextID(PollGroup.class),
        webUtils.getParameter(request, GROUP_NAME), null // polls
    );
    user.getPollGroups().add(pollGroup);

    dao.merge(user);

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("save.group"));
    }
    redirectToMainPage(response);
  }

  private void sendEmailsToGroup(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));
    Poll poll = getPoll(pollID);

    String message = readURL(request, pollID);

    for (int userID : dao.getUsersInGroup(poll.groupID))
      sendEmail(userID, messages.getProperty("email.type.sendEmailsToGroup"),message);

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("sent.email"));
    }
    redirectToMainPage(response);
  }

  private void sendEmail(int userID, String subject, String message) throws Exception
  {
    utils.sendMessage(servletConfig.getProperty("email.smtpServer"),
        servletConfig.getProperty("email.from"), ((User) dao.get(userID,
            User.class)).emailAddress, servletConfig
            .getProperty("email.subject") + subject, message, Boolean
            .parseBoolean(servletConfig.getProperty("email.debugSMTP")),
            servletConfig.getProperty("email.password"));
  }

  private void assignPoll(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));

    Poll poll = (Poll) dao.get(pollID, Poll.class);
    poll.ownerID = Integer.parseInt(webUtils.getParameter(request, USER_ID));

    dao.update(poll);

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("assign.poll"));
    }
    redirectToMainPage(response);
  }

  private void deletePoll(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));
    int userID = Integer.parseInt(webUtils.getParameter(request, USER_ID));

    List<Subscription> subscriptions = dao.getSubscriptionsForUser(userID);

    for (Subscription subscription : subscriptions)
    {
      if (subscription.pollID == pollID)
      {
        dao.delete(subscription.id, Subscription.class);
        break;
      }
    }

    PublicPoll publicPoll = dao.getPublicPoll(pollID);
    if (publicPoll != null)
      dao.delete(publicPoll.id, PublicPoll.class);
    else
      dao.delete(pollID, Poll.class);

    try
    {
      for (Vote vote : dao.getVotesForPoll(pollID))
        dao.delete(vote.id, Vote.class);
    }
    catch (Exception e)
    {
    }

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("delete.poll"));
    }
    redirectToMainPage(response);
  }

  private void deleteVote(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));
    String sUserID = webUtils.getOptionalParameter(request, DELETED_USER_ID);

    int userID = sUserID == null ? Integer.parseInt(webUtils.getParameter(
        request, USER_ID)) : Integer.parseInt(sUserID);

    try
    {
      Vote vote = dao.getVote(userID, pollID);
      dao.delete(vote.id, Vote.class);
    }
    catch (Exception e)
    {
    }

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("delete.vote"));
    }
    redirectToMainPage(response);
  }

  private void deleteUser(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int userID = Integer.parseInt(webUtils.getParameter(request,
        DELETED_USER_ID));
    User user = (User) dao.get(userID, User.class);

    for (Vote vote : dao.getVotesForUser(userID))
      dao.delete(vote.id, Vote.class);

    List<Subscription> subscriptions = dao.getSubscriptionsForUser(userID);

    for (Subscription subscription : subscriptions)
      dao.delete(subscription.id, Subscription.class);

    for (Poll poll : user.getOwnedPolls())
    {
      for (Vote vote : dao.getVotesForPoll(poll.id))
        dao.delete(vote.id, Vote.class);

      PublicPoll publicPoll = dao.getPublicPoll(poll.id);

      if (publicPoll != null)
        dao.delete(publicPoll.id, PublicPoll.class);
      else
        dao.delete(poll.id, Poll.class);

    }

    dao.delete(userID, User.class);

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("delete.user"));
    }
    redirectToMainPage(response);
  }

  private void deletePollOption(HttpServletRequest request,
      HttpServletResponse response) throws Exception
  {
    int pollID = Integer.parseInt(webUtils.getParameter(request, POLL_ID));
    Poll poll = getPoll(pollID);

    Integer pollOptionID = Integer.parseInt(webUtils.getParameter(request,
        POLL_OPTION_ID));
    for (PollOption option : poll.getOptions())
    {
      if (option.id == pollOptionID)
        dao.delete(pollOptionID, PollOption.class);
    }

    HttpSession session = webUtils.getHttpSession(request, false);
    if (session != null)
    {
      session.setAttribute(MESSAGE_IN_HTTPSESSION, messages
          .getProperty("delete.option"));
    }
    redirectToMainPage(response);
  }

  private Poll getPoll(int pollID) throws Exception
  {
    return (Poll) dao.get(pollID, Poll.class);
  }

  private void activate(HttpServletRequest request, HttpServletResponse response)
      throws Exception
  {
    int userID = Integer.parseInt(webUtils.getParameter(request, USER_ID));

    User user = (User) dao.get(userID, User.class);
    user.enabled = true;

    dao.save(user);

    writeResponse(response, messages.getProperty("activation.successful"));
  }

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException
  {
    doPost(request, response);
  }

  public void checkPollRequest(HttpServletRequest request, Poll poll, int userID)
      throws Exception
  {
    if (poll.endDate != 0 && poll.endDate < System.currentTimeMillis())
      throw new Exception(messages.getProperty("poll.endDate"));

    String command = webUtils.getParameter(request, COMMAND);

    if (COMMAND_ADD_OPTION.equals(command) && !poll.userCanAddEntry)
      throw new Exception("user cannot add entry!");

    try
    {
      if (COMMAND_SAVE_VOTE.equals(command) && !poll.userCanResubmit
          && dao.getVote(userID, poll.id) != null)
        throw new Exception(messages.getProperty("user.cannot.resubmit"));
    }
    catch (Exception e)
    {
    }
  }

  public static LinkedList<Record> sort(Collection<Record> collection)
  {
    LinkedList<Record> list = new LinkedList<Record>(collection);
    Collections.sort(list, new Comparator<Record>()
    {

      @Override
      public int compare(Record o1, Record o2)
      {
        return new Integer(o1.id).compareTo(new Integer(o2.id)) * -1;
      }

    });

    return list;
  }
}
