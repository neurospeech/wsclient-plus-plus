
using System;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Core.Objects.DataClasses;
using System.Data.Entity.Core.EntityClient;
using System.ComponentModel;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using System.Text;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using NeuroSpeech.WebAtoms.Entity;
using System.Reflection;
using System.Linq.Expressions;
using System.Web;
using System.Security.Cryptography;


[assembly: EdmSchemaAttribute()]
/// Relationship Metadata
#region EDM Relationship Metadata

[assembly: EdmRelationshipAttribute("WSClientModel", "FK_WSJobs_WSUsers", "WSUsersUserID", System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity.ZeroOrOne, typeof(WSClientCloudService.Models.WSUser), "WSJobsOwnerID", System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity.Many, typeof(WSClientCloudService.Models.WSJob), true)]
[assembly: EdmRelationshipAttribute("WSClientModel", "FK_WSJobs_WSUsers1", "WSUsersUserID", System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity.ZeroOrOne, typeof(WSClientCloudService.Models.WSUser), "WSJobsAssigneeID", System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity.Many, typeof(WSClientCloudService.Models.WSJob), true)]

#endregion

namespace WSClientCloudService.Models
{
   
   #region Contexts
   
   /// <summary>
   /// No Metadata Documentation available.
   /// </summary>
   public partial class WSClientModelEntities : AtomObjectContext 
   {
		#region Constructors
		
		/// <summary>
		/// Initializes a new WSClientModelEntities object using the connection string found in the 'WSClientModelEntities' section of the application configuration file.
		/// </summary>
	    public WSClientModelEntities() : base("name=WSClientModelEntities", "WSClientModelEntities")
	    {
			this.ContextOptions.LazyLoadingEnabled = true;
	        OnContextCreated();
	    }
		
		/// <summary>
		/// Initialize a new WSClientModelEntities object.
		/// </summary>
	    public WSClientModelEntities(string connectionString) : base(connectionString, "WSClientModelEntities")
	    {
			this.ContextOptions.LazyLoadingEnabled = true;
	        OnContextCreated();
	    }
		
        /// <summary>
        /// Initialize a new WSClientModelEntities object.
        /// </summary>
	    public WSClientModelEntities(EntityConnection connection) : base(connection, "WSClientModelEntities")
	    {
			this.ContextOptions.LazyLoadingEnabled = true;
	        OnContextCreated();
	    }
		
		#endregion
		
		#region Partial Methods
		
    	partial void OnContextCreated();		
		
		#endregion
		
		#region ObjectSet Properties
		
		        
		/// <summary>
        /// No Metadata Documentation available.
        /// </summary>
		public ObjectSet<Setting> Settings
		{
			get
			{
				if((_Settings == null))
				{
					_Settings = base.CreateObjectSet<Setting>("Settings");
				}
				return _Settings;
			}
		}
		private ObjectSet<Setting> _Settings;

	            
		/// <summary>
        /// No Metadata Documentation available.
        /// </summary>
		public ObjectSet<WSJob> WSJobs
		{
			get
			{
				if((_WSJobs == null))
				{
					_WSJobs = base.CreateObjectSet<WSJob>("WSJobs");
				}
				return _WSJobs;
			}
		}
		private ObjectSet<WSJob> _WSJobs;

	            
		/// <summary>
        /// No Metadata Documentation available.
        /// </summary>
		public ObjectSet<WSUser> WSUsers
		{
			get
			{
				if((_WSUsers == null))
				{
					_WSUsers = base.CreateObjectSet<WSUser>("WSUsers");
				}
				return _WSUsers;
			}
		}
		private ObjectSet<WSUser> _WSUsers;

	    		
		#endregion
		
		
		
   }
   #endregion

   #region Entities
   
   
      
   /// <summary>
   /// No Metadata Documentation available.
   /// </summary>
   [EdmEntityTypeAttribute(NamespaceName="WSClientModel", Name="Setting")]
   [Serializable()]
   [DataContractAttribute(IsReference=true)]
   // Adding Metadata Type
   public partial class Setting : AtomEntity
   {	    
   

		#region Primitive Properties
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=true, IsNullable=false)]

		        [DataMemberAttribute()]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]
[System.ComponentModel.DataAnnotations.StringLength(900, ErrorMessage=@"Setting.Key cannot exceed 900 characters")]


		public virtual global::System.String Key
		{
			get
			{
				return _Key;
			}
			set
			{
				if(_Key == value)
					return;
				OnKeyChanging(value);
				ReportPropertyChanging("Key");
								
				_Key = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("Key");
				OnKeyChanged();
			}
		}
		private global::System.String _Key;
		partial void OnKeyChanging(global::System.String value);
		partial void OnKeyChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]


		public virtual global::System.String Value
		{
			get
			{
				return _Value;
			}
			set
			{
				if(_Value == value)
					return;
				OnValueChanging(value);
				ReportPropertyChanging("Value");
								
				_Value = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("Value");
				OnValueChanged();
			}
		}
		private global::System.String _Value;
		partial void OnValueChanging(global::System.String value);
		partial void OnValueChanged();		
		
			
		#endregion
		
		#region Navigation Properties	
				
		#endregion
		
   }
   
   		
      
   /// <summary>
   /// No Metadata Documentation available.
   /// </summary>
   [EdmEntityTypeAttribute(NamespaceName="WSClientModel", Name="WSJob")]
   [Serializable()]
   [DataContractAttribute(IsReference=true)]
   // Adding Metadata Type
   public partial class WSJob : AtomEntity
   {	    
   

		#region Primitive Properties
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=true, IsNullable=false)]

		        [DataMemberAttribute()]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]


		public virtual global::System.Int64 JobID
		{
			get
			{
				return _JobID;
			}
			set
			{
				if(_JobID == value)
					return;
				OnJobIDChanging(value);
				ReportPropertyChanging("JobID");
								
				_JobID = StructuralObject.SetValidValue(value);
								ReportPropertyChanged("JobID");
				OnJobIDChanged();
			}
		}
		private global::System.Int64 _JobID;
		partial void OnJobIDChanging(global::System.Int64 value);
		partial void OnJobIDChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.StringLength(1024, ErrorMessage=@"WSJob.WSDLUrl cannot exceed 1024 characters")]


		public virtual global::System.String WSDLUrl
		{
			get
			{
				return _WSDLUrl;
			}
			set
			{
				if(_WSDLUrl == value)
					return;
				OnWSDLUrlChanging(value);
				ReportPropertyChanging("WSDLUrl");
								
				_WSDLUrl = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("WSDLUrl");
				OnWSDLUrlChanged();
			}
		}
		private global::System.String _WSDLUrl;
		partial void OnWSDLUrlChanging(global::System.String value);
		partial void OnWSDLUrlChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]


		public virtual global::System.DateTime StartTime
		{
			get
			{
				return _StartTime;
			}
			set
			{
				if(_StartTime == value)
					return;
				OnStartTimeChanging(value);
				ReportPropertyChanging("StartTime");
								
				_StartTime = StructuralObject.SetValidValue(value);
								ReportPropertyChanged("StartTime");
				OnStartTimeChanged();
			}
		}
		private global::System.DateTime _StartTime;
		partial void OnStartTimeChanging(global::System.DateTime value);
		partial void OnStartTimeChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		

		public virtual global::System.DateTime? EndTime
		{
			get
			{
				return _EndTime;
			}
			set
			{
				if(_EndTime == value)
					return;
				OnEndTimeChanging(value);
				ReportPropertyChanging("EndTime");
								
				_EndTime = StructuralObject.SetValidValue(value);
								ReportPropertyChanged("EndTime");
				OnEndTimeChanged();
			}
		}
		private global::System.DateTime? _EndTime;
		partial void OnEndTimeChanging(global::System.DateTime? value);
		partial void OnEndTimeChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.StringLength(10, ErrorMessage=@"WSJob.JobStatus cannot exceed 10 characters")]


		public virtual global::System.String JobStatus
		{
			get
			{
				return _JobStatus;
			}
			set
			{
				if(_JobStatus == value)
					return;
				OnJobStatusChanging(value);
				ReportPropertyChanging("JobStatus");
								
				_JobStatus = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("JobStatus");
				OnJobStatusChanged();
			}
		}
		private global::System.String _JobStatus;
		partial void OnJobStatusChanging(global::System.String value);
		partial void OnJobStatusChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.StringLength(900, ErrorMessage=@"WSJob.ResultUrl cannot exceed 900 characters")]


		public virtual global::System.String ResultUrl
		{
			get
			{
				return _ResultUrl;
			}
			set
			{
				if(_ResultUrl == value)
					return;
				OnResultUrlChanging(value);
				ReportPropertyChanging("ResultUrl");
								
				_ResultUrl = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("ResultUrl");
				OnResultUrlChanged();
			}
		}
		private global::System.String _ResultUrl;
		partial void OnResultUrlChanging(global::System.String value);
		partial void OnResultUrlChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]


		public virtual global::System.Boolean IsDemo
		{
			get
			{
				return _IsDemo;
			}
			set
			{
				if(_IsDemo == value)
					return;
				OnIsDemoChanging(value);
				ReportPropertyChanging("IsDemo");
								
				_IsDemo = StructuralObject.SetValidValue(value);
								ReportPropertyChanged("IsDemo");
				OnIsDemoChanged();
			}
		}
		private global::System.Boolean _IsDemo;
		partial void OnIsDemoChanging(global::System.Boolean value);
		partial void OnIsDemoChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]
[System.ComponentModel.DataAnnotations.StringLength(50, ErrorMessage=@"WSJob.OutputType cannot exceed 50 characters")]


		public virtual global::System.String OutputType
		{
			get
			{
				return _OutputType;
			}
			set
			{
				if(_OutputType == value)
					return;
				OnOutputTypeChanging(value);
				ReportPropertyChanging("OutputType");
								
				_OutputType = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("OutputType");
				OnOutputTypeChanged();
			}
		}
		private global::System.String _OutputType;
		partial void OnOutputTypeChanging(global::System.String value);
		partial void OnOutputTypeChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

					[NeuroSpeech.WebAtoms.Entity.Audit.FKProperty("WSUser","UserID")]
					[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.StringLength(400, ErrorMessage=@"WSJob.OwnerID cannot exceed 400 characters")]


		public virtual global::System.String OwnerID
		{
			get
			{
				return _OwnerID;
			}
			set
			{
				if(_OwnerID == value)
					return;
				OnOwnerIDChanging(value);
				ReportPropertyChanging("OwnerID");
								
				_OwnerID = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("OwnerID");
				OnOwnerIDChanged();
			}
		}
		private global::System.String _OwnerID;
		partial void OnOwnerIDChanging(global::System.String value);
		partial void OnOwnerIDChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

					[NeuroSpeech.WebAtoms.Entity.Audit.FKProperty("WSUser","UserID")]
					[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.StringLength(400, ErrorMessage=@"WSJob.AssigneeID cannot exceed 400 characters")]


		public virtual global::System.String AssigneeID
		{
			get
			{
				return _AssigneeID;
			}
			set
			{
				if(_AssigneeID == value)
					return;
				OnAssigneeIDChanging(value);
				ReportPropertyChanging("AssigneeID");
								
				_AssigneeID = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("AssigneeID");
				OnAssigneeIDChanged();
			}
		}
		private global::System.String _AssigneeID;
		partial void OnAssigneeIDChanging(global::System.String value);
		partial void OnAssigneeIDChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]


		public virtual global::System.Int32 Usage
		{
			get
			{
				return _Usage;
			}
			set
			{
				if(_Usage == value)
					return;
				OnUsageChanging(value);
				ReportPropertyChanging("Usage");
								
				_Usage = StructuralObject.SetValidValue(value);
								ReportPropertyChanged("Usage");
				OnUsageChanged();
			}
		}
		private global::System.Int32 _Usage;
		partial void OnUsageChanging(global::System.Int32 value);
		partial void OnUsageChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]
[System.ComponentModel.DataAnnotations.StringLength(50, ErrorMessage=@"WSJob.OutputTarget cannot exceed 50 characters")]


		public virtual global::System.String OutputTarget
		{
			get
			{
				return _OutputTarget;
			}
			set
			{
				if(_OutputTarget == value)
					return;
				OnOutputTargetChanging(value);
				ReportPropertyChanging("OutputTarget");
								
				_OutputTarget = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("OutputTarget");
				OnOutputTargetChanged();
			}
		}
		private global::System.String _OutputTarget;
		partial void OnOutputTargetChanging(global::System.String value);
		partial void OnOutputTargetChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.StringLength(50, ErrorMessage=@"WSJob.OutputPackage cannot exceed 50 characters")]


		public virtual global::System.String OutputPackage
		{
			get
			{
				return _OutputPackage;
			}
			set
			{
				if(_OutputPackage == value)
					return;
				OnOutputPackageChanging(value);
				ReportPropertyChanging("OutputPackage");
								
				_OutputPackage = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("OutputPackage");
				OnOutputPackageChanged();
			}
		}
		private global::System.String _OutputPackage;
		partial void OnOutputPackageChanging(global::System.String value);
		partial void OnOutputPackageChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.StringLength(50, ErrorMessage=@"WSJob.OutputPrefix cannot exceed 50 characters")]


		public virtual global::System.String OutputPrefix
		{
			get
			{
				return _OutputPrefix;
			}
			set
			{
				if(_OutputPrefix == value)
					return;
				OnOutputPrefixChanging(value);
				ReportPropertyChanging("OutputPrefix");
								
				_OutputPrefix = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("OutputPrefix");
				OnOutputPrefixChanged();
			}
		}
		private global::System.String _OutputPrefix;
		partial void OnOutputPrefixChanging(global::System.String value);
		partial void OnOutputPrefixChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		

		public virtual global::System.String TriggerEmail
		{
			get
			{
				return _TriggerEmail;
			}
			set
			{
				if(_TriggerEmail == value)
					return;
				OnTriggerEmailChanging(value);
				ReportPropertyChanging("TriggerEmail");
								
				_TriggerEmail = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("TriggerEmail");
				OnTriggerEmailChanged();
			}
		}
		private global::System.String _TriggerEmail;
		partial void OnTriggerEmailChanging(global::System.String value);
		partial void OnTriggerEmailChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		

		public virtual global::System.String TriggerUrl
		{
			get
			{
				return _TriggerUrl;
			}
			set
			{
				if(_TriggerUrl == value)
					return;
				OnTriggerUrlChanging(value);
				ReportPropertyChanging("TriggerUrl");
								
				_TriggerUrl = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("TriggerUrl");
				OnTriggerUrlChanged();
			}
		}
		private global::System.String _TriggerUrl;
		partial void OnTriggerUrlChanging(global::System.String value);
		partial void OnTriggerUrlChanged();		
		
			
		#endregion
		
		#region Navigation Properties	
				
		
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [XmlIgnoreAttribute()]
        [SoapIgnoreAttribute()]
        [DataMemberAttribute()]
        [EdmRelationshipNavigationPropertyAttribute("WSClientModel", "FK_WSJobs_WSUsers", "WSUsersUserID")]
						
		public WSUser Owner
		{
            get
            {
                return ((IEntityWithRelationships)this).RelationshipManager.GetRelatedReference<WSUser>("WSClientModel.FK_WSJobs_WSUsers", "WSUsersUserID").Value;
            }
            set
            {
                ((IEntityWithRelationships)this).RelationshipManager.GetRelatedReference<WSUser>("WSClientModel.FK_WSJobs_WSUsers", "WSUsersUserID").Value = value;
            }
			
		}	

		/// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [BrowsableAttribute(false)]
        [DataMemberAttribute()]
        [XmlIgnoreAttribute()]
        [SoapIgnoreAttribute()]
        public EntityReference<WSUser> OwnerReference
        {
            get
            {
                return ((IEntityWithRelationships)this).RelationshipManager.GetRelatedReference<WSUser>("WSClientModel.FK_WSJobs_WSUsers", "WSUsersUserID");
            }
            set
            {
                if ((value != null))
                {
                    ((IEntityWithRelationships)this).RelationshipManager.InitializeRelatedReference<WSUser>("WSClientModel.FK_WSJobs_WSUsers", "WSUsersUserID", value);
                }
            }
        }		
				
				
		
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [XmlIgnoreAttribute()]
        [SoapIgnoreAttribute()]
        [DataMemberAttribute()]
        [EdmRelationshipNavigationPropertyAttribute("WSClientModel", "FK_WSJobs_WSUsers1", "WSUsersUserID")]
						
		public WSUser Assignee
		{
            get
            {
                return ((IEntityWithRelationships)this).RelationshipManager.GetRelatedReference<WSUser>("WSClientModel.FK_WSJobs_WSUsers1", "WSUsersUserID").Value;
            }
            set
            {
                ((IEntityWithRelationships)this).RelationshipManager.GetRelatedReference<WSUser>("WSClientModel.FK_WSJobs_WSUsers1", "WSUsersUserID").Value = value;
            }
			
		}	

		/// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [BrowsableAttribute(false)]
        [DataMemberAttribute()]
        [XmlIgnoreAttribute()]
        [SoapIgnoreAttribute()]
        public EntityReference<WSUser> AssigneeReference
        {
            get
            {
                return ((IEntityWithRelationships)this).RelationshipManager.GetRelatedReference<WSUser>("WSClientModel.FK_WSJobs_WSUsers1", "WSUsersUserID");
            }
            set
            {
                if ((value != null))
                {
                    ((IEntityWithRelationships)this).RelationshipManager.InitializeRelatedReference<WSUser>("WSClientModel.FK_WSJobs_WSUsers1", "WSUsersUserID", value);
                }
            }
        }		
				
				
		#endregion
		
   }
   
   		
      
   /// <summary>
   /// No Metadata Documentation available.
   /// </summary>
   [EdmEntityTypeAttribute(NamespaceName="WSClientModel", Name="WSUser")]
   [Serializable()]
   [DataContractAttribute(IsReference=true)]
   // Adding Metadata Type
   public partial class WSUser : AtomEntity
   {	    
   

		#region Primitive Properties
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=true, IsNullable=false)]

		        [DataMemberAttribute()]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]
[System.ComponentModel.DataAnnotations.StringLength(400, ErrorMessage=@"WSUser.UserID cannot exceed 400 characters")]


		public virtual global::System.String UserID
		{
			get
			{
				return _UserID;
			}
			set
			{
				if(_UserID == value)
					return;
				OnUserIDChanging(value);
				ReportPropertyChanging("UserID");
								
				_UserID = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("UserID");
				OnUserIDChanged();
			}
		}
		private global::System.String _UserID;
		partial void OnUserIDChanging(global::System.String value);
		partial void OnUserIDChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		

		public virtual global::System.String PasswordHash
		{
			get
			{
				return _PasswordHash;
			}
			set
			{
				if(_PasswordHash == value)
					return;
				OnPasswordHashChanging(value);
				ReportPropertyChanging("PasswordHash");
								
				_PasswordHash = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("PasswordHash");
				OnPasswordHashChanged();
			}
		}
		private global::System.String _PasswordHash;
		partial void OnPasswordHashChanging(global::System.String value);
		partial void OnPasswordHashChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=true)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.StringLength(400, ErrorMessage=@"WSUser.EmailAddress cannot exceed 400 characters")]


		public virtual global::System.String EmailAddress
		{
			get
			{
				return _EmailAddress;
			}
			set
			{
				if(_EmailAddress == value)
					return;
				OnEmailAddressChanging(value);
				ReportPropertyChanging("EmailAddress");
								
				_EmailAddress = StructuralObject.SetValidValue(value, true);
								ReportPropertyChanged("EmailAddress");
				OnEmailAddressChanged();
			}
		}
		private global::System.String _EmailAddress;
		partial void OnEmailAddressChanging(global::System.String value);
		partial void OnEmailAddressChanged();		
		
				
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [EdmScalarPropertyAttribute(EntityKeyProperty=false, IsNullable=false)]

				[XmlIgnore]
		[System.Web.Script.Serialization.ScriptIgnore]
				
		[System.ComponentModel.DataAnnotations.Required(AllowEmptyStrings =true)]


		public virtual global::System.Boolean IsAdmin
		{
			get
			{
				return _IsAdmin;
			}
			set
			{
				if(_IsAdmin == value)
					return;
				OnIsAdminChanging(value);
				ReportPropertyChanging("IsAdmin");
								
				_IsAdmin = StructuralObject.SetValidValue(value);
								ReportPropertyChanged("IsAdmin");
				OnIsAdminChanged();
			}
		}
		private global::System.Boolean _IsAdmin;
		partial void OnIsAdminChanging(global::System.Boolean value);
		partial void OnIsAdminChanged();		
		
			
		#endregion
		
		#region Navigation Properties	
				
		
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [XmlIgnoreAttribute()]
        [SoapIgnoreAttribute()]
        [DataMemberAttribute()]
        [EdmRelationshipNavigationPropertyAttribute("WSClientModel", "FK_WSJobs_WSUsers", "WSJobsOwnerID")]
				
		public EntityCollection<WSJob> WSJobOwners
		{
            get
            {
                return ((IEntityWithRelationships)this).RelationshipManager.GetRelatedCollection<WSJob>("WSClientModel.FK_WSJobs_WSUsers", "WSJobsOwnerID");
            }
            set
            {
                if ((value != null))
                {
                    ((IEntityWithRelationships)this).RelationshipManager.InitializeRelatedCollection<WSJob>("WSClientModel.FK_WSJobs_WSUsers", "WSJobsOwnerID", value);
                }
            }			
		}		
				
		
        /// <summary>
        /// No Metadata Documentation available.
        /// </summary>
        [XmlIgnoreAttribute()]
        [SoapIgnoreAttribute()]
        [DataMemberAttribute()]
        [EdmRelationshipNavigationPropertyAttribute("WSClientModel", "FK_WSJobs_WSUsers1", "WSJobsAssigneeID")]
				
		public EntityCollection<WSJob> WSJobAssignees
		{
            get
            {
                return ((IEntityWithRelationships)this).RelationshipManager.GetRelatedCollection<WSJob>("WSClientModel.FK_WSJobs_WSUsers1", "WSJobsAssigneeID");
            }
            set
            {
                if ((value != null))
                {
                    ((IEntityWithRelationships)this).RelationshipManager.InitializeRelatedCollection<WSJob>("WSClientModel.FK_WSJobs_WSUsers1", "WSJobsAssigneeID", value);
                }
            }			
		}		
				
		#endregion
		
   }
   
   		
      #endregion
   
}

 