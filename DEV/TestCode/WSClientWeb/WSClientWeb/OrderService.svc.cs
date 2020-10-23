using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace WSClientWeb
{
	// NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "OrderService" in code, svc and config file together.
	public class OrderService : IOrderService
	{



        public string VerifyProducts(long[] ids)
        {
            if (ids == null)
                return "Array is null";
            if (ids.Length == 0)
                return "Array is empty";
            return string.Join(",", ids.Select(x => x.ToString()));
        }

        public DataObject GetNew(Product p)
        {
            return null;
        }


        #region public Product[]  ListProducts()
        public Product[] ListProducts()
        {
            return new Product[] { new Product{ Name="Test"} };
        }
        #endregion

    }
}
