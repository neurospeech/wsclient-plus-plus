using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WSClientCloudService.Models
{
    public partial class WSJob
    {
        public string StatusUrl
        {
            get
            {
                return "/api/jobs/status/" + JobID;
            }
            set
            {
            }
        }

    }
}