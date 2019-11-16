using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LaPalace.Model
{
    /// <summary>
    /// Class used to apply LaPlace filter to the image (it always returns new image, original source stays untouched)
    /// </summary>
    public class LaPalaceFilter
    {
        /// <summary>
        /// Private constructor invoked by "Run" method.
        /// </summary>
        /// <param name="bitmap">Source image</param>
        /// <param name="algorythm">Enum indicating which LaPlace algorythm will be used</param>
        /// <param name="library">Enum saying which library will be used (C or ASM)</param>
        /// <param name="threadsNo">Number of pieces in which input image will be split and calculated paralelly</param>
        private LaPalaceFilter(Bitmap bitmap, AlgorythmChoices alg, LibraryChoices lib, int threadsNo)
        {
            chosenAlg = alg;
            this.threadsNo = threadsNo;
            inputBitmap = bitmap;
            switch(alg)
            {
                case AlgorythmChoices.LAPL1: algorythm = new LAPL1(); break;
                case AlgorythmChoices.LAPL2: algorythm = new LAPL2(); break;
                case AlgorythmChoices.LAPL3: algorythm = new LAPL3(); break;
                case AlgorythmChoices.DIAG: algorythm = new DIAG(); break;
                case AlgorythmChoices.HORIZ: algorythm = new HORIZ(); break;
                case AlgorythmChoices.VERTIC: algorythm = new VERTIC(); break;
            }
        }


        internal static Bitmap Run(Bitmap bitmap, AlgorythmChoices alg, LibraryChoices lib, int threadsNo)
        {
            if (bitmap == null) return null;
            if (threadsNo < 1 || threadsNo > 64) return null;

            LaPalaceFilter filter = new LaPalaceFilter(bitmap, alg, lib, threadsNo);

            return filter.Run();
        }

        private Bitmap Run()
        {
            Bitmap outputBitmap = new Bitmap(inputBitmap);
            List<Bitmap> splittedInputBitmap = ImageSplitter.Split(inputBitmap, threadsNo);
            List<Bitmap> splittedOutputBitmap = ImageSplitter.Split(outputBitmap, threadsNo);
            Transform(splittedInputBitmap, splittedOutputBitmap);
            return null;
        }

        private void Transform(List<Bitmap> input, List<Bitmap> output)
        {
            for(int i = 0; i < input.Count; i++)
            {
                TransformSingleBitmap(input[i], output[i]);
            }

        }

        public static byte[] ImageToByte(Image img)
        {
            ImageConverter converter = new ImageConverter();
            return (byte[])converter.ConvertTo(img, typeof(byte[]));
        }

        private void TransformSingleBitmap(Bitmap input, Bitmap output)
        {
            for(int i = 1; i < input.Height - 1; i++)
            {
                for(int j = 1; j < input.Width - 1; j++)
                {
                    //output.
                }

            }
        }

        private Bitmap inputBitmap;

        private LaPalaceAlgorythm algorythm;

        private AlgorythmChoices chosenAlg;

        private int threadsNo;

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

    internal class LaPalaceAlgorythm
    {
        protected int[,] transformatMatrix;

        public Bitmap RunASM()
        {
            return null;
        }

        public Bitmap RunC()
        {
            return null;
        }
    }

    internal class LAPL1 : LaPalaceAlgorythm
    {
        public LAPL1()
        {
            transformatMatrix = new int[3, 3]
            {
                {  0, -1,  0 },
                { -1,  4, -1 },
                {  0, -1,  0 }
            };
        }
    }

    internal class LAPL2 : LaPalaceAlgorythm
    {
        public LAPL2()
        {
            transformatMatrix = new int[3, 3]
            {
                { -1, -1, -1 },
                { -1,  8, -1 },
                { -1, -1, -1 }
            };
        }
    }

    internal class LAPL3 : LaPalaceAlgorythm
    {
        public LAPL3()
        {
            transformatMatrix = new int[3, 3]
            {
                {  1, -2,  1 },
                { -2,  4, -2 },
                {  1, -2,  1 }
            };
        }
    }

    internal class DIAG : LaPalaceAlgorythm
    {
        public DIAG()
        {
            transformatMatrix = new int[3, 3]
            {
                { -1,  0, -1 },
                {  0,  4,  0 },
                { -1,  0, -1 }
            };
        }
    }

    internal class HORIZ : LaPalaceAlgorythm
    {
        public HORIZ()
        {
            transformatMatrix = new int[3, 3]
            {
                {  0, -1,  0 },
                {  0,  2,  0 },
                {  0, -1,  0 }
            };
        }
    }

    internal class VERTIC : LaPalaceAlgorythm
    {
        public VERTIC()
        {
            transformatMatrix = new int[3, 3]
            {
                {  0,  0,  0 },
                { -1,  2, -1 },
                {  0,  0,  0 }
            };
        }
    }
}
