﻿using System;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using MantaMTA.Core.Enums;

namespace MantaMTA.Core.Server
{
	/// <summary>
	/// Provides a server for receiving SMTP commands/messages.
	/// </summary>
	public class SmtpServer : IDisposable
	{
		/// <summary>
		/// Listens to TCP socket.
		/// </summary>
		private TcpListener _TcpListener = null;
		/// <summary>
		/// Thread that this instance of SmtpServer will run on.
		/// </summary>
		private Thread _ServerThread = null;

		/// <summary>
		/// Make default constructor private so code from other classes has to use SmtpServer(port)
		/// </summary>
		private SmtpServer()
		{
			throw new Exception("Must specify port for SMTP Server.");
		}

		/// <summary>
		/// Creates an instance of the Colony101 SMTP Server.
		/// </summary>
		/// <param name="port">Port number that server bind to.</param>
		public SmtpServer(int port) : this(IPAddress.Any, port)	{ }

		/// <summary>
		/// Creates an instance of the Colony101 SMTP Server.
		/// </summary>
		/// <param name="iPAddress">IP Address to use for binding.</param>
		/// <param name="port">Port number that server bind to.</param>
		public SmtpServer(IPAddress ipAddress, int port)
		{
			// Create the TCP Listener using specified port on all IPs
			_TcpListener = new TcpListener(ipAddress, port);
			_ServerThread = new Thread(
				new ThreadStart(delegate()
				{
					try
					{
						_TcpListener.Start();
					}
					catch (SocketException ex)
					{
						Logging.Error("Failed to create server on " + ipAddress.ToString() + ":" + port, ex);
						return;
					}

					Logging.Info("Server started on " + ipAddress.ToString() + ":" + port);

					while (_TcpListener != null)
					{
						// Connection with client.
						TcpClient client = null;

						try
						{
							// AcceptTcpClient will block until done.
							client = _TcpListener.AcceptTcpClient();
						}
						catch (SocketException ex)
						{
							// Error code 10004 is AcceptTcpClient having block removed.
							// So server is shutting down.
							if (ex.ErrorCode == 10004)
								return;

							throw;
						}


						// Create a Task and run it to handle client connection.
						Task.Run(() => HandleSmtpConnection(client));
					}
				}));
			_ServerThread.Start();
		}
		
		/// <summary>
		/// SmtpServer dispose method. Ensures the TcpListener is stopped.
		/// </summary>
		public void Dispose()
		{
			_TcpListener.Stop();
			_TcpListener = null;
		}

		/// <summary>
		/// Method handles a single connection from a client.
		/// </summary>
		/// <param name="obj">Connection with the client.</param>
		private async Task<bool> HandleSmtpConnection(object obj)
		{
			TcpClient client = (TcpClient)obj;
			client.ReceiveTimeout = MtaParameters.Client.ConnectionReceiveTimeoutInterval * 1000;
			client.SendTimeout = MtaParameters.Client.ConnectionSendTimeoutInterval * 1000;

			try
			{
				Smtp.SmtpStreamHandler smtpStream = new Smtp.SmtpStreamHandler(client);

				// Identify our MTA
				await smtpStream.WriteLineAsync("220 " + GetServerHostname(client) + " ESMTP " + MtaParameters.MTA_NAME + " Ready");

				// Set to true when the client has sent quit command.
				bool quit = false;

				// Set to true when the client has said hello.
				bool hasHello = false;

				// Hostname of the client as it self identified in the HELO.
				string heloHost = string.Empty;

				SmtpServerTransaction mailTransaction = null;

				// As long as the client is connected and hasn't sent the quit command then keep accepting commands.
				while (client.Connected && !quit)
				{
					// Read the next command. If no line then this will wait for one.
					string cmd = await smtpStream.ReadLineAsync();

					// Client Disconnected.
					if (cmd == null)
						break;

					#region SMTP Commands that can be run before HELO is issued by client.

					// Handle the QUIT command. Should return 221 and close connection.
					if (cmd.Equals("QUIT", StringComparison.OrdinalIgnoreCase))
					{
						quit = true;
						await smtpStream.WriteLineAsync("221 Goodbye");
						continue;
					}

					// Reset the mail transaction state. Forget any mail from rcpt to data.
					if (cmd.Equals("RSET", StringComparison.OrdinalIgnoreCase))
					{
						mailTransaction = null;
						await smtpStream.WriteLineAsync("250 Ok");
						continue;
					}

					// Do nothing except return 250. Do nothing just return success (250).
					if (cmd.Equals("NOOP", StringComparison.OrdinalIgnoreCase))
					{
						await smtpStream.WriteLineAsync("250 Ok");
						continue;
					}

					#endregion

					// EHLO should 500 Bad Command as we don't support enhanced services, clients should then HELO.
					// We need to get the hostname provided by the client as it will be used in the recivied header.
					if (cmd.StartsWith("HELO", StringComparison.OrdinalIgnoreCase) || cmd.StartsWith("EHLO", StringComparison.OrdinalIgnoreCase))
					{
						// Helo should be followed by a hostname, if not syntax error.
						if (cmd.IndexOf(" ") < 0)
						{
							await smtpStream.WriteLineAsync("501 Syntax error");
							continue;
						}

						// Grab the hostname.
						heloHost = cmd.Substring(cmd.IndexOf(" ")).Trim();

						// There should not be any spaces in the hostname if it is sytax error.
						if (heloHost.IndexOf(" ") >= 0)
						{
							await smtpStream.WriteLineAsync("501 Syntax error");
							heloHost = string.Empty;
							continue;
						}

						// Client has now said hello so set connection variable to true and 250 back to the client.
						hasHello = true;
						if (cmd.StartsWith("HELO", StringComparison.OrdinalIgnoreCase))
						{
							await smtpStream.WriteLineAsync("250 Hello " + heloHost + "[" + smtpStream.RemoteAddress.ToString() + "]");
						}
						else
						{
							// EHLO was sent, let the client know what extensions we support.
							await smtpStream.WriteLineAsync("250-Hello " + heloHost + "[" + smtpStream.RemoteAddress.ToString() + "]");
							await smtpStream.WriteLineAsync("250-8BITMIME");
							await smtpStream.WriteLineAsync("250 Ok");
						}
						continue;
					}

					#region Commands that must be after a HELO

					// Client MUST helo before being allowed to do any of these commands.
					if (!hasHello)
					{
						await smtpStream.WriteLineAsync("503 HELO first");
						continue;
					}

					// Mail From should have a valid email address parameter, if it doesn't system error.
					// Mail From should also begin new transaction and forget any previous mail from, rcpt to or data commands.
					// Do this by creating new instance of SmtpTransaction class.
					if (cmd.StartsWith("MAIL FROM:", StringComparison.OrdinalIgnoreCase))
					{
						mailTransaction = new SmtpServerTransaction();

						// Check for the 8BITMIME body parameter
						int bodyParaIndex = cmd.IndexOf(" BODY=", StringComparison.OrdinalIgnoreCase);
						string mimeMode = "";

						if (bodyParaIndex > -1)
						{
							// The body parameter was passed in.
							// Extract the mime mode, if it isn't reconised inform the client of invalid syntax.
							mimeMode = cmd.Substring(bodyParaIndex + " BODY=".Length).Trim();
							cmd = cmd.Substring(0, bodyParaIndex);

							if (mimeMode.Equals("7BIT", StringComparison.OrdinalIgnoreCase))
							{
								mailTransaction.TransportMIME = SmtpTransportMIME._7BitASCII;
							}
							else if (mimeMode.Equals("8BITMIME", StringComparison.OrdinalIgnoreCase))
							{
								mailTransaction.TransportMIME = SmtpTransportMIME._8BitUTF;
							}
							else
							{
								await smtpStream.WriteLineAsync("501 Syntax error");
								continue;
							}
						}
						
						string mailFrom = string.Empty;
						try
						{
							string address = cmd.Substring(cmd.IndexOf(":") + 1);
							if (address.Trim().Equals("<>"))
								mailFrom = null;
							else
								mailFrom = new System.Net.Mail.MailAddress(address).Address;
						}
						catch (Exception)
						{
							// Mail from not valid email.
							smtpStream.WriteLine("501 Syntax error");
							continue;
						}

						// If we got this far mail from has an valid email address parameter so set it in the transaction
						// and return success to the client.
						mailTransaction.MailFrom = mailFrom;
						await smtpStream.WriteLineAsync("250 Ok");
						continue;
					}

					// RCPT TO should have an email address parameter. It can only be set if MAIL FROM has already been set,
					// multiple RCPT TO addresses can be added.
					if (cmd.StartsWith("RCPT TO:", StringComparison.OrdinalIgnoreCase))
					{
						// Check we have a Mail From address.
						if (mailTransaction == null ||
							!mailTransaction.HasMailFrom)
						{
							await smtpStream.WriteLineAsync("503 Bad sequence of commands");
							continue;
						}

						// Check that the RCPT TO has a valid email address parameter.
						MailAddress rcptTo = null;
						try
						{
							rcptTo = new MailAddress(cmd.Substring(cmd.IndexOf(":") + 1));
						}
						catch (Exception)
						{
							// Mail from not valid email.
							smtpStream.WriteLine("501 Syntax error");
							continue;
						}


						// Check to see if mail is to be delivered locally or relayed for delivery somewhere else.
						if (!MtaParameters.LocalDomains.Contains(rcptTo.Host.ToLower()))
						{
							// Messages isn't for delivery on this server.
							// Check if we are allowed to relay for the client IP
							if (!MtaParameters.IPsToAllowRelaying.Contains(smtpStream.RemoteAddress.ToString()))
							{
								// This server cannot deliver or relay message for the MAIL FROM + RCPT TO addresses.
								// This should be treated as a permament failer, tell client not to retry.
								await smtpStream.WriteLineAsync("554 Cannot relay");
								continue;
							}

							// Message is for relaying.
							mailTransaction.MessageDestination = Enums.MessageDestination.Relay;
						}
						else
						{

							// Message to be delivered locally.
							mailTransaction.MessageDestination = Enums.MessageDestination.Self;
						}

						// Add the recipient.
						mailTransaction.RcptTo.Add(rcptTo.ToString());
						await smtpStream.WriteLineAsync("250 Ok");
						continue;
					}

					// Handle the data command, all commands from the client until single line with only '.' should be treated as
					// a single blob of data.
					if (cmd.Equals("DATA", StringComparison.OrdinalIgnoreCase))
					{
						// Must have a MAIL FROM before data.
						if (mailTransaction == null ||
							!mailTransaction.HasMailFrom)
						{
							await smtpStream.WriteLineAsync("503 Bad sequence of commands");
							continue;
						}
						// Must have RCPT's before data.
						else if (mailTransaction.RcptTo.Count < 1)
						{
							await smtpStream.WriteLineAsync("554 No valid recipients");
							continue;
						}

						// Tell the client we are now accepting there data.
						await smtpStream.WriteLineAsync("354 Go ahead");

						// Set the transport MIME to default or as specified by mail from body
						smtpStream.SetSmtpTransportMIME(mailTransaction.TransportMIME);

						// Wait for the first data line. Don't log data in SMTP log file.
						string dataline = await smtpStream.ReadLineAsync(false);
						StringBuilder dataBuilder = new StringBuilder();
						// Loop until data client stops sending us data.
						while (!dataline.Equals("."))
						{
							// Add the line to existing data.
							dataBuilder.AppendLine(dataline);

							// Wait for the next data line. Don't log data in SMTP log file.
							dataline = await smtpStream.ReadLineAsync(false);
						}
						mailTransaction.Data = dataBuilder.ToString();

						// Data has been received, return to 7 bit ascii.
						smtpStream.SetSmtpTransportMIME(SmtpTransportMIME._7BitASCII);

						// Once data is finished we have mail for delivery or relaying.
						// Add the Received header.
						mailTransaction.AddHeader("Received", string.Format("from {0}[{1}] by {2}[{3}] on {4}",
							heloHost,
							smtpStream.RemoteAddress.ToString(),
							GetServerHostname(client),
							smtpStream.LocalAddress.ToString(),
							DateTime.UtcNow.ToString("ddd, dd MMM yyyy HH':'mm':'ss K")));

						// Use the default IP Group ID. Should add logic to look at some kind of X- header and use that instead.
						mailTransaction.Save();

						// Done with transaction, clear it and inform client message success and QUEUED
						mailTransaction = null;
						await smtpStream.WriteLineAsync("250 Message queued for delivery");
						continue;
					}

					#endregion


					// If got this far then we don't known the command.
					await smtpStream.WriteLineAsync("500 Unknown command");
				}
			}
			catch (System.IO.IOException) { /* Connection timeout */ }
			finally
			{
				// Client has issued QUIT command or connecion lost.
				client.Close();
			}

			return true;
		}
		
		/// <summary>
		/// Gets the hostname for the server that is being connected to by client.
		/// </summary>
		/// <param name="client"></param>
		/// <returns></returns>
		private string GetServerHostname(TcpClient client)
		{
			string serverIPAddress = (client.Client.LocalEndPoint as IPEndPoint).Address.ToString();
			string serverHost = string.Empty;
			try
			{
				serverHost = Dns.GetHostEntry(serverIPAddress).HostName;
			}
			catch (Exception)
			{
				// Host doesn't have reverse DNS. Use IP Address.
				serverHost = serverIPAddress;
			}

			return serverHost;
		}
	}
}
