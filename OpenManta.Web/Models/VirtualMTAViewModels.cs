namespace WebInterface.Models
{ 
    public class SaveViewModel
    {
        /// <summary>
        /// ID of the virtual MTA.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Hostname of the Virtual MTA.
        /// </summary>
        public string HostName { get; set; }

        /// <summary>
        /// IP Address of the Virtual MTA.
        /// </summary>
        public string IpAddress { get; set; }

        /// <summary>
        /// TRUE if the Virtual MTA can accept inbound Email.
        /// </summary>
        public bool Inbound { get; set; }

        /// <summary>
        /// TRUE if the Virtal MTA can send outbound Email.
        /// </summary>
        public bool Outbound { get; set; }
    }

    public class DeleteViewModel
    {
        /// <summary>
		/// ID of the Virtual MTA to delete.
		/// </summary>
        public int Id { get; set; }
    }

    public class SaveGroupViewModel
    {
        /// <summary>
        /// ID of the Virtual MTA Group to save.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Name of the Virtual MTA Group.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Description of the Virtual MTA Group.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// ID's of the VirtualMTAs that the Group should contain.
        /// </summary>
        public int[] MtaIDs { get; set; }
    }

    public class DeleteGroupViewModel
    {
        /// <summary>
		/// ID of the Virtual MTA Group to delete.
		/// </summary>
        public int Id { get; set; }
    }
}