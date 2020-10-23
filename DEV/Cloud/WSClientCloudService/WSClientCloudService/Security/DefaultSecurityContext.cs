using NeuroSpeech.WebAtoms.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WSClientCloudService.Models;

namespace WSClientCloudService.Security
{
    public class DefaultSecurityContext : BaseSecurityContext<WSClientModelEntities>
    {

        public static DefaultSecurityContext Instance = new DefaultSecurityContext();

        public DefaultSecurityContext()
        {
            OnCreate();
        }

        private void OnCreate()
        {
            var p = CreateRule<WSJob>();
            p.SetRead(y => x => x.OwnerID == null || x.OwnerID == y.UserID);
            p.SetProperty(SerializeMode.Read,
                x => x.OwnerID,
                x => x.IsDemo,
                x => x.JobStatus,
                x => x.ResultUrl,
                x => x.WSDLUrl,
                x => x.OutputType,
                x => x.OutputPackage,
                x => x.OutputPrefix,
                x => x.OutputTarget,
                x => x.StartTime,
                x => x.EndTime,
                x => x.Usage);
            
        }

    }
}