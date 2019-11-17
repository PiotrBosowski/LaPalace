using System;
using System.Collections.Generic;
using System.Drawing;

namespace LaPalace.Model
{
    internal class ImageSplitter
    {
        internal static List<Bitmap> Split(Bitmap sourceImg, int threadsNo)
        {
            if (threadsNo == 1) return new List<Bitmap> { sourceImg };
            else return null;
        }
    }
}