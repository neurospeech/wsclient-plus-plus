using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WSClientSubscriber
{
    class Program
    {
        static void Main(string[] args)
        {

            do
            {
                try
                {
                    Comet comet = new Comet();
                    comet.Start();
                }
                catch (Exception ex) {
                    Console.WriteLine(ex.ToString());
                }
            } while (true);

        }
    }
}
