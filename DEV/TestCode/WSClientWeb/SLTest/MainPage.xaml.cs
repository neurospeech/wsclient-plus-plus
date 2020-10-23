using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Collections.ObjectModel;

namespace SLTest
{
    public partial class MainPage : UserControl
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            Orders.OrderServiceClient client = new Orders.OrderServiceClient();
            client.GetNewCompleted += new EventHandler<Orders.GetNewCompletedEventArgs>(client_GetNewCompleted);

            Orders.Product p = new Orders.Product();

            p.Name = "ads";
            p.ProductID = "fdsafds";
            p.Type = "Sample1";
            p.Object = new Orders.DataObject();
            p.Object.ObjectName = "as";

            client.GetNewAsync(p);

            ObservableCollection<long> ids = new ObservableCollection<long>(new long[]{4,5,5,6});
            client.VerifyProductsAsync(ids);
        }

        #region void  client_GetNewCompleted(object sender, Orders.GetNewCompletedEventArgs e)
        void client_GetNewCompleted(object sender, Orders.GetNewCompletedEventArgs e)
        {
            
        }
        #endregion


        #region void  client_ListProductsCompleted(object sender, Orders.ListProductsCompletedEventArgs e)
        void client_ListProductsCompleted(object sender, Orders.ListProductsCompletedEventArgs e)
        {
            
        }
        #endregion

    }
}
