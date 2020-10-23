using NeuroSpeech.WebAtoms.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WSClientCloudService.Models
{
    public partial class WSClientModelEntities
    {

        public string UserID { get; set; }

        public IDisposable CreateSecurityScope(BaseSecurityContext s = null) {
            var old = this.SecurityContext;
            this.SecurityContext = s;
            return new DisposableAction(() => {
                this.SecurityContext = old;
            });
        }
        
    }

    public class DisposableAction : IDisposable
    {
        private Action action;
        public DisposableAction(Action action)
        {
            this.action = action;
        }

        public void Dispose()
        {
            action();
        }
    }
}