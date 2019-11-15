using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LaPalace.Model
{
    public class LaPalaceFilter
    {
        public LaPalaceFilter()
        {

        }

        internal static bool ApplyFilter(Bitmap bitmap)
        {
            if (bitmap == null) return false;
            else
            {
                
            }
            return true; 
        }
    }

    public enum AlgorythmChoices
    {
        LAPL1,
        LAPL2,
        LAPL3,
        DIAG,
        HORIZ,
        VERTIC
    }

    public enum LibraryChoices
    {
        ASM,
        C,
        Both
    }
}


