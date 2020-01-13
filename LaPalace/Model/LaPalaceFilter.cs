using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.ExceptionServices;
using System.Runtime.InteropServices;

namespace LaPalace.Model
{
    /// <summary>
    /// Class used to apply LaPlace filter to the image (it always returns new image, original source stays untouched)
    /// </summary>
    public unsafe class LaPalaceFilter
    {
        readonly int[] LAPL1 = { -1, -1, -1, -1, 8, -1, -1, -1, -1 };
        readonly int[] LAPL2 = { 0, -1, 0, -1, 4, -1, 0, -1, 0 };
        readonly int[] LAPL3 = { 1, -2, 1, -2, 4, -2, 1, -2, 1 };
        readonly int[] DIAG = { -1, 0, -1, 0, 4, 0, -1, 0, -1 };
        readonly int[] HORIZ = { 0, -1, 0, 0, 2, 0, 0, -1, 0 };
        readonly int[] VERTIC = { 0, 0, 0, -1, 2, -1, 0, 0, 0 };

        private int[] pattern;
        LibraryChoices library;
        private Bitmap input;
        private int threadsNo;

        /// <summary>
        /// Private constructor invoked by "Run" method.
        /// </summary>
        /// <param name="bitmap">Source image</param>
        /// <param name="algorythm">Enum indicating which LaPlace algorythm will be used</param>
        /// <param name="library">Enum saying which library will be used (C or ASM)</param>
        /// <param name="threadsNo">Number of pieces in which input image will be split and calculated paralelly</param>
        private LaPalaceFilter(Bitmap bitmap, AlgorythmChoices alg, LibraryChoices lib, int threadsNo)
        {
            this.threadsNo = threadsNo;
            this.library = lib;
            this.input = bitmap;
            switch(alg)
            {
                case AlgorythmChoices.LAPL1: pattern = LAPL1; break;
                case AlgorythmChoices.LAPL2: pattern = LAPL2; break;
                case AlgorythmChoices.LAPL3: pattern = LAPL3; break;
                case AlgorythmChoices.DIAG: pattern = DIAG; break;
                case AlgorythmChoices.HORIZ: pattern = HORIZ; break;
                case AlgorythmChoices.VERTIC: pattern = VERTIC; break;
            }
        }

        internal static Bitmap Run(Bitmap bitmap, AlgorythmChoices alg, LibraryChoices lib, int threadsNo)
        {
            if (bitmap == null) return null;
            if (threadsNo < 1 || threadsNo > 64) return null;

            LaPalaceFilter filter = new LaPalaceFilter(bitmap, alg, lib, threadsNo);

            return filter.Run();
        }

        //[HandleProcessCorruptedStateExceptions]
        private Bitmap Run()
        {
            Bitmap output = new Bitmap(input);
            //List<Bitmap> splittedInputBitmap = ImageSplitter.Split(inputBitmap, threadsNo);
            //List<Bitmap> splittedOutputBitmap = ImageSplitter.Split(outputBitmap, threadsNo);
            //Transform(splittedInputBitmap, splittedOutputBitmap);
            BitmapData inputData = input.LockBits(new Rectangle(0, 0, input.Width, input.Height), ImageLockMode.ReadOnly, input.PixelFormat);
            BitmapData outputData = output.LockBits(new Rectangle(0, 0, output.Width, output.Height), ImageLockMode.WriteOnly, output.PixelFormat);
            byte* inputPtr = (byte*)inputData.Scan0.ToPointer();
            byte* outputPtr = (byte*)outputData.Scan0.ToPointer();
            int height = input.Height;
            int width = input.Width;
            int inputStr = inputData.Stride;
            int outputStr = outputData.Stride;
            int inputGPP = Image.GetPixelFormatSize(input.PixelFormat);
            int outputGPP = Image.GetPixelFormatSize(output.PixelFormat);
            if (library == LibraryChoices.ASM)
            {
                TransformImageAsm(inputPtr, outputPtr, height, width, inputStr, outputStr, inputGPP, outputGPP, pattern);
            }
            else if (library == LibraryChoices.C)
                TransformImageCpp(inputPtr, outputPtr, height, width, inputStr, outputStr, inputGPP, outputGPP, pattern);
            else
            { //add benchmarking ...
                TransformImageAsm(inputPtr, outputPtr, input.Height, input.Width, inputData.Stride, outputData.Stride, Image.GetPixelFormatSize(input.PixelFormat), Image.GetPixelFormatSize(output.PixelFormat), pattern);
                TransformImageCpp(inputPtr, outputPtr, input.Height, input.Width, inputData.Stride, outputData.Stride, Image.GetPixelFormatSize(input.PixelFormat), Image.GetPixelFormatSize(output.PixelFormat), pattern);
            }
            input.UnlockBits(inputData);
            output.UnlockBits(outputData);
            return output;
        }

        [DllImport(@"D:\c#\LaPalace\LaPalace\x64\Debug\LaPlace_Cpplib.dll", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private extern static void TransformImageCpp(byte* input, byte* output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int[] pattern);

        [DllImport(@"D:\c#\LaPalace\LaPalace\x64\Debug\LaPlace_Asmlib.dll", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
        private extern static void TransformImageAsm(byte* input, byte* output, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel, int[] pattern);

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
}
