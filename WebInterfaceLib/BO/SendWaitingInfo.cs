﻿using System.Collections.Generic;

namespace WebInterfaceLib.BO
{
	/// <summary>
	/// Holds a next attempt number and how many messages are currently waiting for sending.
	/// </summary>
	public class SendWaitingInfo
	{
		/// <summary>
		/// The next attempt number.
		/// </summary>
		public int AttemptNumber { get; set; }

		/// <summary>
		/// The number of Emails waiting to make there next attempt.
		/// </summary>
		public int EmailsWaiting { get; set; }
	}

	/// <summary>
	/// Holds a collection of SendWaitingInfo.
	/// </summary>
	public class SendWaitingInfoCollection : List<SendWaitingInfo>
	{
		public SendWaitingInfoCollection() { }
		public SendWaitingInfoCollection(IEnumerable<SendWaitingInfo> collection) : base(collection) { }
	}
}