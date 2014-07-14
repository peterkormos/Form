package org.msz.util;

import java.net.URL;
import java.util.HashSet;
import java.util.Set;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.service.ServiceRegistryBuilder;
import org.msz.datatype.Record;

public class HibernateDAO
{
  private static SessionFactory sessionFactory;
  private URL configFile;

  protected Session getHibernateSession()
  {
	if (sessionFactory == null)
	{
	  Configuration configuration = new Configuration();
	  configuration.configure(configFile);
	  
	  ServiceRegistry serviceRegistry = new ServiceRegistryBuilder().applySettings(configuration.getProperties()).buildServiceRegistry();
	  sessionFactory = configuration.buildSessionFactory(serviceRegistry);
	}
	
	return sessionFactory.getCurrentSession();
  }

  protected void closeSession(Session session)
  {
	if ((session != null) && (session.isOpen()))
	{
	  session.close();
	}
  }

  public HibernateDAO(URL configFile)
  {
	this.configFile = configFile;
  }

  public void delete(int id, Class<? extends Record> recordClass) throws Exception
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  session.delete(session.load(recordClass, new Integer(id)));

	  session.getTransaction().commit();
	}
	finally
	{
	  closeSession(session);
	}
  }

  public int getNextID(Class<? extends Record> recordClass) throws Exception
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  Integer currentMaxvalue = (Integer) session.createQuery("select max(id) From " + recordClass.getSimpleName())
		  .uniqueResult();
	  return (currentMaxvalue == null ? 0 : currentMaxvalue) + 1;
	}
	finally
	{
	  closeSession(session);
	}
  }

  public Record get(int id, Class<? extends Record> recordClass) throws Exception
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  Record returned = (Record) session.createQuery("From " + recordClass.getSimpleName() + " as u where u.id = ?")
		  .setInteger(0, id).uniqueResult();

	  if (returned == null)
		throw new Exception("No record is found with id: " + id);
	  else
		return returned;
	}
	finally
	{
	  closeSession(session);
	}
  }

  @SuppressWarnings("unchecked")
  public Set<Record> getAll(Class<? extends Record> recordClass) throws Exception
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  return new HashSet<Record>(session.createQuery("From " + recordClass.getSimpleName() + " order by id asc").list());
	}
	finally
	{
	  closeSession(session);
	}
  }

  public void save(Record record) throws Exception
  {
	try
	{
	  get(record.getId(), record.getClass());
	  throw new IllegalArgumentException("M&aacute;r l&eacute;tez&ocirc; bejegyz&eacute;s! sorsz&aacute;m: <b>" + record.getId()
		  + "</b>");
	}
	catch (Exception e)
	{
	}

	Session session = null;
	try
	{
	  session = getHibernateSession();
	  session.beginTransaction();
	  session.saveOrUpdate(record);
	  session.getTransaction().commit();
	}
	finally
	{
	  closeSession(session);
	}
  }

  public void update(Record record) throws Exception
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  session.update(record);

	  session.getTransaction().commit();
	}
	finally
	{
	  closeSession(session);
	}
  }

  public void merge(Record record) throws Exception
  {
	Session session = null;

	try
	{
	  session = getHibernateSession();

	  session.beginTransaction();

	  session.merge(record);

	  session.getTransaction().commit();
	}
	finally
	{
	  closeSession(session);
	}
  }
}
