using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LaPalace.ViewModel.FileOperations
{
    class FileSaver
    {
        public static string SaveFile()
        {
            Microsoft.Win32.SaveFileDialog dlg = new Microsoft.Win32.SaveFileDialog
            {
                DefaultExt = ".png",
                Filter = "PNG Files (*.png)|*.png"
            };
            if (dlg.ShowDialog() ?? false)
            {
                return dlg.FileName;
            }
            else return null;
        }
    }
}
