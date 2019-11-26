using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.IO;
using System.Windows.Media.Imaging;

namespace LaPalace.ViewModel.FileOperations
{
    class FileOpener
    {
        public static string OpenFile()
        {
            Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog
            {
                DefaultExt = ".bmp",
                Filter = "BMP Files (*.bmp)|*.bmp"
            };
            if (dlg.ShowDialog() ?? false)
            {
                return dlg.FileName;
            }
            else return null;
        }

        public static Bitmap LoadImage(string imagePath)
        {
            try
            {
                return new Bitmap(imagePath);
            }
            catch(FileNotFoundException) // seems like its not working Xd
            {
                return null;
            }
            catch(ArgumentException) // works fine
            {
               return null;
            }
        }

        public static BitmapImage BitmapToImageSource(Bitmap bitmap)
        {
            using (MemoryStream memory = new MemoryStream())
            {
                bitmap.Save(memory, System.Drawing.Imaging.ImageFormat.Bmp);
                memory.Position = 0;
                BitmapImage bitmapimage = new BitmapImage();
                bitmapimage.BeginInit();
                bitmapimage.StreamSource = memory;
                bitmapimage.CacheOption = BitmapCacheOption.OnLoad;
                bitmapimage.EndInit();

                return bitmapimage;
            }
        }
    }
}
