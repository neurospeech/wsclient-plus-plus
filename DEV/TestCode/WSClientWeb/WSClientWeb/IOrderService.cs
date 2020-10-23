using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace WSClientWeb
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IOrderService" in both code and config file together.
    [ServiceContract]
    public interface IOrderService
    {
        [OperationContract]
        Product[] ListProducts();

        [OperationContract]
        string VerifyProducts(Int64[] ids);

        [OperationContract]
        DataObject GetNew(Product p);
    }

    [DataContract(Namespace="http://schema1")]
    public class Product
    {
        [DataMember]
        public string Name { get; set; }

        [DataMember]
        public string ProductID { get; set; }

        [DataMember]
        public DataObject Object { get; set; }

        [DataMember]
        public SampleType Type { get; set; }
    }

    [DataContract(Namespace="http://schema2")]
    public class DataObject
    {
        [DataMember]
        public string ObjectName { get; set; }
    }

    [DataContract(Namespace = "http://schema3")]
    public enum SampleType
    {
        [EnumMember]
        Sample1,
        [EnumMember]
        Sample2
    }
}
