using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace LaPalace.Model
{
    unsafe class CppTest
    {
        [DllImport(@"D:\c#\LaPalace\Debug\LaPlace_Cpplib.dll", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.Cdecl)]
        private extern static void transformSingleImage(byte* input, byte* output, int height, int width);

        public static Bitmap TransformSingleImage(Bitmap input, Bitmap output, int height, int width)
        {
            BitmapData inputData = input.LockBits(new Rectangle(0, 0, input.Width, input.Height), ImageLockMode.ReadOnly, input.PixelFormat);
            BitmapData outputData = output.LockBits(new Rectangle(0, 0, output.Width, output.Height), ImageLockMode.ReadWrite, output.PixelFormat);
            byte* input_scan0 = (byte*)inputData.Scan0.ToPointer();
            byte* output_scan0 = (byte*)outputData.Scan0.ToPointer();
            transformSingleImageCSHARP(input_scan0, output_scan0, height, width, inputData.Stride, outputData.Stride, Image.GetPixelFormatSize(input.PixelFormat), Image.GetPixelFormatSize(output.PixelFormat));
            input.UnlockBits(inputData);
            output.UnlockBits(outputData);
            return output;
        }

        private static void transformSingleImageCSHARP(byte* input_scan0, byte* output_scan0, int height, int width, int inputStride, int outputStride, int inputBitsPerPixel, int outputBitsPerPixel)
        {
            int[,] pattern =
            {
                { -1, -1, -1},
                { -1, 8,  -1},
                { -1,  -1, -1}
            };
            for (int i = 1; i < height - 1; ++i)
                for (int j = 1; j < width - 1; ++j)
                    for (int color = 0; color < 3; color++)
                    {
                        int newPixelValue = Convert.ToInt32(Pixel(input_scan0, j, i, inputStride, inputBitsPerPixel)[color]) * pattern[1, 1];
                        newPixelValue += Pixel(input_scan0, j - 1, i - 1, inputStride, inputBitsPerPixel)[color] * pattern[0, 0];
                        newPixelValue += Pixel(input_scan0, j + 0, i - 1, inputStride, inputBitsPerPixel)[color] * pattern[0, 1];
                        newPixelValue += Pixel(input_scan0, j + 1, i - 1, inputStride, inputBitsPerPixel)[color] * pattern[0, 2];
                        newPixelValue += Pixel(input_scan0, j - 1, i + 0, inputStride, inputBitsPerPixel)[color] * pattern[1, 0];
                        newPixelValue += Pixel(input_scan0, j + 1, i + 0, inputStride, inputBitsPerPixel)[color] * pattern[1, 2];
                        newPixelValue += Pixel(input_scan0, j - 1, i + 1, inputStride, inputBitsPerPixel)[color] * pattern[2, 0];
                        newPixelValue += Pixel(input_scan0, j + 0, i + 1, inputStride, inputBitsPerPixel)[color] * pattern[2, 1];
                        newPixelValue += Pixel(input_scan0, j + 1, i + 1, inputStride, inputBitsPerPixel)[color] * pattern[2, 2];
                        newPixelValue = newPixelValue > 255 ? 255 : newPixelValue < 0 ? 0 : newPixelValue;
                        Pixel(output_scan0, j, i, outputStride, outputBitsPerPixel)[color] = Convert.ToByte(newPixelValue);
                    }
        }

        private static byte* Pixel(byte* scan0, int x, int y, int stride, int bitsPerPixel)
        {
            return scan0 + y * stride + x * bitsPerPixel / 8;
        }

        private static void purplesator(byte* input_scan0, byte* output_scan0, int height, int width, int stride, int bitsPerPixel)
        {
            int[,] pattern =
            {
                {0, 2, 0},
                {2, -8, 2},
                {0, 2, 0}
            };
            for (int i = 0; i < height; ++i)
                for (int j = 0; j < width; ++j)
                {
                    byte* data = output_scan0 + i * stride + j * bitsPerPixel / 8;

                    //data[0] = 0;
                    data[1] = 0;
                    //data[2] = 0;

                }

        }
    }
}
