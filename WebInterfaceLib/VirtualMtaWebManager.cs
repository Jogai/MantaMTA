﻿using MantaMTA.Core.DAL;
using MantaMTA.Core.VirtualMta;

namespace WebInterfaceLib
{
	public static class VirtualMtaWebManager
	{
		/// <summary>
		/// Get a collection of all of the Virtual MTA Groups.
		/// </summary>
		/// <returns></returns>
		public static VirtualMtaGroupCollection GetAllVirtualMtaGroups()
		{
			VirtualMtaGroupCollection ipGroups = VirtualMtaGroupDB.GetVirtualMtaGroups();
			
			// Get all the groups Virtual MTAs.
			foreach (VirtualMtaGroup grp in ipGroups)
			{
				grp.VirtualMtaCollection = VirtualMtaDB.GetVirtualMtasInVirtualMtaGroup(grp.ID);
			}

			return ipGroups;
		}

		public static VirtualMtaGroup GetVirtualMtaGroup(int id)
		{
			return null;
		}
	}
}