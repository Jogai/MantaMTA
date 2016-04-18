﻿using System;
using System.Linq;
using System.Net;
using System.Web.Http;
using OpenManta.Core;
using OpenManta.WebLib;
using OpenManta.Data;
using WebInterface.Models;

namespace WebInterface.Controllers.API
{
    /// <summary>
	/// Summary description for VirtualMtaService
	/// </summary>
	[RoutePrefix("api/VirtualMta")]
    public class VirtualMtaController : ApiController
    {
        [HttpGet]
        [Route("Save")]
        public bool Save()
        {
            return true;
        }
        
        /// <summary>
        /// Updates an existing Virtual MTA.
        /// </summary>
        /// <param name="viewModel"></param>
        /// <returns>TRUE if updated or FALSE if update failed.</returns>
        [HttpPost]
        [Route("Save")]
        public bool Save(SaveViewModel viewModel)
        {
            VirtualMTA vMTA = null;

            if (viewModel.Id != WebInterfaceParameters.VIRTUALMTA_NEW_ID)
                vMTA = VirtualMtaDB.GetVirtualMta(viewModel.Id);
            else
                vMTA = new VirtualMTA();

            if (vMTA == null)
                return false;

            if (string.IsNullOrWhiteSpace(viewModel.HostName))
                return false;

            IPAddress ip = null;
            try
            {
                ip = IPAddress.Parse(viewModel.IpAddress);
            }
            catch (Exception)
            {
                return false;
            }

            vMTA.Hostname = viewModel.HostName;
            vMTA.IPAddress = ip;
            vMTA.IsSmtpInbound = viewModel.Inbound;
            vMTA.IsSmtpOutbound = viewModel.Outbound;
            OpenManta.WebLib.DAL.VirtualMtaDB.Save(vMTA);
            return true;
        }

        /// <summary>
		/// Deletes the specified Virtual MTA.
		/// </summary>
		/// <param name="viewModel"></param>
		[HttpPost]
        [Route("Delete")]
        public void Delete(DeleteViewModel viewModel)
        {
            OpenManta.WebLib.DAL.VirtualMtaDB.Delete(viewModel.Id);
        }

        /// <summary>
		/// Saves the Virtual MTA Group.
		/// </summary>
		/// <param name="viewModel"></param>
		/// <returns>TRUE if saved or FALSE if not saved.</returns>
		[HttpPost]
        [Route("SaveGroup")]
        public bool SaveGroup(SaveGroupViewModel viewModel)
        {
            VirtualMtaGroup grp = null;
            if (viewModel.Id == WebInterfaceParameters.VIRTUALMTAGROUP_NEW_ID)
                grp = new VirtualMtaGroup();
            else
                grp = VirtualMtaGroupDB.GetVirtualMtaGroup(viewModel.Id);

            if (grp == null)
                return false;

            grp.Name = viewModel.Name;
            grp.Description = viewModel.Description;

            var vMtas = VirtualMtaDB.GetVirtualMtas();
            for (int i = 0; i < viewModel.MtaIDs.Length; i++)
            {
                VirtualMTA mta = vMtas.SingleOrDefault(m => m.ID == viewModel.MtaIDs[i]);
                if (mta == null)
                    return false;
                grp.VirtualMtaCollection.Add(mta);
            }

            VirtualMtaWebManager.Save(grp);
            return true;
        }

        /// <summary>
		/// Deletes a Virtual MTA Group.
		/// </summary>
		/// <param name="id">ID of the Virtual MTA Group to delete.</param>
		[HttpPost]
        [Route("DeleteGroup")]
        public void DeleteGroup(DeleteGroupViewModel viewModel)
        {
            VirtualMtaWebManager.DeleteGroup(viewModel.Id);
        }
    }
}
